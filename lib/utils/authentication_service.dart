import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

final _providerOverlay = OverlayEntry(
  builder: (context) => Container(
    color: Colors.black26,
    child: Center(
      child: CircularProgressIndicator(),
    ),
  ),
);

void loginToFacebook(GlobalKey _key) async {
  final facebookLogin = FacebookLogin();
  final result = await facebookLogin.logIn(['email']);

  Overlay.of(_key.currentContext).insert(_providerOverlay);

  switch (result.status) {
    case FacebookLoginStatus.loggedIn:
      final credential = FacebookAuthProvider.getCredential(
        accessToken: result.accessToken.token,
      );
      _signInWithCredential(credential, _key);
      _providerOverlay.remove();
      break;
    case FacebookLoginStatus.error:
      _providerOverlay.remove();

      Scaffold.of(_key.currentContext).showSnackBar(
        SnackBar(
          content: Text(
            'There was an error logging you into Facebook',
          ),
        ),
      );
      debugPrint(result.errorMessage);
      break;
    case FacebookLoginStatus.cancelledByUser:
      _providerOverlay.remove();
      break;
    default:
      _providerOverlay.remove();
      break;
  }
}

void _signInWithCredential(AuthCredential credential, GlobalKey _key) async {
  try {
    await FirebaseAuth.instance.signInWithCredential(credential);

    Navigator.of(_key.currentContext)
        .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
  } on PlatformException catch (e) {
    String message = '';

    if (e.code.contains('ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL')) {
      message =
          'This account has an email address that is already in use with another login method. Please use a different account.';
    } else {
      message = 'Something went wrong, please try again.';
    }
    showDialog(
      context: _key.currentContext,
      builder: (context) {
        return AlertDialog(
          title: Text('Login Error'),
          content: Text(message),
        );
      },
    );

    print(e.code);

    try {
      FacebookLogin().logOut();
      GoogleSignIn().signOut();
    } catch (e) {}
  } finally {
    _providerOverlay.remove();
  }
}

void loginToGoogle(GlobalKey _key) async {
  final googleAccount = await GoogleSignIn().signIn();
  if (googleAccount == null) return;

  final googleAuth = await googleAccount.authentication;

  Overlay.of(_key.currentContext).insert(_providerOverlay);

  final credential = GoogleAuthProvider.getCredential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  _signInWithCredential(credential, _key);
}
