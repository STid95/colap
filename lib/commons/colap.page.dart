import 'package:flutter/material.dart';

import 'package:colap/services/auth_service.dart';

class ColapPage extends StatelessWidget {
  final AuthService _auth = AuthService();
  final Widget child;

  ColapPage({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Colap"), actions: [
          IconButton(
              onPressed: () => _auth.signOut(), icon: const Icon(Icons.logout))
        ]),
        body: child);
  }
}
