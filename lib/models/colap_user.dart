import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colap/models/colap_list.dart';
import 'package:colap/services/database_user.dart';

class ColapUser {
  String uid;
  String email;
  String name;
  List<ColapList>? lists;
  ColapUser({this.uid = '', this.email = '', this.name = ''});

  void deleteList(String listUid) async {
    DatabaseUserService userService = DatabaseUserService(uid);
    userService.deleteList(listUid);
  }

  Stream<List<ColapList>> getLists() {
    DatabaseUserService userService = DatabaseUserService(uid);
    return userService.getUserList(name);
  }
}

ColapUser userFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
  var data = snapshot.data();
  if (data == null) throw Exception("user not found");
  ColapUser user = ColapUser(
    uid: snapshot.id,
    email: data['email'],
    name: data['name'],
  );

  return user;
}
