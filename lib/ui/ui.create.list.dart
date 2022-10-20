import 'package:flutter/material.dart';

import '../models/colap_list.dart';
import '../services/database_list.dart';

Future<void> listDialog(BuildContext context, String userName) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return CreateListDialog(
        userName: userName,
      );
    },
  );
}

class CreateListDialog extends StatelessWidget {
  final String userName;
  const CreateListDialog({
    Key? key,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController listName = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final databaseList = DatabaseListService();
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
                            listName.text, userName);
                        if (list != null) {
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
