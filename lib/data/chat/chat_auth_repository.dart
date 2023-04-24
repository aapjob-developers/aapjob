import 'package:Aap_job/data/chat/firebase_storage_repository.dart';
import 'package:Aap_job/models/ChatUserModel.dart';
import 'package:Aap_job/models/common_functions.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:Aap_job/widgets/show_loading_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatAuthRepository extends ChangeNotifier {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseDatabase realtime;

  ChatAuthRepository({
    required this.auth,
    required this.firestore,
    required this.realtime,
  });

  Stream<ChatUserModel> getUserPresenceStatus({required String uid}) {
    return firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((event) => ChatUserModel.fromMap(event.data()!));
  }

  void updateUserPresence() {
    Map<String, dynamic> online = {
      'active': true,
      'lastSeen': DateTime.now().millisecondsSinceEpoch,
    };
    Map<String, dynamic> offline = {
      'active': false,
      'lastSeen': DateTime.now().millisecondsSinceEpoch,
    };

    final connectedRef = realtime.ref('.info/connected');

    connectedRef.onValue.listen((event) async {
      final isConnected = event.snapshot.value as bool ?? false;
      if (isConnected) {
        await realtime.ref().child(auth.currentUser!.uid).update(online);
      } else {
        realtime
            .ref()
            .child(auth.currentUser!.uid)
            .onDisconnect()
            .update(offline);
      }
    });
  }

  Future<ChatUserModel?> getCurrentUserInfo() async {
    ChatUserModel? user;
    final userInfo =
    await firestore.collection('users').doc(auth.currentUser?.uid).get();
    if (userInfo.data() == null) return user;
    user = ChatUserModel.fromMap(userInfo.data()!);
    return user;
  }

  saveUserInfoToFirestore({
    required String username,
    required String Phone,
    required var profileImage,
    required String Jobcity,
    required BuildContext context,
    required bool mounted,
  }) async {
    try {
      // showLoadingDialog(
      //   context: context,
      //   message: "Saving user info ... ",
      // );
      String uid = auth.currentUser!.uid;
      String profileImageUrl = profileImage is String ? profileImage : '';
      if (profileImage != null && profileImage is! String) {
        profileImageUrl = await Provider.of<FirebaseStorageRepository>(context, listen: false).storeFileToFirebase('profileImage/$uid', profileImage);
      }
      //Joblist= sharedPreferences!.getString("jobtypelist")?? "[]";
      ChatUserModel user = ChatUserModel(
        username: username,
        uid: uid,
        profileImageUrl: profileImageUrl,
        active: true,
        lastSeen: DateTime.now().millisecondsSinceEpoch,
        phoneNumber: Phone,
        groupId: [],
        city: Provider.of<AuthProvider>(context, listen: false).getJobCity(),
        jobtitle: Provider.of<AuthProvider>(context, listen: false).getJobtitle(),
        JobCat: [],
      );
      await firestore.collection('users').doc(uid).set(user.toMap());
      if (!mounted) return false;
    } catch (e) {
      Navigator.pop(context);
      CommonFunctions.showInfoDialog(e.toString(), context);
    }
  }


  //     await auth.signInWithCredential(credential);
  //     UserModel? user = await getCurrentUserInfo();
  //     if (!mounted) return;
  //     Navigator.pushNamedAndRemoveUntil(
  //       context,
  //       Routes.userInfo,
  //           (route) => false,
  //       arguments: user?.profileImageUrl,
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     Navigator.pop(context);
  //     showAlertDialog(context: context, message: e.toString());
  //   }
  // }

  // void sendSmsCode({
  //   required BuildContext context,
  //   required String phoneNumber,
  // }) async {
  //   try {
  //     showLoadingDialog(
  //       context: context,
  //       message: "Sending a verification code to $phoneNumber",
  //     );
  //     await auth.verifyPhoneNumber(
  //       phoneNumber: phoneNumber,
  //       verificationCompleted: (PhoneAuthCredential credential) async {
  //         await auth.signInWithCredential(credential);
  //       },
  //       verificationFailed: (e) {
  //         showAlertDialog(context: context, message: e.toString());
  //       },
  //       codeSent: (smsCodeId, resendSmsCodeId) {
  //         Navigator.pushNamedAndRemoveUntil(
  //           context,
  //           Routes.verification,
  //               (route) => false,
  //           arguments: {
  //             'phoneNumber': phoneNumber,
  //             'smsCodeId': smsCodeId,
  //           },
  //         );
  //       },
  //       codeAutoRetrievalTimeout: (String smsCodeId) {},
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     Navigator.pop(context);
  //     showAlertDialog(context: context, message: e.toString());
  //   }
  // }
}