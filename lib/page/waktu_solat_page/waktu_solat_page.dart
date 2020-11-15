import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:waktu_solat/constant/constant_style.dart';
import 'package:waktu_solat/model/negeri_model.dart';
import 'package:waktu_solat/model/zon_model.dart';
import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;

class WaktuSolatPage extends StatefulWidget {
  @override
  _WaktuSolatPageState createState() => _WaktuSolatPageState();
}

class _WaktuSolatPageState extends State<WaktuSolatPage> {
  String currentNegeri = "johor_data.json";
  // String currentZon = "JHR01";

  List mapWaktuSolat;

  List<Negeri> negeriList;
  List<Zon> zonList;

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

    print(data);
    setState(() {
      mapWaktuSolat = data['rss']['channel']['item'];
      for (var item in mapWaktuSolat) {
        print(item);
      }
    });
  }

  Future getNegeriList() async {
    var response = await DefaultAssetBundle.of(context)
        .loadString('json/negeri_data.json');
    print(response.toString());
    setState(() {
      if (response == null) {
        negeriList = [];
      } else {
        final parsed =
            json.decode(response.toString()).cast<Map<String, dynamic>>();
        negeriList =
            parsed.map<Negeri>((json) => new Negeri.fromJson(json)).toList();
      }
    });
    print(negeriList.toString());
  }

  Future getZonList(String file) async {
    var response = await DefaultAssetBundle.of(context)
        .loadString('json/$file');
    print(response.toString());
    setState(() {
      if (response == null) {
        zonList = [];
      } else {
        final parsed =
            json.decode(response.toString()).cast<Map<String, dynamic>>();
        zonList =
            parsed.map<Zon>((json) => new Zon.fromJson(json)).toList();
      }
    });
    print(zonList.toString());
  }

  @override
  void initState() {
    super.initState();
    getNegeriList();
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
          if(negeriList != null) DropdownButton(
            value: currentNegeri,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            
            onChanged: (String newValue) {
              setState(() {
                currentNegeri = newValue;
              });
            },
            items: negeriList.map((Negeri value) {
              return DropdownMenuItem<String>(
                value: value.file,
                child: Text(value.negeri),
              );
            }).toList(),
          ),
          // if(zonList != null) DropdownButton(
          //   value: currentZon,
          //   icon: Icon(Icons.arrow_downward),
          //   iconSize: 24,
          //   elevation: 16,
          //   style: TextStyle(color: Colors.deepPurple),
          //   underline: Container(
          //     height: 2,
          //     color: Colors.deepPurpleAccent,
          //   ),
            
          //   onChanged: (String newValue) {
          //     setState(() {
          //       currentZon = newValue;
          //     });
          //   },
          //   items: zonList.map((Zon value) {
          //     return DropdownMenuItem<String>(
          //       value: value.code,
          //       child: Text(value.zon),
          //     );
          //   }).toList(),
          // ),
          RaisedButton(
            child: Text('Cari'),
            onPressed: () {
              
                getZonList(currentNegeri);
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
