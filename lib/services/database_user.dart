import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colap/models/colap_list.dart';

import '../models/colap_user.dart';

class DatabaseUserService {
  String uid;

  DatabaseUserService(this.uid);

  final userCollection = FirebaseFirestore.instance.collection("users");

  Future<void> saveUser({required String name, required String email}) async {
    await userCollection
        .doc(uid)
        .set({'name': name, 'email': email, 'hasList': false});
  }

  Future<void> addList(ColapList list, ColapUser user) async {
    userCollection
        .doc(uid)
        .collection('lists')
        .doc(list.uid)
        .set({'title': list.title, 'uid': list.uid});
    await userCollection
        .doc(user.uid)
        .set({'name': user.name, 'email': user.email, 'hasList': true});
  }

  Future<void> saveToken(String? token) async {
    return await userCollection.doc(uid).update({'token': token});
  }

  Stream<ColapUser> get user {
    return userCollection.doc(uid).snapshots().map(userFromSnapshot);
  }

  Future<List<ColapList>> get userLists async {
    final listCollection = userCollection.doc(uid).collection("lists");
    QuerySnapshot querySnapshot = await listCollection.get();
    if (querySnapshot.docs.isNotEmpty) {
      final lists = querySnapshot.docs.map((doc) {
        return ColapList(title: doc.get('title'), uid: doc.get('uid'));
      }).toList();
      return lists;
    } else {
      return [];
    }
  }

  Stream<List<ColapList>> get userList {
    return userCollection
        .doc(uid)
        .collection("lists")
        .snapshots()
        .map(allUserListsFromSnapshot);
  }
}
