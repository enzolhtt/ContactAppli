import 'package:flutter/material.dart';
import 'accueil_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carnet de Contacts',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AccueilPage(),
    );
  }
}
