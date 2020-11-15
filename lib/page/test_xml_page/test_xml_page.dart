import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;

class TestXmlPage extends StatefulWidget {
  @override
  _TestXmlPageState createState() => _TestXmlPageState();
}

class _TestXmlPageState extends State<TestXmlPage> {
  void xmlStringToJson() {
    final Xml2Json xml2Json = Xml2Json();

    var xmlString = '''
      <tut>
        <id>123</id>
        <author>bezKoder</author>
        <title>Programming Tut#123</title>
        <publish_date>2020-3-16</publish_date>
        <description>Description for Tut#123</description>
      </tut>''';

    xml2Json.parse(xmlString);
    var jsonString = xml2Json.toParker();
    // {"tut": {"id": "123", "author": "bezKoder", "title": "Programming Tut#123", "publish_date": "2020-3-16", "description": "Description for Tut#123"}}

    var data = jsonDecode(jsonString);
    // {tut: {id: 123, author: bezKoder, title: Programming Tut#123, publish_date: 2020-3-16, description: Description for Tut#123}}

    print("xmlStringToJson :");
    print(data['tut']);
  }

  void xmlStringListToJson() {
    final Xml2Json xml2Json = Xml2Json();
    var xmlString = '''<?xml version="1.0"?>
    <site>
      <tut>
        <id>tut_01</id>
        <author>bezKoder</author>
        <title>Programming Tut#1</title>
        <publish_date>2020-8-21</publish_date>
        <description>Tut#1 Description</description>
      </tut>
      <tut>
        <id>tut_02</id>
        <author>zKoder</author>
        <title>Software Dev Tut#2</title>
        <publish_date>2020-12-18</publish_date>
        <description>Tut#2 Description</description>
      </tut>
    </site>''';

    xml2Json.parse(xmlString);
    var jsonString = xml2Json.toParker();
    var data = jsonDecode(jsonString);

    var tutList = data['site']['tut'];
    for (var item in tutList) {
      print(item);
    }
  }

  getJsonFromXMLFile(path) async {
    final Xml2Json xml2Json = Xml2Json();

    try {
      // var content = await File(path).readAsString();
      var content = await rootBundle.loadString(path);
      print(content.toString());
      xml2Json.parse(content.toString());

      var jsonString = xml2Json.toParker();
      return jsonDecode(jsonString);
    } catch (e) {
      print(e);
    }
  }

  void xmlStringListFileToJson() async{

    var data = await getJsonFromXMLFile('xml/bezkoder.xml');

    var tutList = data['site']['tut'];
    for (var item in tutList) {
      print(item);
    }
  }

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

  void xmlStringListUrlToJson() async{

    var data = await getJsonFromXMLUrl('https://bezkoder.com/sample/bezkoder.xml');

    var tutList = data['site']['tut'];
    for (var item in tutList) {
      print(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test XML"),
      ),
      body: ListView(
        children: [
          RaisedButton(
            child: Text('xmlStringToJson'),
            onPressed: () {
              xmlStringToJson();
            },
          ),
          RaisedButton(
            child: Text('xmlStringListToJson'),
            onPressed: () {
              xmlStringListToJson();
            },
          ),
          RaisedButton(
            child: Text('xmlStringListFileToJson'),
            onPressed: () {
              xmlStringListFileToJson();
            },
          ),
          RaisedButton(
            child: Text('xmlStringListUrlToJson'),
            onPressed: () {
              xmlStringListUrlToJson();
            },
          ),
        ],
      ),
    );
  }
}
