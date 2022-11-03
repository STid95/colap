import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:colap/models/colap_list.dart';

import '../models/colap_user.dart';

final userCollection = FirebaseFirestore.instance.collection("users");

class DatabaseUserService {
  String uid;

  DatabaseUserService(this.uid);

  final listCollection = FirebaseFirestore.instance.collection("lists");

  Future<void> saveUser({required String name, required String email}) async {
    await userCollection.doc(uid).set({
      'name': name,
      'email': email,
      'name_lowercase': name.replaceAll(' ', '').toLowerCase()
    });
  }

  Future<void> saveToken(String? token) async {
    return await userCollection.doc(uid).update({'token': token});
  }

  Stream<ColapUser> get user {
    print(uid);
    return userCollection.doc(uid).snapshots().map(userFromSnapshot);
  }

  Stream<List<ColapList>> getUserList(String userName) {
    print(userName);
    var query =
        listCollection.where('users', arrayContains: userName).snapshots();
    return query.map((snapshot) => allUserListsFromSnapshot(snapshot));
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

  Future<ColapUser?> searchByEmail(String email) async {
    return userCollection.where("email", isEqualTo: email).get().then((value) {
      if (value.docs.isNotEmpty) {
        ColapUser user = userFromSnapshot(value.docs.first);
        return user;
      } else {
        return null;
      }
    });
  }
}

Future<bool> checkIfUserExist(String userName) async {
  return userCollection
      .where("name_lowercase", isEqualTo: userName)
      .get()
      .then((value) {
    print(value.docs.length);
    if (value.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  });
}

Future<bool> checkIfUserSignedIn(String email) async {
  return userCollection.where("email", isEqualTo: email).get().then((value) {
    print(value.docs.length);
    if (value.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  });
}
