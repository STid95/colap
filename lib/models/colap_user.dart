import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colap/models/colap_list.dart';
import 'package:colap/services/database_user.dart';

class ColapUser {
  String uid;
  String email;
  String name;
  bool hasList;
  List<ColapList>? lists;
  ColapUser(
      {this.uid = '', this.email = '', this.name = '', this.hasList = false});

  void deleteList(String listUid) async {
    DatabaseUserService userService = DatabaseUserService(uid);

    userService.deleteList(listUid);
  }
}

ColapUser userFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
  var data = snapshot.data();
  if (data == null) throw Exception("user not found");
  ColapUser user = ColapUser(
      uid: snapshot.id,
      email: data['email'],
      name: data['name'],
      hasList: data['hasList']);

  return user;
}
