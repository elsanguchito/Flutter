import 'package:crud_en_flutter/view/my_home_page.dart';
import 'package:flutter/material.dart';
import 'package:crud_en_flutter/widgets/text_box.dart';

class ModifyContact extends StatefulWidget {
  final User _user;
  ModifyContact(this._user) : super(key: ValueKey(_user));
  @override
  State<StatefulWidget> createState() => _ModifyContact();
}

class _ModifyContact extends State<ModifyContact> {
  late TextEditingController controllerName;
  late TextEditingController controllerLastName;
  late TextEditingController controllerPhone;

  @override
  void initState() {
    User c = widget._user;
    controllerName = TextEditingController(text: c.name);
    controllerLastName = TextEditingController(text: c.lastName);
    controllerPhone = TextEditingController(text: c.phone);
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
        title: const Text("Modificar Contacto"),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Text(
                "ID: ${widget._user.id}",
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
            ),
          ),
          TextBox(controllerName, "Nombre"),
          TextBox(controllerLastName, "Apellido"),
          TextBox(controllerPhone, "Telefono"),
          ElevatedButton(
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.black),
            ),
            onPressed: () {
              String id = widget._user.id.toString();
              String name = controllerName.text;
              String lastName = controllerLastName.text;
              String phone = controllerPhone.text;

              if (isDataValid()) {
                Navigator.pop(
                  context,
                  User(
                    id: int.parse(id),
                    name: name,
                    lastName: lastName,
                    phone: phone,
                  ),
                );
                }else {
                // Show an error message or toast to inform the user to fill in all fields.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Por favor, completalos campos a modificar.'),
                  ),
                );
              }
            },
              child: const Text("Guardar Contacto"),
            ),
        ],
      ),
    );
  }
}
