import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colap/services/database_name.dart';

class ColapName {
  String? uid;
  String name;
  int grade1;
  int grade2;
  String comment;
  num averageGrade;
  ColapName(
      {required this.name,
      this.uid,
      this.comment = '',
      this.grade1 = 0,
      this.grade2 = 0,
      this.averageGrade = 0});

  DatabaseNameListService databaseNameListService = DatabaseNameListService();
  void updateRating1(String listUid) async {
    databaseNameListService.updateRating(listUid, uid!, "grade_1", grade1);
    updateAverage(listUid);
  }

  void updateRating2(String listUid) async {
    databaseNameListService.updateRating(listUid, uid!, "grade_2", grade2);
    updateAverage(listUid);
  }

  void updateAverage(String listUid) async {
    databaseNameListService.updateRating(
        listUid, uid!, "average_grade", (grade1 + grade2) / 2);
  }

  void updateComment(String listUid, String comment) async {
    databaseNameListService.updateComment(listUid, uid!, comment);
  }

  void remove(String listUid) async {
    databaseNameListService.removeName(listUid, uid!);
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
      averageGrade: data['average_grade']);
}

ColapName nameFromListSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot) {
  var data = snapshot.data();
  if (data == null) throw Exception("name not found");
  return ColapName(
      uid: snapshot.id,
      name: data['name'],
      averageGrade: data['average_grade']);
}
