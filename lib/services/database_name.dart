import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:colap/models/colap_name.dart';

class DatabaseNameListService {
  DatabaseNameListService();

  Stream<ColapName> getName(String listUid, String uid) {
    final namesCollection = FirebaseFirestore.instance
        .collection("lists")
        .doc(listUid)
        .collection("names");

    return namesCollection.doc(uid).snapshots().map(nameFromSnapshot);
  }

  Future<void> removeName(String listUid, String uid) {
    final namesCollection = FirebaseFirestore.instance
        .collection("lists")
        .doc(listUid)
        .collection("names");
    return namesCollection.doc(uid).delete();
  }

  Future<void> updateRating(
      String listUid, String uid, String field, num rating) async {
    FirebaseFirestore.instance
        .collection("lists")
        .doc(listUid)
        .collection("names")
        .doc(uid)
        .update({field: rating});
  }

  Future<void> updateComment(String listUid, String uid, String comment) async {
    FirebaseFirestore.instance
        .collection("lists")
        .doc(listUid)
        .collection("names")
        .doc(uid)
        .update({'comment': comment});
  }

  Stream<List<ColapName>> getListNames(String listUid) {
    final namesCollection = FirebaseFirestore.instance
        .collection("lists")
        .doc(listUid)
        .collection("names")
        .orderBy('average_grade', descending: true);
    return namesCollection.snapshots().map(allNamesFromSnapshot);
  }

  List<ColapName> allNamesFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      return nameFromListSnapshot(doc);
    }).toList();
  }
}
