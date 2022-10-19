import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/colap_list.dart';
import '../models/colap_user.dart';
import '../services/database_list.dart';
import '../services/database_user.dart';

Future<void> listDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return const CreateListDialog();
    },
  );
}

class CreateListDialog extends StatelessWidget {
  const CreateListDialog({super.key});

  @override
  Widget build(BuildContext context) {
    ColapUser user = Provider.of<ColapUser>(context);
    TextEditingController listName = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final databaseList = DatabaseListService();
    final databaseUser = DatabaseUserService(user.uid);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    return Dialog(
      child: SizedBox(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Créer une nouvelle liste"),
                Form(
                  key: formKey,
                  child: Row(
                    children: [
                      const Text("Nom de la liste"),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextFormField(
                            controller: listName,
                            validator: (value) => value == null || value.isEmpty
                                ? "Indiquez un nom de liste"
                                : null,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState?.validate() == true) {
                        ColapList? list = await databaseList.createList(
                            listName.text, user.name);
                        if (list != null) {
                          databaseUser.addList(list, user);
                          navigator.pushNamed("/lists", arguments: list.uid);
                        } else {
                          messenger.showSnackBar(const SnackBar(
                              content: Text("Une erreur s'est produite")));
                        }
                      }
                    },
                    child: const Text("OK")),
              ]),
        ),
      ),
    );
  }
}
