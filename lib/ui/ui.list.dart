import 'package:colap/commons/ui.commons.dart';
import 'package:colap/ui/ui.add.user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:colap/models/colap_list.dart';
import 'package:colap/models/colap_name.dart';
import 'package:colap/services/database_list.dart';
import 'package:colap/ui/ui.creation.name.dart';
import 'package:colap/ui/ui.name.dart';

import '../models/colap_user.dart';

class UIColapList extends StatefulWidget {
  final void Function() onListDeleted;
  final ColapList list;
  const UIColapList({
    Key? key,
    required this.list,
    required this.onListDeleted,
  }) : super(key: key);

  @override
  State<UIColapList> createState() => _UIColapListState();
}

class _UIColapListState extends State<UIColapList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List<UICreationName> listNamesToAdd = [];

  @override
  Widget build(BuildContext context) {
    ColapUser currentUser = Provider.of<ColapUser>(context, listen: false);
    super.build(context);
    return StreamProvider<List<ColapName>>.value(
      value:
          Provider.of<DatabaseListService>(context).getNames(widget.list.uid!),
      initialData: const [],
      builder: (context, child) {
        final list = Provider.of<ColapList>(context);
        list.names = Provider.of<List<ColapName>>(context);
        return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                RoundButton(
                    onTap: () => createName(currentUser.name), icon: Icons.add),
                if (widget.list.user2 == '')
                  RoundButton(onTap: () => addUser(list), icon: Icons.link)
              ]),
              if (listNamesToAdd.isNotEmpty) Column(children: listNamesToAdd),
              Expanded(child: NamesListView(list: list)),
              ElevatedButton(
                  onPressed: () {
                    list.deleteList();
                    currentUser.deleteList(list.uid!);
                    widget.onListDeleted();
                  },
                  child: const Text("Supprimer la liste")),
            ]));
      },
    );
  }

  void createName(String userName) {
    ValueKey key = ValueKey(listNamesToAdd.length);
    setState(() {
      listNamesToAdd.add(UICreationName(
        userName: userName,
        key: key,
        onValidate: (name) {
          setState(() {
            widget.list.addName(name);
            listNamesToAdd.removeWhere((element) => element.key == key);
          });
        },
        onCancel: () => setState(() {
          listNamesToAdd.removeWhere((element) => element.key == key);
        }),
      ));
    });
  }

  void addUser(ColapList list) {
    showUserDialog(context, list);
  }
}

class NamesListView extends StatefulWidget {
  final ColapList list;
  const NamesListView({
    Key? key,
    required this.list,
  }) : super(key: key);

  @override
  State<NamesListView> createState() => _NamesListViewState();
}

class _NamesListViewState extends State<NamesListView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListView(
          shrinkWrap: true,
          children: widget.list.names
              .map((e) => UIName(
                  name: e.name, nameId: e.uid!, listId: widget.list.uid!))
              .toList()),
    );
  }
}
