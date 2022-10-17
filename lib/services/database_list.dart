import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colap/models/colap_list.dart';
import 'package:colap/services/database_name.dart';

import '../models/colap_name.dart';

class DatabaseListService {
  String? uid;

  DatabaseListService({this.uid});

  final listCollection = FirebaseFirestore.instance.collection("lists");

  Future<void> saveList({List<ColapName>? names}) async {
    await listCollection.doc(uid).set({'names': names ?? []});
  }

  Future<ColapList?> createList(String title) async {
    final doc = await listCollection.add({'title': title, 'names': []});
    uid = doc.id;
    return ColapList(title: title, names: [], uid: uid);
  }

  Future<void> deleteList() async {
    listCollection.doc(uid).delete();
  }

  Future<List<ColapName>> addName(ColapName name) {
    listCollection.doc(uid).collection('names').add({
      'name': name.name,
      'grade_1': name.grade1 ?? 0,
      'grade_2': name.grade2 ?? 0,
      'comment': name.comment ?? ''
    });
    return names;
  }

  Stream<ColapList> get list {
    return listCollection.doc(uid).snapshots().map(listFromSnapshot);
  }

  Future<List<ColapName>> get names {
    return DatabaseNameListService(listUid: uid!).nameLists;
  }
}
