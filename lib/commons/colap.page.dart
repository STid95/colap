import 'package:colap/services/database_user.dart';
import 'package:flutter/material.dart';

import 'package:colap/services/auth_service.dart';
import 'package:provider/provider.dart';

import '../models/colap_user.dart';

class ColapPage extends StatelessWidget {
  final AuthService _auth = AuthService();
  final Widget child;

  ColapPage({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColapUser? user = Provider.of<ColapUser?>(context);
    DatabaseUserService databaseUser = DatabaseUserService(user!.uid);
    return StreamProvider<ColapUser>(
      create: (context) => databaseUser.user,
      initialData: user,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(title: const Text("Colap"), actions: [
            IconButton(
                onPressed: () {
                  _auth.signOut();
                },
                icon: const Icon(Icons.logout))
          ]),
          body: child),
    );
  }
}
