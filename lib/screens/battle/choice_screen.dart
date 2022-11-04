import 'package:colap/commons/colap.page.dart';
import 'package:colap/models/list_provider.dart';
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
                return Center(
                  child: SizedBox(
                    height: 300,
                    width: 300,
                    child: Card(
                      shadowColor: Theme.of(context).colorScheme.primary,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Quelle liste utiliser ?",
                                style: Theme.of(context).textTheme.headline5),
                            Wrap(
                                spacing: 20,
                                runSpacing: 20,
                                children: lists
                                    .map((e) => ChoiceChip(
                                          label: Text(e.title,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(
                                                      color: Colors.white)),
                                          padding: const EdgeInsets.all(10),
                                          selected: true,
                                          selectedColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          onSelected: (value) {
                                            Provider.of<ListProvider>(context,
                                                    listen: false)
                                                .selectedList = e;
                                            Navigator.pushNamed(
                                                context, "/battle");
                                          },
                                        ))
                                    .toList())
                          ]),
                    ),
                  ),
                );
              }),
        ),
      );
    }
  }
}
