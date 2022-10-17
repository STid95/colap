import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colap/services/database_list.dart';

import 'colap_name.dart';

class ColapList {
  String? uid;
  String title;
  List<ColapName> names;
  ColapList({
    this.uid,
    required this.title,
    this.names = const [],
  });

  Future<List<ColapName>> addName(ColapName name) async {
    DatabaseListService listService = DatabaseListService(uid: uid!);
    return await listService.addName(name);
  }

  Future<List<ColapName>> get fetchedNames {
    DatabaseListService listService = DatabaseListService(uid: uid!);
    return listService.names;
  }
}

ColapList userListFromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot) {
  var data = snapshot.data();
  if (data == null) throw Exception("list not found");
  return ColapList(
    uid: snapshot['uid'],
    title: snapshot['title'],
  );
}

ColapList listFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
  var data = snapshot.data();
  if (data == null) throw Exception("list not found");
  ColapList list = ColapList(uid: snapshot.id, title: snapshot['title']);
  return list;
}

List<ColapList> allUserListsFromSnapshot(
    QuerySnapshot<Map<String, dynamic>> snapshot) {
  return snapshot.docs.map((doc) {
    return userListFromSnapshot(doc);
  }).toList();
}
