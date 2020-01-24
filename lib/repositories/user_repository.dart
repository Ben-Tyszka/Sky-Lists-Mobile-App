import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseMessaging _firebaseMessaging;

  UserRepository({
    FirebaseAuth firebaseAuth,
    GoogleSignIn googleSignin,
    FirebaseMessaging firebaseMessaging,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn(),
        _firebaseMessaging = firebaseMessaging ?? FirebaseMessaging();

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final result = await _firebaseAuth.signInWithCredential(credential);

    await Firestore.instance
        .collection('users')
        .document(result.user.uid)
        .setData({
      'name': result.user.displayName,
      'email': result.user.email,
    });

    return result.user;
  }

  Future<void> signInWithEmailAndPassword(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUpWithEmailAndPassword({
    String email,
    String password,
    String name,
  }) async {
    final result = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await Firestore.instance
        .collection('users')
        .document(result.user.uid)
        .setData({
      'name': name,
      'email': email,
    });

    return result;
  }

  Future<void> signOut() async {
    final user = await FirebaseAuth.instance.currentUser();

    await removeCurrentToken(user);

    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<FirebaseUser> getUser() async {
    return await _firebaseAuth.currentUser();
  }

  Future<void> changeName({String name}) async {
    final user = await _firebaseAuth.currentUser();
    assert(user != null);

    final userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = name;
    await user.updateProfile(userUpdateInfo);

    await Firestore.instance.collection('users').document(user.uid).updateData({
      'name': name,
    });

    await user.reload();
  }

  Future<void> deleteAccount() async {
    final user = await _firebaseAuth.currentUser();
    assert(user != null);

    final listDocs = await Firestore.instance
        .collection('shopping lists')
        .document(user.uid)
        .collection('lists')
        .getDocuments();

    listDocs.documents.forEach((doc) async {
      final peopleListIsSharedWith =
          await doc.reference.collection('sharedwith').getDocuments();

      peopleListIsSharedWith.documents.forEach((personSharedWith) async {
        await Firestore.instance
            .collection('users')
            .document(personSharedWith.documentID)
            .collection('sharedwithme')
            .document(doc.documentID)
            .delete();
      });
    });

    await removeCurrentToken(user);

    await Firestore.instance
        .collection('shopping lists')
        .document(user.uid)
        .delete();

    await Firestore.instance.collection('users').document(user.uid).delete();

    // Note: Share history is preserved with users that had shared a list with this user
    user.delete();
  }

  Future<void> reauthenticateWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final user = await _firebaseAuth.currentUser();
    assert(user != null);

    final authCred = EmailAuthProvider.getCredential(
      email: email,
      password: password,
    );

    final result = await user.reauthenticateWithCredential(authCred);

    return result;
  }

  Future<void> reauthenticateWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential authCred = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final user = await _firebaseAuth.currentUser();
    assert(user != null);

    final result = await user.reauthenticateWithCredential(authCred);

    return result;
  }

  Future<void> changePassword(
    String newPassword,
  ) async {
    final user = await _firebaseAuth.currentUser();
    assert(user != null);

    return await user.updatePassword(newPassword);
  }

  Future<void> setToken(FirebaseUser user) async {
    String fcmToken = await _firebaseMessaging.getToken();

    if (fcmToken != null) {
      final token = Firestore.instance
          .collection('users')
          .document(user.uid)
          .collection('tokens')
          .document(fcmToken);

      await token.setData(
        {
          'token': fcmToken,
          'createdAt': FieldValue.serverTimestamp(),
          'platform': Platform.operatingSystem,
        },
      );
    }
  }

  Future<void> removeCurrentToken(FirebaseUser user) async {
    String fcmToken = await _firebaseMessaging.getToken();

    if (fcmToken != null) {
      Firestore.instance
          .collection('users')
          .document(user.uid)
          .collection('tokens')
          .document(fcmToken)
          .delete();
    }
  }
}
