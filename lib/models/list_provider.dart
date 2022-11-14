import 'package:flutter/material.dart';

import 'package:colap/models/colap_list.dart';

class ListProvider extends ChangeNotifier {
  ColapList? selectedList;
  List<ColapList> selectedLists;
  ListProvider({
    this.selectedList,
    required this.selectedLists,
  });

  void updateList(ColapList list) {
    selectedList = list;
    notifyListeners();
  }

  void addList(ColapList list) {
    selectedLists.add(list);
    notifyListeners();
  }
}
