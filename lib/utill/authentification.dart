import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentification {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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