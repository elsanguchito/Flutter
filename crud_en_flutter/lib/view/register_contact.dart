import 'package:crud_en_flutter/view/my_home_page.dart';
import 'package:crud_en_flutter/widgets/text_box.dart';
import 'package:flutter/material.dart';

class RegisterContact extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterContact();
}

class _RegisterContact extends State<RegisterContact> {
  late TextEditingController controllerName;
  late TextEditingController controllerLastName;
  late TextEditingController controllerPhone;

  @override
  void initState() {
    controllerName = TextEditingController();
    controllerLastName = TextEditingController();
    controllerPhone = TextEditingController();
    super.initState();
  }
  bool isDataValid() {
    final String name = controllerName.text.trim();
    final String lastName = controllerLastName.text.trim();
    final String phone = controllerPhone.text.trim();

    return name.isNotEmpty && lastName.isNotEmpty && phone.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Registrar Contactos"),
          backgroundColor: Colors.black,
        ),
        body: ListView(
          children: [
            TextBox(controllerName, "Nombre"),
            TextBox(controllerLastName, "Apellido"),
            TextBox(controllerPhone, "Telefono"),
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(Colors.black),
              ),
              onPressed: () {
              if (isDataValid()) {
                String name = controllerName.text;
                String lastName = controllerLastName.text;
                String phone = controllerPhone.text;
                Navigator.pop(
                  context,
                  User(name: name, lastName: lastName, phone: phone),
                );
              } else {
                // Show an error message or toast to inform the user to fill in all fields.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Por favor, complete todos los campos.'),
                  ),
                );
              }
            },
              child: const Text("Guardar Contacto"),
            ),
          ],
        ));
  }
}

