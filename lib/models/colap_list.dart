import 'package:cloud_firestore/cloud_firestore.dart';

import 'colap_name.dart';

class ColapList {
  String? uid;
  String title;
  List<ColapName> names;
  ColapList({
    this.uid,
    required this.title,
    this.names = const [],
  });
}

ColapList listFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
  var data = snapshot.data();
  if (data == null) throw Exception("list not found");
  return ColapList(
    uid: snapshot.id,
    title: snapshot['title'],
    names: snapshot['names'] != null
        ? List<ColapName>.from(
            snapshot['names']?.map((x) => nameFromSnapshot(x)))
        : [],
  );
}
