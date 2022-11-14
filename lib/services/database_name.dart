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

  Stream<List<ColapName>> getListNames(
      String listUid, String orderBy, bool desc) {
    final namesCollection = FirebaseFirestore.instance
        .collection("lists")
        .doc(listUid)
        .collection("names")
        .orderBy(orderBy, descending: desc);
    return namesCollection.snapshots().map(allNamesFromSnapshot);
  }

  Future<List<ColapName>> getNamesAsFuture(String listUid) async {
    final namesCollection = FirebaseFirestore.instance
        .collection("lists")
        .doc(listUid)
        .collection("names")
        .get();
    return namesCollection.then((value) => allNamesFromSnapshot(value));
  }

  Future<List<ColapName>> getNamesAsFutureFromLists(
      List<String?> listsUids) async {
    List<ColapName> names = [];
    for (var uid in listsUids) {
      names.addAll(await getNames(uid!));
    }
    return names;
  }

  Future<List<ColapName>> getNames(String listUid) async {
    return await getNamesAsFuture(listUid);
  }

  List<ColapName> allNamesFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      return nameFromListSnapshot(doc);
    }).toList();
  }
}
