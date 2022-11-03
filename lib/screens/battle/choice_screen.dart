import 'package:colap/commons/colap.page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/colap_list.dart';
import '../../models/colap_user.dart';
import '../../services/database_user.dart';
import '../authenticate/authenticate_screen.dart';

class ChoiceScreen extends StatelessWidget {
  const ChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ColapUser? authUser = Provider.of<ColapUser?>(context);
    if (authUser == null) {
      return const AuthenticateScreen();
    } else {
      final databaseUser = DatabaseUserService(authUser.uid);

      return ColapPage(
        child: StreamProvider<ColapUser>(
          create: (context) {
            return databaseUser.user;
          },
          initialData: authUser,
          builder: (context, child) => StreamProvider<List<ColapList>>.value(
              value: Provider.of<ColapUser>(context).getLists(),
              initialData: const [],
              builder: (context, child) {
                List<ColapList> lists = Provider.of<List<ColapList>>(context);
                return Column(
                    children: lists
                        .map((e) =>
                            TextButton(onPressed: null, child: Text(e.title)))
                        .toList());
              }),
        ),
      );
    }
  }
}
