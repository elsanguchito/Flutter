import 'dart:async';
import 'package:google_fonts/google_fonts.dart';

import 'package:crud_en_flutter/widgets/message_response.dart';
import 'package:crud_en_flutter/view/modify_contact.dart';
import 'package:crud_en_flutter/view/register_contact.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  final String _title;
  MyHomePage(this._title) : super(key: ValueKey(_title));
  @override
  State<StatefulWidget> createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  late Future<List<User>> _users;

  @override
  void initState() {
    super.initState();
    _users = _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Icon(Icons.person, color: Colors.white, size: 30.0),
            ),
            Text(widget._title)
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<User>>(
          future: _users,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      '${snapshot.data![index].name} ${snapshot.data![index].lastName}',
                      style: GoogleFonts.getFont('Lato'),
                    ),
                    subtitle: Text(snapshot.data![index].phone),
                    leading: CircleAvatar(
                      backgroundColor: Colors.black,
                      child: Text(
                        snapshot.data![index].name.substring(0, 1),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextButton(
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue),
                            onPressed: () async {
                              _updateUser(context, snapshot.data![index]);
                            },
                            child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.edit,
                                      color: Colors.white, size: 20.0),
                                  Text('Modificar')
                                ]),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.redAccent),
                          onPressed: () async {
                            _deletePerson(context, snapshot.data![index]);
                          },
                          child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.delete,
                                    color: Colors.white, size: 20.0),
                                Text('Eliminar')
                              ]),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () async {
          _createUser();
        },
        tooltip: "Agregar Contacto",
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<List<User>> _getUsers() async {
    final response =
        await http.get(Uri.parse('https://simple-user-crud.vercel.app/users'));
    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);
      return responseData.map<User>((userData) {
        return User(
          id: userData['id'],
          name: userData['name'],
          lastName: userData['lastName'],
          phone: userData['phone'],
        );
      }).toList();
    } else {
      throw Exception("Error");
    }
  }

  Future<void> _updateUser(BuildContext context, User user) async {
    Navigator.push(
            context, MaterialPageRoute(builder: (_) => ModifyContact(user)))
        .then((newContact) async {
      if (newContact != null) {
        final response = await http.put(
          Uri.parse('https://simple-user-crud.vercel.app/users'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'id': newContact.id,
            'name': newContact.name,
            'lastName': newContact.lastName,
            'phone': newContact.phone
          }),
        );
        if (response.statusCode == 200) {
          setState(() {
            messageResponse(
                context, newContact.name + " a sido modificado...!");
            _users = _getUsers();
          });
        } else {
          Map<String, dynamic> responseData = json.decode(response.body);
          List<dynamic> errors = responseData['errors'];
          setState(() {
            messageResponse(context, errors.toString());
          });
        }
      }
    });
  }

  Future<void> _deletePerson(BuildContext context, User user) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Eliminar contacto'),
            content: Text('Deseas eliminar a ${user.name} ?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar',
                    style: TextStyle(color: Colors.black)),
              ),
              TextButton(
                onPressed: () async {
                  await http.delete(
                    Uri.parse('https://simple-user-crud.vercel.app/users'),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: jsonEncode(<String, int>{'id': user.id}),
                  );
                  Navigator.pop(context);
                  setState(() {
                    _users = _getUsers();
                  });
                },
                child:
                    const Text('Borrar', style: TextStyle(color: Colors.black)),
              )
            ],
          );
        });
  }

  Future<void> _createUser() async {
    Navigator.push(
            context, MaterialPageRoute(builder: (_) => RegisterContact()))
        .then((newContact) async {
      if (newContact != null) {
        await http.post(
          Uri.parse('https://simple-user-crud.vercel.app/users'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'name': newContact.name,
            'lastName': newContact.lastName,
            'phone': newContact.phone
          }),
        );
        setState(() {
          messageResponse(context, newContact.name + " a sido guardado...!");
          _users = _getUsers();
        });
      }
    });
  }
}

class User {
  int id;
  String name;
  String lastName;
  String phone;

  User(
      {this.id = -1,
      required this.name,
      required this.lastName,
      required this.phone});
}
