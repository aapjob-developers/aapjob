import 'package:flutter/cupertino.dart';

class ChatUserModel {
  final String username;
  final String uid;
  final String profileImageUrl;
  final bool active;
  final int lastSeen;
  final String phoneNumber;
  final List<String> groupId;
  final String city;
  final String jobtitle;
  final List<String> JobCat;

  ChatUserModel({
    required this.username,
    required this.uid,
    required this.profileImageUrl,
    required this.active,
    required this.lastSeen,
    required this.phoneNumber,
    required this.groupId,
    required this.city,
    required this.jobtitle,
    required this.JobCat,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'uid': uid,
      'profileImageUrl': profileImageUrl,
      'active': active,
      'lastSeen': lastSeen,
      'phoneNumber': phoneNumber,
      'groupId': groupId,
      'city': city,
      'jobtitle': jobtitle,
      'JobCat': JobCat,
    };
  }

  factory ChatUserModel.fromMap(Map<String, dynamic> map) {
    return ChatUserModel(
      username: map['username'] ?? '',
      uid: map['uid'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      active: map['active'] ?? false,
      lastSeen: map['lastSeen'] ?? 0,
      phoneNumber: map['phoneNumber'] ?? '',
      groupId: List<String>.from(map['groupId']),
      city: map['city'] ?? '',
      jobtitle: map['jobtitle'] ?? '',
      JobCat: List<String>.from(map['JobCat']),
    );
  }
}