import 'package:colap/models/battle_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:colap/commons/colap.page.dart';
import 'package:colap/models/list_provider.dart';

import '../../commons/ui.commons.dart';
import '../../models/colap_list.dart';
import '../../models/colap_user.dart';
import '../../services/database_user.dart';
import '../authenticate/authenticate_screen.dart';

class ChoiceScreen extends StatefulWidget {
  const ChoiceScreen({super.key});

  @override
  State<ChoiceScreen> createState() => _ChoiceScreenState();
}

class _ChoiceScreenState extends State<ChoiceScreen> {
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
                Provider.of<ListProvider>(context, listen: false).selectedLists = [];
                return Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.width * 0.95,
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: Card(
                      shadowColor: Theme.of(context).colorScheme.primary,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Row(
                              children: [
                                const Text("Mode gémellaire"),
                                Switch(
                                  onChanged: ((value) => setState(() {
                                        Provider.of<BattleSettings>(context, listen: false).twins = value;
                                      })),
                                  value: Provider.of<BattleSettings>(context, listen: false).twins,
                                ),
                              ],
                            ),
                          ),
                          Text("Quelle(s) liste(s) utiliser ?", style: Theme.of(context).textTheme.labelMedium),
                          Wrap(spacing: 20, runSpacing: 20, children: lists.map((e) => ListChoice(list: e)).toList()),
                          ColapIconButton(
                              icon: Icons.sports_martial_arts,
                              onPressed: () => Navigator.pushNamed(context, "/battle"),
                              text: "C'est parti !")
                        ]),
                      ),
                    ),
                  ),
                );
              }),
        ),
      );
    }
  }
}

class ListChoice extends StatefulWidget {
  final ColapList list;
  const ListChoice({
    Key? key,
    required this.list,
  }) : super(key: key);

  @override
  State<ListChoice> createState() => _ListChoiceState();
}

class _ListChoiceState extends State<ListChoice> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(widget.list.title, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white)),
      padding: const EdgeInsets.all(10),
      selected: selected,
      selectedColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      onSelected: (value) {
        Provider.of<ListProvider>(context, listen: false).addList(widget.list);
        setState(() {
          selected = value;
        });
      },
    );
  }
}
