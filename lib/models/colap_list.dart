import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:colap/services/database_list.dart';

import 'colap_name.dart';

class ColapList {
  String? uid;
  String title;
  List<ColapName> names;
  List<String> users;

  ColapList(
      {this.uid,
      required this.title,
      this.names = const [],
      this.users = const []});

  DatabaseListService listService = DatabaseListService();

  void addName(ColapName name) async {
    listService.addName(uid!, name);
  }

  void addUser(String userName) async {
    listService.addUser(uid!, userName);
  }

  void deleteList() async {
    listService.deleteList(uid!);
  }
}

ColapList listFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
  var data = snapshot.data();
  if (data == null) throw Exception("list not found");
  ColapList list = ColapList(
      uid: snapshot.id,
      title: snapshot['title'],
      users: List<String>.from(snapshot['users']));
  return list;
}

List<ColapList> allUserListsFromSnapshot(
    QuerySnapshot<Map<String, dynamic>> snapshot) {
  return snapshot.docs.map((doc) {
    return listFromSnapshot(doc);
  }).toList();
}
