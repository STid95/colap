import 'package:colap/models/colap_name.dart';
import 'package:colap/services/database_list.dart';
import 'package:colap/ui/ui.name.dart';
import 'package:flutter/material.dart';

import 'package:colap/models/colap_list.dart';
import 'package:provider/provider.dart';

class UIColapList extends StatefulWidget {
  final ColapList list;
  const UIColapList({
    Key? key,
    required this.list,
  }) : super(key: key);

  @override
  State<UIColapList> createState() => _UIColapListState();
}

class _UIColapListState extends State<UIColapList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
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
          return SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  ListView(
                      shrinkWrap: true,
                      children: widget.list.names
                          .map((e) => UIName(
                              name: e.name,
                              nameId: e.uid!,
                              listId: widget.list.uid!))
                          .toList()),
                  ElevatedButton(
                      onPressed: (() async {
                        ColapName name = ColapName(
                            name: 'Julie', grade1: 3, comment: "A voir");
                        widget.list.addName(name);
                      }),
                      child: const Text("Ajouter un prénom"))
                ])),
          );
        },
      ),
    );
  }
}
