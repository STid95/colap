import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:colap/services/database_list.dart';

import 'colap_name.dart';

class ColapList {
  String? uid;
  String title;
  List<ColapName> names;
  String user1;
  String user2;
  ColapList({
    this.uid,
    required this.title,
    this.names = const [],
    this.user1 = '',
    this.user2 = '',
  });

  DatabaseListService listService = DatabaseListService();

  void addName(ColapName name) async {
    listService.addName(uid!, name);
  }

  void deleteList() async {
    listService.deleteList(uid!);
  }
}

ColapList userListFromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot) {
  var data = snapshot.data();
  if (data == null) throw Exception("list not found");
  return ColapList(
      uid: snapshot['uid'],
      title: snapshot['title'],
      user1: snapshot['user_1'],
      user2: snapshot['user_2']);
}

ColapList listFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
  var data = snapshot.data();
  if (data == null) throw Exception("list not found");
  ColapList list = ColapList(
      uid: snapshot.id,
      title: snapshot['title'],
      user1: snapshot['user_1'],
      user2: snapshot['user_2']);
  return list;
}

List<ColapList> allUserListsFromSnapshot(
    QuerySnapshot<Map<String, dynamic>> snapshot) {
  return snapshot.docs.map((doc) {
    return userListFromSnapshot(doc);
  }).toList();
}
