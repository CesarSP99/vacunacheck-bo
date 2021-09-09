import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/const.dart';

class DetailsScreen extends StatefulWidget {
  final Map<String, String> details;
  final String url;

  DetailsScreen({Key? key, required this.details, required this.url})
      : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    //List<String> keys = widget.details.keys.toList();
    //List<String> values = widget.details.values.toList();

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
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Detalles del vacunado',
                      style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.w900,
                          color: Colors.white),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.link,
                        color: Colors.white,
                      ),
                      onPressed: _launchURL,
                      iconSize: 30,
                    ),
                  ],
                ),
                SizedBox(height: 45),
                Expanded(
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      ...detailsList(widget.details),
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

  List<Widget> detailsList(Map<String, String> details) {
    List<Widget> listTiles = [];
    details.forEach((key, value) => listTiles.add(
          ListTile(
            leading: Icon(
              Icons.coronavirus,
              size: 40,
            ),
            title: Text(
              key.trim(),
              style: TextStyle(fontSize: 17),
            ),
            subtitle: Text(
              value.trim(),
              style: TextStyle(fontSize: 15),
            ),
          ),
        ));
    return listTiles;
  }

  void _launchURL() async => await canLaunch(widget.url)
      ? await launch(widget.url)
      : throw 'Error al abrir $widget.url';
}
