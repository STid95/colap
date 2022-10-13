import 'package:flutter/cupertino.dart';
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
    ColapUser? user = Provider.of<ColapUser?>(context);
    if (user == null) throw Exception("user not found");

    final databaseUser = DatabaseUserService(user.uid);

    return ColapPage(
        child: StreamBuilder(
            stream: databaseUser.userList,
            builder: (context, snapshot) => Text(snapshot.data.toString())));
  }
}
