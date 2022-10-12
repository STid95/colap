import 'package:colap/commons/colap.page.dart';
import 'package:colap/models/colap_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/database.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColapUser? user = Provider.of<ColapUser?>(context);
    if (user == null) throw Exception("user not found");
    final database = DatabaseService(user.uid);
    return ColapPage(
        child: StreamBuilder(
      stream: database.user,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          user = snapshot.data;
          return Center(child: Text("Bienvenue ${user?.name}"));
        } else {
          return const SizedBox(
            width: 200,
            height: 200,
            child: CircularProgressIndicator(),
          );
        }
      },
    ));
  }
}
