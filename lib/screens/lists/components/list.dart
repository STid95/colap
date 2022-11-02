import 'package:colap/commons/ui.commons.dart';
import 'package:colap/screens/lists/components/dialogs/remove_dialog.dart';
import 'package:colap/screens/lists/components/dropdown_order.dart';
import 'package:colap/screens/lists/components/dialogs/add_user_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:colap/models/colap_list.dart';
import 'package:colap/models/colap_name.dart';
import 'package:colap/services/database_list.dart';
import 'package:colap/screens/lists/components/name_add.dart';
import 'package:colap/screens/lists/components/name_preview.dart';

import '../../../models/colap_user.dart';

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
  List<AddName> listNamesToAdd = [];
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
                          DropdownOrder(
                              onChanged: (newOrder) => orderList(newOrder))
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
                          height: MediaQuery.of(context).size.height * 0.45,
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
                          showRemoveDialog(context, (() {
                            list.deleteList();
                            widget.onListDeleted();
                            Navigator.pop(context);
                          }));
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
      listNamesToAdd.add(AddName(
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
            .map((e) => NamePreview(
                  name: e.name,
                  nameId: e.uid!,
                  listId: widget.list.uid!,
                  averageGrade: e.averageGrade,
                ))
            .toList());
  }
}
