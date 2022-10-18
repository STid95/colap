import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colap/services/database_name.dart';

class ColapName {
  String? uid;
  String name;
  int grade1;
  int grade2;
  String comment;
  ColapName(
      {required this.name,
      this.uid,
      this.comment = '',
      this.grade1 = 1,
      this.grade2 = 1});

  DatabaseNameListService databaseNameListService = DatabaseNameListService();
  void updateRating1(String listUid) async {
    databaseNameListService.updateRating(listUid, uid!, "grade_1", grade1);
  }
}

ColapName nameFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
  var data = snapshot.data();
  if (data == null) throw Exception("name not found");
  return ColapName(
    uid: snapshot.id,
    name: data['name'],
    grade1: data['grade_1'],
    grade2: data['grade_2'],
    comment: data['comment'],
  );
}

ColapName nameFromListSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot) {
  var data = snapshot.data();
  if (data == null) throw Exception("name not found");
  return ColapName(
    uid: snapshot.id,
    name: data['name'],
  );
}
