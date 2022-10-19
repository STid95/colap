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
    return Provider(
      create: (context) => ColapList(
          title: widget.list.title,
          uid: widget.list.uid,
          user1: widget.list.user1,
          user2: widget.list.user2),
      child: StreamProvider<List<ColapName>>.value(
        value: Provider.of<DatabaseListService>(context)
            .getNames(widget.list.uid!),
        initialData: const [],
        builder: (context, child) {
          widget.list.names = Provider.of<List<ColapName>>(context);
          return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipOval(
                          child: Material(
                            color: Colors.deepPurple,
                            child: InkWell(
                              onTap: () {
                                ValueKey key = ValueKey(listNamesToAdd.length);
                                setState(() {
                                  listNamesToAdd.add(UICreationName(
                                    userName: currentUser.name,
                                    key: key,
                                    onValidate: (name) {
                                      setState(() {
                                        widget.list.addName(name);
                                        listNamesToAdd.removeWhere(
                                            (element) => element.key == key);
                                      });
                                    },
                                    onCancel: () => setState(() {
                                      listNamesToAdd.removeWhere(
                                          (element) => element.key == key);
                                    }),
                                  ));
                                });
                              },
                              child: const SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Icon(
                                    Icons.add,
                                    size: 30,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                        ))),
                if (listNamesToAdd.isNotEmpty) Column(children: listNamesToAdd),
                Expanded(child: NamesListView(list: widget.list)),
                ElevatedButton(
                    onPressed: () {
                      widget.list.deleteList();
                      currentUser.deleteList(widget.list.uid!);
                      widget.onListDeleted();
                    },
                    child: const Text("Supprimer la liste")),
              ]));
        },
      ),
    );
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
