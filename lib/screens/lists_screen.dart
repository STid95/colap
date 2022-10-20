import 'package:colap/models/colap_list.dart';
import 'package:colap/screens/authenticate_screen.dart';
import 'package:colap/ui/ui.tab.bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../commons/colap.page.dart';
import '../models/colap_user.dart';
import '../services/database_user.dart';

class ListsScreen extends StatefulWidget {
  const ListsScreen({Key? key}) : super(key: key);

  @override
  State<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen> {
  @override
  Widget build(BuildContext context) {
    ColapUser? authUser = Provider.of<ColapUser?>(context);
    String? listId = ModalRoute.of(context)?.settings.arguments as String?;
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
        builder: (context, child) {
          return Provider.of<ColapUser>(context).name != ''
              ? StreamProvider<List<ColapList>>.value(
                  value: Provider.of<ColapUser>(context).getLists(),
                  initialData: const [],
                  builder: (context, child) {
                    List<ColapList> lists =
                        Provider.of<List<ColapList>>(context);
                    return ColapTabBar(
                      lists: lists,
                      createdListId: listId,
                    );
                  })
              : const Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                      width: 200,
                      height: 200,
                      child: CircularProgressIndicator()),
                );
        },
      ));
    }
  }
}
