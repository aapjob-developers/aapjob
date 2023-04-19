import 'package:Aap_job/data/chat/chat_repository.dart';
import 'package:Aap_job/models/ChatUserModel.dart';
import 'package:Aap_job/models/last_message_model.dart';
import 'package:Aap_job/screens/JobLiveDataScreen.dart';
import 'package:Aap_job/screens/chat_page.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatHomePage extends StatelessWidget {
  const ChatHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ChatRepository>(
        builder: (context, ChatProvider, _) {
          return StreamBuilder<List<LastMessageModel>>(
            stream: ChatProvider.getAllLastMessageList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final lastMessageData = snapshot.data![index];
                    return ListTile(
                      onTap: () {
                        Navigator.push( context, MaterialPageRoute(builder: (context) => ChatPage(user:
                          ChatUserModel(
                            username: lastMessageData.username,
                            uid: lastMessageData.contactId,
                            profileImageUrl: lastMessageData.profileImageUrl,
                            active: true,
                            lastSeen: 0,
                            phoneNumber: '0',
                            groupId: [],
                            city: "",
                            jobtitle: "",
                            JobCat: []
                          ),
                        )));
                      },
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(lastMessageData.username),
                          Text(
                            DateFormat.Hm().format(lastMessageData.timeSent),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          lastMessageData.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          AppConstants.BASE_URL+lastMessageData.profileImageUrl,
                        ),
                        radius: 24,
                      ),
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
