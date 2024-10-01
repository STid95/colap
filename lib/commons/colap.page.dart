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
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            toolbarHeight: 80,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pushNamed(context, "/"),
            ),
            title: Text("Colap",
                style:
                    Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.background)),
            actions: [
              IconButton(
                  onPressed: () {
                    _auth.signOut();
                  },
                  icon: const Icon(Icons.logout))
            ]),
        body: child);
  }
}
