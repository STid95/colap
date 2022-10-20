import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:colap/models/colap_list.dart';

import '../models/colap_user.dart';

class DatabaseUserService {
  String uid;

  DatabaseUserService(this.uid);

  final userCollection = FirebaseFirestore.instance.collection("users");
  final listCollection = FirebaseFirestore.instance.collection("lists");

  Future<void> saveUser({required String name, required String email}) async {
    await userCollection.doc(uid).set({'name': name, 'email': email});
  }

  Future<void> deleteList(String listUid) {
    return userCollection.doc(uid).collection('lists').doc(listUid).delete();
  }

  Future<void> saveToken(String? token) async {
    return await userCollection.doc(uid).update({'token': token});
  }

  Stream<ColapUser> get user {
    return userCollection.doc(uid).snapshots().map(userFromSnapshot);
  }

  Future<ColapUser?> searchByUserName(String userName) async {
    return userCollection
        .where("name", isEqualTo: userName)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        ColapUser user = userFromSnapshot(value.docs.first);
        return user;
      } else {
        return null;
      }
    });
  }

  Stream<List<ColapList>> getUserList(String userName) {
    var query =
        listCollection.where('users', arrayContains: userName).snapshots();
    return query.map((snapshot) => allUserListsFromSnapshot(snapshot));
  }
}
