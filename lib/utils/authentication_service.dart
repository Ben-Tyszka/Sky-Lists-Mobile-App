import 'dart:convert';
import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sky_lists/presentational_widgets/pages/logged_in_home_page.dart';

/// Overlay that darkens screen and inserts CircularProgressIndicator while 3rd party login flows occur
final _providerOverlay = OverlayEntry(
  builder: (context) => Container(
    color: Colors.black26,
    child: Center(
      child: CircularProgressIndicator(),
    ),
  ),
);

/// Logs user into Facebbok, [_key] is needed to insert overlay
loginToFacebook(GlobalKey _key) async {
  final facebookLogin = FacebookLogin();
  // Attemps to log user in
  final result = await facebookLogin.logIn(['email']);

  // Adds overlay
  Overlay.of(_key.currentContext).insert(_providerOverlay);

  switch (result.status) {
    case FacebookLoginStatus.loggedIn:
      // If logged in, grab credential and sign into firebase
      final credential = FacebookAuthProvider.getCredential(
        accessToken: result.accessToken.token,
      );
      final authResult =
          await _signInWithCredential(credential: credential, key: _key);
      if (authResult == null) return;

      // Navigates to LoggedInHomePage
      Navigator.of(_key.currentContext).pushNamedAndRemoveUntil(
          LoggedInHomePage.routeName, (Route<dynamic> route) => false);
      _providerOverlay.remove();
      break;
    case FacebookLoginStatus.error:
      // If something went wrong remove overlay and notify user
      _providerOverlay.remove();
      Scaffold.of(_key.currentContext).showSnackBar(
        SnackBar(
          content: Text(
            'There was an error logging you into Facebook',
          ),
        ),
      );
      // Log for deubging
      log(
        'Facebook login error',
        name: 'authentication_service loginToFacebook',
        error: jsonEncode(result),
      );
      break;
    case FacebookLoginStatus.cancelledByUser:
      // If cancelled, just remove overlay
      _providerOverlay.remove();
      break;
    default:
      _providerOverlay.remove();
      break;
  }
}

/// Logs user into firebase auth system with [credential], [key] is needed to push home route
Future<AuthResult> _signInWithCredential({
  @required AuthCredential credential,
  @required GlobalKey key,
}) async {
  try {
    // Signs user into firebase auth system
    final authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);

    // Tell analytics Log that the user has logged in with 3rd party service
    Provider.of<FirebaseAnalytics>(key.currentContext)
        .logLogin(loginMethod: credential.providerId);

    log('3rd party login | Provider: ${credential.providerId} | isNewUser: ${authResult.additionalUserInfo.isNewUser}',
        name: 'authenticationService _signInWithCredential');

    return authResult;
  } on PlatformException catch (error) {
    String message = '';
    // If something went wrong, notify user
    if (error.code == 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL') {
      message =
          'This account has an email address that is already in use with another login method. Please use a different account.';
    } else {
      message = 'Something went wrong, please try again.';
    }
    showDialog(
      context: key.currentContext,
      builder: (context) {
        return AlertDialog(
          title: Text('Login Error'),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    // Setup debug logging and analytics for failure to login
    log(
      'Something went wrong when trying to link ${credential.providerId} login to firebase auth system',
      name: 'authentication_service _signInWithCredential',
      error: jsonEncode(error),
    );

    Provider.of<FirebaseAnalytics>(key.currentContext).logEvent(
      name: 'login_with_${credential.providerId}_failed',
      parameters: {
        'code': error.code,
        'message': error.message,
        'details': error.details,
      },
    );

    // Logout user from service and remove overlay
    try {
      GoogleSignIn().signOut();
      FacebookLogin().logOut();
    } catch (e) {}
  } finally {
    _providerOverlay.remove();
  }

  return null;
}

/// Logs user into Google, [_key] is needed to insert overlay
loginToGoogle(GlobalKey _key) async {
  // Trys to log into google account
  final googleAccount = await GoogleSignIn().signIn();
  // Return if user exits or is unsuccessful
  if (googleAccount == null) return;

  final googleAuth = await googleAccount.authentication;

  // Add overlay
  Overlay.of(_key.currentContext).insert(_providerOverlay);

  // Grab credential
  final credential = GoogleAuthProvider.getCredential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Link with firebase
  final result = await _signInWithCredential(credential: credential, key: _key);

  if (result == null) return;

  // Navigates to LoggedInHomePage
  Navigator.of(_key.currentContext).pushNamedAndRemoveUntil(
      LoggedInHomePage.routeName, (Route<dynamic> route) => false);
}

/// Logs user into Google
///
/// Returns Future<AuthCredential> that can be used to reauthenticate the user
Future<AuthCredential> loginToGoogleAuthCredential() async {
  // Trys to log into google account
  final googleAccount = await GoogleSignIn().signIn();
  // Return if user exits or is unsuccessful
  if (googleAccount == null) return null;

  final googleAuth = await googleAccount.authentication;

  // Grab credential
  return GoogleAuthProvider.getCredential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
}

/// Logs user into Facebbok
///
/// Returns Future<AuthCredential> that can be used to reauthenticate the user
Future<AuthCredential> loginToFacebookAuthCredential(
    BuildContext context) async {
  final facebookLogin = FacebookLogin();
  // Attemps to log user in
  final result = await facebookLogin.logIn(['email']);

  AuthCredential credential;

  switch (result.status) {
    case FacebookLoginStatus.loggedIn:
      // If logged in, grab credential
      credential = FacebookAuthProvider.getCredential(
        accessToken: result.accessToken.token,
      );
      break;
    case FacebookLoginStatus.error:
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'There was an error logging you into Facebook',
          ),
        ),
      );
      // Log for deubging
      log(
        'Facebook login error',
        name: 'authentication_service loginToFacebook',
        error: jsonEncode(result),
      );
      break;
    default:
      break;
  }

  return credential;
}
