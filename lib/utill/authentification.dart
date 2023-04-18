import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart' as apple;


class Authentification {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  late final bool isAvailable;



  Future<dynamic> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredential = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.credential(
              idToken: googleAuth.idToken, accessToken: googleAuth.accessToken),
        );
        print("user accessToken: ${userCredential.credential!.accessToken}");
        final fcmToken = await FirebaseMessaging.instance.getToken();
        await _setemail(userCredential.user!.email??"");
        _setaccesstoken(fcmToken!);
        return userCredential.user;
      }
    } else {
      throw FirebaseAuthException(
        message: "Sign in aborded by user",
        code: "ERROR_ABORDER_BY_USER",
      );
    }
  }

  Future<User> signInWithApple({List<apple.Scope> scopes = const []}) async {
    // 1. perform the sign-in request
    final result = await apple.TheAppleSignIn.performRequests(
        [apple.AppleIdRequest(requestedScopes: scopes)]);
    // 2. check the result
    switch (result.status) {
      case apple.AuthorizationStatus.authorized:
        final appleIdCredential = result.credential!;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken!),
          accessToken:
          String.fromCharCodes(appleIdCredential.authorizationCode!),
        );
        final userCredential =
        await _firebaseAuth.signInWithCredential(credential);
        print("user accessToken: ${userCredential.credential!.accessToken}");
        final fcmToken = await FirebaseMessaging.instance.getToken();
        await _setemail(userCredential.user!.email??"");
        _setaccesstoken(fcmToken!);
        final firebaseUser = userCredential.user!;
        if (scopes.contains(apple.Scope.fullName)) {
          final fullName = appleIdCredential.fullName;
          if (fullName != null &&
              fullName.givenName != null &&
              fullName.familyName != null) {
            final displayName = '${fullName.givenName} ${fullName.familyName}';
            await firebaseUser.updateDisplayName(displayName);
          }
        }
        return firebaseUser;
      case apple.AuthorizationStatus.error:
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );

      case apple.AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      default:
        throw UnimplementedError();
    }
  }

  _setemail(String email) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("email", email);
    print("set email"+email);
  }

  _setaccesstoken(String token) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("AccessToken", token);
    print("set token"+token);
  }
  //
  // Future<dynamic> signInWithGoogleSilent() async {
  //   dynamic _user;
  //   final googleSignIn = GoogleSignIn();
  //     googleSignIn.onCurrentUserChanged.listen((account) {
  //       _user=account
  //     });
  //     googleSignIn.signInSilently();
  // }

  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}