import 'package:colap/commons/colap.page.dart';
import 'package:colap/models/colap_user.dart';
import 'package:colap/services/database_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/colap_list.dart';
import '../services/database_user.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColapUser? user = Provider.of<ColapUser?>(context);
    if (user == null) throw Exception("user not found");
    final databaseUser = DatabaseUserService(user.uid);
    final databaseList = DatabaseListService();
    return ColapPage(
        child: StreamBuilder(
            stream: databaseUser.user,
            builder: (context, snapshot) {
              final navigator = Navigator.of(context);
              if (snapshot.hasData) {
                user = snapshot.data;
                return Center(
                    child: Column(children: [
                  Text("Bienvenue ${user?.name}"),
                  if (user!.hasList)
                    ElevatedButton(
                        onPressed: (() => print("coucou")),
                        child: const Text("Accéder à mes listes")),
                  ElevatedButton(
                      onPressed: () async {
                        final messenger = ScaffoldMessenger.of(context);
                        ColapList? list =
                            await databaseList.createList("Fille");
                        if (list != null) {
                          databaseUser.addList(list, user!);
                          user?.lists = await databaseUser.userLists;
                        } else {
                          messenger.showSnackBar(const SnackBar(
                              content: Text("Une erreur s'est produite")));
                        }
                      },
                      child: const Text("Créer une nouvelle liste"))
                ]));
              } else {
                return const Center(
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            }));
  }
}
