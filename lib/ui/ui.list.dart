import 'package:colap/models/colap_name.dart';
import 'package:colap/services/database_list.dart';
import 'package:flutter/material.dart';

import 'package:colap/models/colap_list.dart';

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
    final databaseList = DatabaseListService(uid: widget.list.uid);
    return Padding(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder(
            stream: databaseList.list,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data is ColapList) {
                ColapList list = snapshot.data!;

                return FutureBuilder(
                    future: list.fetchedNames,
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          snapshot.data is List<ColapName>) {
                        list.names = snapshot.data!;
                        return Column(
                          children: [
                            ListView(
                                shrinkWrap: true,
                                children: list.names
                                    .map((e) => Text(e.name))
                                    .toList()),
                            ElevatedButton(
                                onPressed: (() async {
                                  ColapName name = ColapName(
                                      name: 'Jonah',
                                      grade1: 3,
                                      comment: "A voir");
                                  final names = await list.addName(name);
                                  setState(() {
                                    list.names = names;
                                  });
                                }),
                                child: const Text("Ajouter un prénom"))
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            const Text(
                              "Aucun nom présent, commencez à en ajouter !",
                              style: TextStyle(fontSize: 20),
                            ),
                            ElevatedButton(
                                onPressed: (() async {
                                  ColapName name = ColapName(
                                      name: 'Rafael',
                                      grade1: 5,
                                      comment: "J'aime bien");
                                  final names = await list.addName(name);
                                  setState(() {
                                    list.names = names;
                                  });
                                }),
                                child: const Text("Ajouter un prénom"))
                          ],
                        );
                      }
                    });
              } else {
                return const SizedBox(
                    width: 50, height: 50, child: CircularProgressIndicator());
              }
            }));
  }
}
