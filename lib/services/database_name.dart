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

  Future<void> updateRating(
      String listUid, String uid, String field, int rating) async {
    FirebaseFirestore.instance
        .collection("lists")
        .doc(listUid)
        .collection("names")
        .doc(uid)
        .update({field: rating});
  }

  Stream<List<ColapName>> getListNames(String listUid) {
    final namesCollection = FirebaseFirestore.instance
        .collection("lists")
        .doc(listUid)
        .collection("names");
    return namesCollection.snapshots().map(allNamesFromSnapshot);
  }

  List<ColapName> allNamesFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      return nameFromListSnapshot(doc);
    }).toList();
  }
}
