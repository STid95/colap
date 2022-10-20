import 'package:colap/models/colap_user.dart';
import 'package:colap/services/database_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/colap_list.dart';
import '../services/database_list.dart';

Future<void> showUserDialog(BuildContext context, ColapList list) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AddUserDialog(list: list);
    },
  );
}

class AddUserDialog extends StatefulWidget {
  final ColapList list;
  const AddUserDialog({
    Key? key,
    required this.list,
  }) : super(key: key);

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  bool error = false;
  @override
  Widget build(BuildContext context) {
    TextEditingController userName = TextEditingController();
    ColapUser user = Provider.of<ColapUser>(context);
    final databaseUser = DatabaseUserService(user.uid);
    final databaseList = DatabaseListService();
    final navigator = Navigator.of(context);

    final messenger = ScaffoldMessenger.of(context);
    return Dialog(
      child: SizedBox(
        height: 250,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Partager la liste"),
                const Text("Nom de l'utilisateur.ice à ajouter à la liste"),
                TextFormField(
                  controller: userName,
                ),
                if (error)
                  const Text("Utilisateur.ice non trouvé.e !",
                      style: TextStyle(color: Colors.red)),
                ElevatedButton(
                    onPressed: () async {
                      final foundUser =
                          await databaseUser.searchByUserName("NContant");
                      if (foundUser == null) {
                        setState(() {
                          error = true;
                        });
                      } else {
                        widget.list.addUser(foundUser.name);
                        navigator.pop();
                      }
                    },
                    child: const Text("OK")),
              ]),
        ),
      ),
    );
  }
}
