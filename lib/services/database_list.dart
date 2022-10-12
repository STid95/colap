import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colap/models/colap_list.dart';

import '../models/colap_name.dart';

class DatabaseListService {
  String? uid;

  DatabaseListService({this.uid});

  final listCollection = FirebaseFirestore.instance.collection("lists");

  Future<void> saveList({List<ColapName>? names}) async {
    await listCollection.doc(uid).set({'names': names ?? []});
  }

  Future<ColapList?> createList(String title) async {
    final doc = await listCollection.add({'title': title});
    uid = doc.id;
    return ColapList(title: title, names: [], uid: uid);
  }

  Future<void> deleteList() async {
    listCollection.doc(uid).delete();
  }

  Stream<ColapList> get list {
    return listCollection.doc(uid).snapshots().map(listFromSnapshot);
  }
}
