import 'package:flutter/material.dart';

messageResponse(BuildContext context, String msg) {
  showDialog(
      context: context,
      builder: (_) => AlertDialog(
            title: const Text("Mensaje"),
            content: Text("$msg"),
          ));
}
