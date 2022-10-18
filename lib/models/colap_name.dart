import 'package:cloud_firestore/cloud_firestore.dart';

class ColapName {
  String name;
  int? grade1;
  int? grade2;
  String? comment;
  ColapName({
    required this.name,
    this.grade1,
    this.grade2,
    this.comment,
  });
}

ColapName nameFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
  var data = snapshot.data();
  print(data);
  if (data == null) throw Exception("name not found");
  return ColapName(
    name: data['name'],
    grade1: data['grade1'] ?? 0,
    grade2: data['grade2'] ?? 0,
    comment: data['comment'] ?? '',
  );
}
