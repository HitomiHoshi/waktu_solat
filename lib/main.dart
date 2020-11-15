import 'package:flutter/material.dart';
// import 'package:waktu_solat/page/test_xml_page/test_xml_page.dart';
import 'package:waktu_solat/page/waktu_solat_page/waktu_solat_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WaktuSolatPage(),
    );
  }
}
