import 'dart:developer';

import 'package:Aap_job/models/ChatUserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';


class ContactsRepository extends ChangeNotifier{
  final FirebaseFirestore firestore;

  ContactsRepository({required this.firestore});

  Future<List<List<ChatUserModel>>> getAllContacts() async {
    List<ChatUserModel> firebaseContacts = [];
    List<ChatUserModel> phoneContacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        final userCollection = await firestore.collection('users').get();
        final allContactsInThePhone = await FlutterContacts.getContacts(
          withProperties: true,
        );
        print("Total->${allContactsInThePhone.length}");
        bool isContactFound = false;
        for (var contact in allContactsInThePhone) {
          for (var firebaseContactData in userCollection.docs) {
            var firebaseContact = ChatUserModel.fromMap(firebaseContactData.data());
           // print("Firebase Contact ${firebaseContact.phoneNumber} PhoneContact ${contact.phones[0].number.replaceAll(' ', '').replaceAll('-','').replaceAll('(','').replaceAll(')','')}");
            if (contact.phones[0].number.replaceAll(' ', '').replaceAll('-','').replaceAll('(','').replaceAll(')','') ==
                firebaseContact.phoneNumber) {
              firebaseContacts.add(firebaseContact);
              isContactFound = true;
              break;
            }
          }
          if (!isContactFound) {
            phoneContacts.add(
              ChatUserModel(
                username: contact.displayName,
                uid: '',
                profileImageUrl: '',
                active: false,
                lastSeen: 0,
                phoneNumber: contact.phones[0].number.replaceAll(' ', ''),
                groupId: [],
                city: "",
                jobtitle: "",
                JobCat: [],
              ),
            );
          }

          isContactFound = false;
        }
      }
    } catch (e) {
      log("error"+e.toString());
    }
    return [firebaseContacts, phoneContacts];
  }
}
