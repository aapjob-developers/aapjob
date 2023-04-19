import 'package:Aap_job/data/chat/chat_auth_repository.dart';
import 'package:Aap_job/data/chat/firebase_storage_repository.dart';
import 'package:Aap_job/data/enum/message_type.dart';
import 'package:Aap_job/helper/show_alert_dialog.dart';
import 'package:Aap_job/models/ChatUserModel.dart';
import 'package:Aap_job/models/common_functions.dart';
import 'package:Aap_job/models/last_message_model.dart';
import 'package:Aap_job/models/message_model.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:Aap_job/widgets/show_loading_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ChatRepository extends ChangeNotifier {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  ChatRepository({
    required this.auth,
    required this.firestore,
  });

  void sendFileMessage({
    required var file,
    required BuildContext context,
    required String receiverId,
    required ChatUserModel senderData,
    required MessageType messageType,
  }) async {
    try {
      final timeSent = DateTime.now();
      final messageId = const Uuid().v1();
      final imageUrl = await Provider.of<FirebaseStorageRepository>(context, listen: false).storeFileToFirebase('chats/${messageType.type}/${senderData.uid}/$receiverId/$messageId',file,);
      final userMap = await firestore.collection('users').doc(receiverId).get();
      final receverUserData = ChatUserModel.fromMap(userMap.data()!);
      String lastMessage;
      switch (messageType) {
        case MessageType.image:
          lastMessage = '📸 Photo message';
          break;
        case MessageType.audio:
          lastMessage = '📸 Voice message';
          break;
        case MessageType.video:
          lastMessage = '📸 Video message';
          break;
        case MessageType.gif:
          lastMessage = '📸 GIF message';
          break;
        default:
          lastMessage = '📦 GIF message';
          break;
      }

      saveToMessageCollection(
        receiverId: receiverId,
        textMessage: imageUrl,
        timeSent: timeSent,
        textMessageId: messageId,
        senderUsername: senderData.username,
        receiverUsername: receverUserData.username,
        messageType: messageType,
      );

      saveAsLastMessage(
        senderUserData: senderData,
        receiverUserData: receverUserData,
        lastMessage: lastMessage,
        timeSent: timeSent,
        receiverId: receiverId,
      );
    } catch (e) {
      showAlertDialog(context: context, message: e.toString());
    }
  }

  Stream<List<MessageModel>> getAllOneToOneMessage(String receiverId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<MessageModel> messages = [];
      for (var message in event.docs) {
        messages.add(MessageModel.fromMap(message.data()));
      }
      return messages;
    });
  }

  Stream<int> getAllUnseenMessage() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      int _totalunseenmsg=0;
      for (var message in event.docs) {
        print("in");
       if(!MessageModel.fromMap(message.data()).isSeen)
         _totalunseenmsg++;
      }
      return _totalunseenmsg;
    });
  }

  Stream<List<LastMessageModel>> getAllLastMessageList() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<LastMessageModel> contacts = [];
      for (var document in event.docs) {
        final lastMessage = LastMessageModel.fromMap(document.data());
        final userData = await firestore.collection('users').doc(lastMessage.contactId).get();
        final user = ChatUserModel.fromMap(userData.data()!);
        contacts.add(
          LastMessageModel(
            username: user.username,
            profileImageUrl: user.profileImageUrl,
            contactId: lastMessage.contactId,
            timeSent: lastMessage.timeSent,
            lastMessage: lastMessage.lastMessage,
          ),
        );

      }
      return contacts;
    });
  }

  void sendTextMessage({
    required BuildContext context,
    required String textMessage,
    required String receiverId,
   // required ChatUserModel senderData,
  }) async {
    try {
      final timeSent = DateTime.now();
      final receiverDataMap = await firestore.collection('users').doc(receiverId).get();
      final receiverData = ChatUserModel.fromMap(receiverDataMap.data()!);
      final textMessageId = const Uuid().v1();
      ChatUserModel? senderData= await Provider.of<ChatAuthRepository>(context, listen: false).getCurrentUserInfo()!;
      saveToMessageCollection(
        receiverId: receiverId,
        textMessage: textMessage,
        timeSent: timeSent,
        textMessageId: textMessageId,
        senderUsername: senderData!.username,
        receiverUsername: receiverData.username,
        messageType: MessageType.text,
      );

      saveAsLastMessage(
        senderUserData: senderData,
        receiverUserData: receiverData,
        lastMessage: textMessage,
        timeSent: timeSent,
        receiverId: receiverId,
      );
    } catch (e) {
      showAlertDialog(context: context, message: e.toString());
    }
  }

  void saveToMessageCollection({
    required String receiverId,
    required String textMessage,
    required DateTime timeSent,
    required String textMessageId,
    required String senderUsername,
    required String receiverUsername,
    required MessageType messageType,
  }) async {
    final message = MessageModel(
      senderId: auth.currentUser!.uid,
      receiverId: receiverId,
      textMessage: textMessage,
      type: messageType,
      timeSent: timeSent,
      messageId: textMessageId,
      isSeen: false,
    );

    // sender
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .doc(textMessageId)
        .set(message.toMap());

    // receiver
    await firestore
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(textMessageId)
        .set(message.toMap());
  }

  void saveAsLastMessage({
    required ChatUserModel senderUserData,
    required ChatUserModel receiverUserData,
    required String lastMessage,
    required DateTime timeSent,
    required String receiverId,
  }) async {
    final receiverLastMessage = LastMessageModel(
      username: senderUserData.username,
      profileImageUrl: senderUserData.profileImageUrl,
      contactId: senderUserData.uid,
      timeSent: timeSent,
      lastMessage: lastMessage,
    );

    await firestore
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(receiverLastMessage.toMap());

    final senderLastMessage = LastMessageModel(
      username: receiverUserData.username,
      profileImageUrl: receiverUserData.profileImageUrl,
      contactId: receiverUserData.uid,
      timeSent: timeSent,
      lastMessage: lastMessage,
    );

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .set(senderLastMessage.toMap());
  }


}