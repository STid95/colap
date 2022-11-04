import 'package:colap/models/colap_list.dart';
import 'package:flutter/material.dart';

class ListProvider extends ChangeNotifier {
  ColapList? selectedList;
  ListProvider({
    this.selectedList,
  });

  void updateList(ColapList list) {
    selectedList = list;
    notifyListeners();
  }
}
