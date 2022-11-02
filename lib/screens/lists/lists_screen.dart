import 'package:colap/screens/authenticate/authenticate_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../commons/colap.page.dart';
import '../../commons/ui.commons.dart';
import '../../models/colap_user.dart';
import '../../services/database_user.dart';
import 'components/user_lists.dart';

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
              ? UserLists(listId: listId)
              : circularProgress();
        },
      ));
    }
  }
}
