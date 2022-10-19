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
        child: StreamProvider<ColapUser>(
            create: (context) {
              return databaseUser.user;
            },
            initialData: user,
            builder: (context, child) {
              user = Provider.of<ColapUser>(context);
              return Center(
                  child: user?.name == '' || user?.name == null
                      ? const SizedBox(
                          width: 200,
                          height: 200,
                          child: CircularProgressIndicator())
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                              Text("Bienvenue ${user?.name}"),
                              if (user!.hasList)
                                ElevatedButton(
                                    onPressed: (() =>
                                        Navigator.pushNamed(context, "/lists")),
                                    child: const Text("Accéder à mes listes")),
                              ElevatedButton(
                                  onPressed: () async {
                                    final messenger =
                                        ScaffoldMessenger.of(context);
                                    ColapList? list = await databaseList
                                        .createList("Filles", user!.name);
                                    if (list != null) {
                                      databaseUser.addList(list, user!);
                                      await user!.setUserList();
                                      Navigator.pushNamed(context, "/lists");
                                    } else {
                                      messenger.showSnackBar(const SnackBar(
                                          content: Text(
                                              "Une erreur s'est produite")));
                                    }
                                  },
                                  child: const Text("Créer une nouvelle liste"))
                            ]));
            }));
  }
}
