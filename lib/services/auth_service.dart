import 'package:colap/models/colap_user.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import 'database.dart';

class AuthService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  ColapUser? _userFromFirebase(auth.User? user) {
    if (user == null) return null;
    return ColapUser(uid: user.uid, email: user.email);
  }

  Stream<ColapUser?> get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      final user = result.user;
      return _userFromFirebase(user);
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }

  Future registerWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = result.user;
      if (user == null) {
        throw Exception("No user found");
      } else {
        await DatabaseService(user.uid).saveUser(name, [], email);
        return _userFromFirebase(user);
      }
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
