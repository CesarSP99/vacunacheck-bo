import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'manual_screen.dart';
import 'qr_scan_screen.dart';
import '../widgets/custom_elevated_button.dart';
import '../utils/const.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> options = [
    {
      'text': 'QR',
      'icon': Icons.qr_code,
    },
    {
      'text': 'Manual',
      'icon': Icons.edit,
    },
  ];

  void onQRPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QRScanScreen()),
    );
  }

  void onManualPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ManualScreen()),
    );
  }

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: OvalBottomBorderClipper(),
            child: Container(
              color: Theme.of(context).accentColor,
              height: 120 + statusBarHeight,
            ),
          ),
          Positioned(
            right: -45,
            top: -30,
            child: ClipOval(
              child: Container(
                color: Colors.black.withOpacity(0.05),
                height: 150,
                width: 150,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(Constants.paddingSide),
            child: Column(
              children: <Widget>[
                SizedBox(height: 15),
                Text(
                  'Validador de Carnet de Vacunación',
                  style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w900,
                      color: Colors.white),
                ),
                SizedBox(height: 70),
                Container(
                  child: Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomElevatedButton(
                          icon: options[0]['icon'],
                          text: options[0]['text'],
                          onPressedAction: () => onQRPressed(context),
                        ),
                        CustomElevatedButton(
                          icon: options[1]['icon'],
                          text: options[1]['text'],
                          onPressedAction: () => onManualPressed(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
