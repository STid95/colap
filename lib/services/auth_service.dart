import 'package:colap/models/colap_user.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

import 'database_user.dart';

class AuthService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final fb = FacebookLogin();

  Future<ColapUser?> signInwithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final result = await _firebaseAuth.signInWithCredential(credential);
      final user = result.user;
      return _userFromFirebase(user);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      rethrow;
    }
  }

  Future<ColapUser?> signInwithFacebook() async {
    final res = await fb.logIn(permissions: [FacebookPermission.email]);

// Check result status
    switch (res.status) {
      case FacebookLoginStatus.success:
        // Logged in
        // Send access token to server for validation and auth
        final FacebookAccessToken? accessToken = res.accessToken;

        if (accessToken != null) {
          final AuthCredential credential =
              FacebookAuthProvider.credential(accessToken.token);
          final result = await _firebaseAuth.signInWithCredential(credential);
          final user = result.user;

          if (user != null) {
            final profile = await fb.getUserProfile();
            final email = await fb.getUserEmail();
            final alreadySignedIn = await checkIfUserExist(profile!.name!);
            if (alreadySignedIn == false) {
              await DatabaseUserService(user.uid)
                  .saveUser(name: profile.name!, email: email ?? '');
              return _userFromFirebase(user);
            } else {
              return DatabaseUserService(user.uid)
                  .searchByUserName(profile.name!);
            }
          }
        }
        break;
      case FacebookLoginStatus.cancel:
        break;
      case FacebookLoginStatus.error:
        print('Error while log in: ${res.error}');
        break;
    }
    return null;
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  ColapUser? _userFromFirebase(auth.User? user) {
    if (user == null) return null;
    return ColapUser(uid: user.uid, email: user.email ?? '', name: '');
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
        await DatabaseUserService(user.uid).saveUser(name: name, email: email);
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
