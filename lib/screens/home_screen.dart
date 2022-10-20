import 'package:colap/commons/colap.page.dart';
import 'package:colap/models/colap_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/database_user.dart';
import '../ui/ui.create.list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColapUser? user = Provider.of<ColapUser?>(context);
    if (user == null) throw Exception("user not found");
    final databaseUser = DatabaseUserService(user.uid);
    return ColapPage(
        child: StreamProvider<ColapUser>(
            create: (context) {
              return databaseUser.user;
            },
            initialData: user,
            builder: (context, child) {
              user = Provider.of<ColapUser>(context);
              return Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                    ElevatedButton(
                        onPressed: (() =>
                            Navigator.pushNamed(context, "/lists")),
                        child: const Text("Accéder à mes listes")),
                    ElevatedButton(
                        onPressed: () {
                          listDialog(context, user!.name);
                        },
                        child: const Text("Créer une nouvelle liste"))
                  ]));
            }));
  }
}
