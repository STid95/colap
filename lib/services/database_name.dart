import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:colap/models/colap_name.dart';

class DatabaseNameListService {
  String? uid;
  String listUid;

  DatabaseNameListService({
    this.uid,
    required this.listUid,
  });

  Stream<ColapName> get name {
    final namesCollection = FirebaseFirestore.instance
        .collection("lists")
        .doc(listUid)
        .collection("names");

    return namesCollection.doc(uid).snapshots().map(nameFromSnapshot);
  }

  Future<List<ColapName>> get nameLists async {
    final namesCollection = FirebaseFirestore.instance
        .collection("lists")
        .doc(listUid)
        .collection("names");
    QuerySnapshot querySnapshot = await namesCollection.get();
    if (querySnapshot.docs.isNotEmpty) {
      final lists = querySnapshot.docs.map((doc) {
        return ColapName(
            name: doc['name'],
            grade1: doc['grade_1'],
            grade2: doc['grade_2'],
            comment: doc['comment']);
      }).toList();
      return lists;
    } else {
      return [];
    }
  }
}
