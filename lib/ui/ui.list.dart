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
  String orderBy = "added_at";
  bool desc = true;
  @override
  Widget build(BuildContext context) {
    ColapUser currentUser = Provider.of<ColapUser>(context, listen: false);
    super.build(context);
    return StreamProvider<List<ColapName>>.value(
      value: Provider.of<DatabaseListService>(context)
          .getNames(widget.list.uid!, orderBy, desc),
      initialData: const [],
      builder: (context, child) {
        final list = Provider.of<ColapList>(context);
        list.names = Provider.of<List<ColapName>>(context);
        return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RoundButton(
                              onTap: () => changeDesc(),
                              icon: desc
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward),
                          DropdownButton<OrderBy>(
                              underline: Container(),
                              icon: const Icon(
                                Icons.sort,
                                size: 30,
                              ),
                              items: OrderBy.values
                                  .map<DropdownMenuItem<OrderBy>>(
                                      (OrderBy choice) {
                                return DropdownMenuItem<OrderBy>(
                                  value: choice,
                                  child: Text(choice.displayName),
                                );
                              }).toList(),
                              onChanged: (OrderBy? choice) {
                                if (choice != null) {
                                  orderList(choice);
                                }
                              }),
                        ],
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RoundButton(
                                onTap: () => createName(currentUser.name),
                                icon: Icons.add),
                            if (list.users.length < 2)
                              RoundButton(
                                  onTap: () => addUser(list), icon: Icons.link)
                          ]),
                      SizedBox(
                          height: 400,
                          child: SingleChildScrollView(
                              child: Column(
                            children: [
                              if (listNamesToAdd.isNotEmpty)
                                Column(children: listNamesToAdd),
                              NamesListView(list: list),
                            ],
                          ))),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ColapIconButton(
                        icon: Icons.delete_sweep,
                        onPressed: () {
                          list.deleteList();
                          widget.onListDeleted();
                        },
                        text: "Supprimer la liste"),
                  ),
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

  void orderList(OrderBy newOrder) {
    setState(() {
      orderBy = newOrder.field;
    });
  }

  void changeDesc() {
    setState(() {
      desc = !desc;
    });
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
    return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: widget.list.names
            .map((e) => UIName(
                  name: e.name,
                  nameId: e.uid!,
                  listId: widget.list.uid!,
                  averageGrade: e.averageGrade,
                ))
            .toList());
  }
}

enum OrderBy {
  average("Moyenne globale", "average_grade"),
  grade1("Notes personne 1", "grade_1"),
  grade2("Notes personne 2", "grade_2"),
  alpha("Ordre alphabétique", "name"),
  time("Ordre chronologique", "added_at"),
  ;

  const OrderBy(this.displayName, this.field);
  final String displayName;
  final String field;
}
