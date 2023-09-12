import 'package:flutter/material.dart';

import 'view/my_home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestión de Contactos',
      home: MyHomePage("Mis Contactos"),
    );
  }
}
