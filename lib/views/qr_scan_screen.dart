import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:verificador_carnet_de_vacunacion_bo/utils/const.dart';
import 'package:wakelock/wakelock.dart';
import 'details_screen.dart';

class QRScanScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void initState() {
    super.initState();
    //Preventing screen to turn off
    Wakelock.enable();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        FittedBox(
                          child: ElevatedButton(
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                return Icon(
                                  snapshot.data.toString() == 'true'
                                      ? Icons.flash_on
                                      : Icons.flash_off,
                                  color: Colors.white,
                                );
                              },
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Constants.lightGreen,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        FittedBox(
                          child: ElevatedButton(
                            onPressed: () async {
                              await controller?.flipCamera();
                              setState(() {});
                            },
                            child: Icon(
                              Icons.flip_camera_android,
                              color: Colors.white,
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Constants.lightGreen,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(flex: 7, child: _buildQrView(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = 250.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: (controller) => {_onQRViewCreated(controller, context)},
      overlay: QrScannerOverlayShape(
        borderColor: Colors.green,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller, BuildContext context) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream
        .listen((scanData) => {onQRScanSuccesful(scanData, context)});
  }

  Future<void> onQRScanSuccesful(Barcode scanData, BuildContext context) async {
    controller!.pauseCamera();
    setState(() {
      result = scanData;
    });
    //Checking for valid COVID 19 vaccination QR to call details page
    if (result!.code
        .startsWith('https://sus.minsalud.gob.bo/busca_vacuna_dosisqr')) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(
              width: 15,
            ),
            Text('Validando datos...'),
          ],
        ),
      ));
      http.Response response = await http.get(Uri.parse(result!.code));
      var document = parse(response.body);
      if (document.getElementsByClassName('panel-body').isNotEmpty) {
        Map<String, String> details = Map.fromIterables(
          document
              .getElementsByTagName('dt')
              .map((e) => e.text.split(':').first)
              .toList(),
          document
              .getElementsByTagName('dd')
              .map((e) => e.text.split(':').first)
              .toList(),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(
              details: details,
            ),
          ),
        );
      } else {
        //Altered QR or fake COVID Vaccination card
        showInvalidDialog(context);
      }
    }
    controller!.resumeCamera();
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sin permisos de cámara')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    //Deactivating Wakelock
    Wakelock.disable();
    super.dispose();
  }

  void showInvalidDialog(BuildContext buildContext) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(children: [
            Icon(Icons.dangerous),
            Text("Carnet Falso"),
          ]),
          content: Text(
              "El carnet escaneado no se encuentra registrado en la base de datos del Ministerio"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
