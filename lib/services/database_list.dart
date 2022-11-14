import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colap/models/colap_list.dart';
import 'package:colap/services/database_name.dart';

import '../models/colap_name.dart';

final listCollection = FirebaseFirestore.instance.collection("lists");

class DatabaseListService {
  String? uid;
  DatabaseListService();

  Future<ColapList?> createList(String title, String userNickname) async {
    final doc = await listCollection.add({
      'title': title,
      'users': [userNickname]
    });
    final uid = doc.id;
    return ColapList(title: title, names: [], uid: uid);
  }

  Future<void> addUser(String uid, String userName) async {
    await listCollection.doc(uid).update({
      'users': FieldValue.arrayUnion([userName])
    });
  }

  Future<void> deleteList(String uid) async {
    listCollection.doc(uid).delete();
  }

  void addName(String uid, ColapName name) {
    listCollection.doc(uid).collection('names').add({
      'name': name.name,
      'grade_1': name.grade1,
      'grade_2': name.grade2,
      'comment': name.comment,
      'average_grade': name.averageGrade,
      'added_at': Timestamp.now()
    });
  }

  Stream<ColapList> getList(String uid) {
    return listCollection.doc(uid).snapshots().map(listFromSnapshot);
  }

  Stream<List<ColapName>> getNames(String uid, String orderBy, bool desc) {
    final DatabaseNameListService databaseNameListService =
        DatabaseNameListService();

    return databaseNameListService.getListNames(uid, orderBy, desc);
  }

  Future<List<ColapName>> getNamesAsFuture(String uid) {
    final DatabaseNameListService databaseNameListService =
        DatabaseNameListService();

    return databaseNameListService.getNamesAsFuture(uid);
  }

  Future<List<ColapName>> getNamesAsFutureInLists(List<String?> uids) {
    final DatabaseNameListService databaseNameListService =
        DatabaseNameListService();

    return databaseNameListService.getNamesAsFutureFromLists(uids);
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
