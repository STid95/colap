import 'package:colap/commons/ui.commons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/colap_list.dart';
import '../../../models/colap_user.dart';
import 'tab_bar.dart';

class UserLists extends StatelessWidget {
  const UserLists({
    Key? key,
    required this.listId,
  }) : super(key: key);

  final String? listId;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<ColapList>>.value(
        value: Provider.of<ColapUser>(context).getLists(),
        initialData: const [],
        builder: (context, child) {
          List<ColapList> lists = Provider.of<List<ColapList>>(context);
          return (listId != null &&
                  lists.where((element) => element.uid == listId).isEmpty)
              ? circularProgress()
              : ColapTabBar(
                  lists: lists,
                  createdListId: listId,
                );
        });
  }
}
