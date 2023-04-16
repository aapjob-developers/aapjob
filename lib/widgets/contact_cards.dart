import 'package:Aap_job/models/ChatUserModel.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class ContactCard extends StatelessWidget {
  const ContactCard({
    Key? key,
    required this.contactSource,
    required this.onTap,
  }) : super(key: key);

  final ChatUserModel contactSource;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.only(
        left: 20,
        right: 10,
      ),
      leading: CircleAvatar(
        backgroundColor: Primary,
        radius: 20,
        backgroundImage: contactSource.profileImageUrl.isNotEmpty
            ? CachedNetworkImageProvider(AppConstants.BASE_URL+contactSource.profileImageUrl)
            : null,
        child: contactSource.profileImageUrl.isEmpty
            ? const Icon(
          Icons.person,
          size: 30,
          color: Colors.white,
        )
            : null,
      ),
      title: Text(
        contactSource.username,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: contactSource.uid.isNotEmpty
          ? Text(
        "Hey there! I'm using Aap Job",
        style: TextStyle(
          color: Primary,
          fontWeight: FontWeight.w600,
        ),
      )
          : null,
      trailing: contactSource.uid.isEmpty
          ? TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          backgroundColor: Colors.amberAccent,
        ),
        child: const Text('INVITE',style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),),
      )
          : null,
    );
  }
}
