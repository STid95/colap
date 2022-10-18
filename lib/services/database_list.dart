import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colap/models/colap_list.dart';
import 'package:colap/services/database_name.dart';

import '../models/colap_name.dart';

final listCollection = FirebaseFirestore.instance.collection("lists");

class DatabaseListService {
  String? uid;
  DatabaseListService();

  Future<ColapList?> createList(String title) async {
    final doc = await listCollection.add({'title': title, 'names': []});
    final uid = doc.id;
    return ColapList(title: title, names: [], uid: uid);
  }

  Future<void> saveList(String uid, {List<ColapName>? names}) async {
    await listCollection.doc(uid).set({'names': names ?? []});
  }

  Future<void> deleteList(String uid) async {
    listCollection.doc(uid).delete();
  }

  void addName(String uid, ColapName name) {
    listCollection.doc(uid).collection('names').add({
      'name': name.name,
      'grade_1': name.grade1 ?? 0,
      'grade_2': name.grade2 ?? 0,
      'comment': name.comment ?? ''
    });
  }

  Stream<ColapList> getList(String uid) {
    return listCollection.doc(uid).snapshots().map(listFromSnapshot);
  }

  Stream<List<ColapName>> getNames(String uid) {
    final DatabaseNameListService databaseNameListService =
        DatabaseNameListService(listUid: uid);

    return databaseNameListService.listNames;
  }
}
