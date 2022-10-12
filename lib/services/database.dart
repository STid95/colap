import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/colap_user.dart';

class DatabaseService {
  String uid;

  DatabaseService(this.uid);

  final userCollection = FirebaseFirestore.instance.collection("users");

  Future<void> saveUser(String name, List<String>? lists, String email) async {
    await userCollection
        .doc(uid)
        .set({'name': name, 'lists': lists ?? [], 'email': email});
  }

  Future<void> saveToken(String? token) async {
    return await userCollection.doc(uid).update({'token': token});
  }

  ColapUser _userFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data();
    if (data == null) throw Exception("user not found");
    return ColapUser(
      uid: snapshot.id,
      email: data['email'],
      name: data['name'],
      lists: List<String>.from(data['lists']) ?? [],
    );
  }

  Stream<ColapUser> get user {
    return userCollection.doc(uid).snapshots().map(_userFromSnapshot);
  }

  List<ColapUser> _userListFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      return _userFromSnapshot(doc);
    }).toList();
  }

  Stream<List<ColapUser>> get users {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }
}
