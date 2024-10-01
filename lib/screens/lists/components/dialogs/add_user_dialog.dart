import 'package:colap/commons/ui.commons.dart';
import 'package:colap/models/colap_user.dart';
import 'package:colap/services/database_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/colap_list.dart';

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
    final navigator = Navigator.of(context);

    return Dialog(
      child: SizedBox(
        height: 450,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("Inviter quelqu'un à rejoindre la liste", style: Theme.of(context).textTheme.labelMedium),
            const ColapSvg(
              asset: "link",
              size: 180,
            ),
            const Text("Nom de l'utilisateur.ice à ajouter à la liste"),
            TextFormField(
              controller: userName,
            ),
            if (error) const Text("Utilisateur.ice non trouvé.e !", style: TextStyle(color: Colors.red)),
            ColapButton(
              text: "Ajouter",
              onPressed: () async {
                await searchAndAddUser(databaseUser, userName, navigator);
              },
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> searchAndAddUser(
      DatabaseUserService databaseUser, TextEditingController userName, NavigatorState navigator) async {
    final foundUser = await databaseUser.searchByUserName(userName.text);
    if (foundUser == null) {
      setState(() {
        error = true;
      });
    } else {
      widget.list.addUser(foundUser.name);
      navigator.pop();
    }
  }
}
