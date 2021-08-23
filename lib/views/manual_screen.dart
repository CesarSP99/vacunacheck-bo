import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:html/parser.dart';
import '../utils/const.dart';
import 'package:http/http.dart' as http;

import 'details_screen.dart';

enum Dosis {
  Primera,
  Segunda,
}

class ManualScreen extends StatefulWidget {
  ManualScreen({Key? key}) : super(key: key);

  @override
  _ManualScreenState createState() => _ManualScreenState();
}

class _ManualScreenState extends State<ManualScreen> {
  Dosis dosis = Dosis.Primera;
  TextEditingController ci = TextEditingController();
  TextEditingController fechaDeNacimiento = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

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
              height: 95 + statusBarHeight,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 15),
                FittedBox(
                  child: Text(
                    'Consulta Manual',
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: 80),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      //Dose
                      Row(
                        children: [
                          Flexible(flex: 2, child: Text('Dosis: ')),
                          Radio<Dosis>(
                            value: Dosis.Primera,
                            groupValue: dosis,
                            onChanged: (dosis) {
                              setState(() {
                                this.dosis = dosis!;
                              });
                            },
                          ),
                          Text('1era'),
                          Radio<Dosis>(
                            value: Dosis.Segunda,
                            groupValue: dosis,
                            onChanged: (dosis) {
                              setState(() {
                                this.dosis = dosis!;
                              });
                            },
                          ),
                          Text('2da'),
                        ],
                      ),
                      SizedBox(height: 15),
                      //ID Number
                      TextField(
                        controller: ci,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Constants.lightGreen),
                          ),
                          labelText: "Nro. de Carnet de Identidad",
                          hintText: "(Sin complemento)",
                        ),
                      ),
                      SizedBox(height: 15),
                      //Birth Date
                      TextField(
                        controller: fechaDeNacimiento,
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Constants.lightGreen),
                          ),
                          labelText: "Fecha de Nacimiento",
                          hintText: "dd/mm/aaaa",
                        ),
                      ),
                      SizedBox(height: 25),
                      Container(
                        width: double.infinity,
                        child: Center(
                          child: FittedBox(
                            child: ElevatedButton(
                              child: Row(
                                children: [
                                  Icon(Icons.check),
                                  Text('Validar'),
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: Constants.lightGreen),
                              onPressed: () async {
                                Map<String, String> params = {
                                  'dosis': dosis == Dosis.Primera
                                      ? '1ra. DOSIS'
                                      : '2da DOSIS',
                                  'ci': ci.text,
                                  'fechanacimiento': fechaDeNacimiento.text,
                                };
                                if (!isDataValid(params)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Los valores ingresados no son válidos')),
                                  );
                                  return;
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Row(
                                        children: [
                                          CircularProgressIndicator(),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text('Validando datos...'),
                                        ],
                                      ),
                                    ),
                                  );
                                  Uri uri = Uri.https('sus.minsalud.gob.bo',
                                      '/busca_vacuna_dosisqr', params);
                                  http.Response response = await http.get(uri);
                                  var document = parse(response.body);
                                  if (document
                                      .getElementsByClassName('panel-body')
                                      .isNotEmpty) {
                                    Map<String, String> details =
                                        Map.fromIterables(
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
                                  }
                                  //Altered QR or fake COVID Vaccination card
                                  else {
                                    showInvalidDialog(context);
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void showInvalidDialog(BuildContext buildContext) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(children: [
            Icon(Icons.dangerous),
            Text("No encontrado"),
          ]),
          content: Text(
              "No se encuentró un registro con esos datos en la base de datos del Ministerio"),
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

  bool isDataValid(Map<String, String> params) {
    RegExp birthDateValidator = RegExp(
        r'^(((0[1-9]|[12]\d|3[01])\/(0[13578]|1[02])\/((19|[2-9]\d)\d{2}))|((0[1-9]|[12]\d|30)\/(0[13456789]|1[012])\/((19|[2-9]\d)\d{2}))|((0[1-9]|1\d|2[0-8])\/02\/((19|[2-9]\d)\d{2}))|(29\/02\/((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))))$');
    if (params['ci']!.isNotEmpty &&
        birthDateValidator.hasMatch(params['fechanacimiento']!)) {
      return true;
    } else {
      return false;
    }
  }
}
