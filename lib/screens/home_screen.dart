import 'package:colap/commons/colap.page.dart';
import 'package:colap/commons/ui.commons.dart';
import 'package:colap/models/colap_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/database_user.dart';
import 'lists/components/dialogs/create_list_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColapUser? user = Provider.of<ColapUser?>(context);
    final databaseUser = DatabaseUserService(user!.uid);
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
                    ColapSvg(
                      asset: "family",
                      size: MediaQuery.of(context).size.height * 0.3,
                    ),
                    Text("Comment on l'appelle ?",
                        style: Theme.of(context).textTheme.headline2),
                    ColapIconButton(
                        icon: Icons.view_list,
                        onPressed: (() =>
                            Navigator.pushNamed(context, "/lists")),
                        text: "Accéder à mes listes"),
                    ColapIconButton(
                        icon: Icons.add_circle_outline,
                        onPressed: () {
                          listDialog(context, user!.name);
                        },
                        text: "Créer une nouvelle liste"),
                    ColapIconButton(
                        icon: Icons.sports_mma,
                        onPressed: () =>
                            Navigator.pushNamed(context, "/battle"),
                        text: "Mode Battle Royale")
                  ]));
            }));
  }
}
