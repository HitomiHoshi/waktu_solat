import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:waktu_solat/constant/constant_style.dart';
import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;

class WaktuSolatPage extends StatefulWidget {
  @override
  _WaktuSolatPageState createState() => _WaktuSolatPageState();
}

class _WaktuSolatPageState extends State<WaktuSolatPage> {
  TextEditingController _zon = TextEditingController();
  List mapWaktuSolat;

  getJsonFromXMLUrl(String url) async {
    final Xml2Json xml2Json = Xml2Json();

    try {
      var response = await http.get(url);
      xml2Json.parse(response.body);

      var jsonString = xml2Json.toParker();
      return jsonDecode(jsonString);
    } catch (e) {
      print(e);
    }
  }

  void xmlStringListUrlToJson(String zon) async {
    var data = await getJsonFromXMLUrl(
        'https://www.e-solat.gov.my/index.php?r=esolatApi/xmlfeed&zon=$zon');

    setState(() {
      mapWaktuSolat = data['rss']['channel']['item'];
      for (var item in mapWaktuSolat) {
        print(item['title']);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    xmlStringListUrlToJson('SGR01');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Waktu Solat"),
      ),
      body: ListView(
        children: [
          RaisedButton(
            child: Text('xmlStringListUrlToJson'),
            onPressed: () {
              xmlStringListUrlToJson('SGR01');
            },
          ),
          if (mapWaktuSolat != null)
            for (var item in mapWaktuSolat)
              _solatDetailList(item['title'], item['description'], null)
        ],
      ),
    );
  }

  Card _solatDetailList(String title, String time, Function func) {
    return Card(
      child: FlatButton(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Center(
            child: Row(
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: primary,
                  ),
                ),
                Spacer(),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 16,
                    color: primary,
                  ),
                ),
              ],
            ),
          ),
        ),
        onPressed: () {
          if (func != null) func();
        },
      ),
    );
  }
}
