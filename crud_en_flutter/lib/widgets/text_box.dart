import 'package:flutter/material.dart';

class TextBox extends StatelessWidget {
  final TextEditingController _controller;
  final String _label;
  TextBox(this._controller, this._label);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
        controller: _controller,
        decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.person,
              color: Colors.grey,
            ),
            filled: true,
            labelText: _label,
            suffix: GestureDetector(
              child: const Icon(Icons.close),
              onTap: () {
                _controller.clear();
              },
            )),
      ),
    );
  }
}
