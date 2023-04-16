import 'dart:math';

import 'package:Aap_job/data/chat/chat_auth_repository.dart';
import 'package:Aap_job/data/chat/chat_repository.dart';
import 'package:Aap_job/data/chat/widgets/chat_text_field.dart';
import 'package:Aap_job/data/chat/widgets/message_card.dart';
import 'package:Aap_job/data/chat/widgets/show_date_card.dart';
import 'package:Aap_job/data/chat/widgets/yellow_card.dart';
import 'package:Aap_job/helper/last_seen_message.dart';
import 'package:Aap_job/models/ChatUserModel.dart';
import 'package:Aap_job/models/message_model.dart';
import 'package:Aap_job/screens/widget/custom_icon_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
final pageStorageBucket = PageStorageBucket();

class ChatPage extends StatelessWidget {
  ChatPage({super.key, required this.user});

  final ChatUserModel user;
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return
      SafeArea(child:
      Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          borderRadius: BorderRadius.circular(20),
          child: Row(
            children: [
              const Icon(Icons.arrow_back),
              Hero(
                tag: 'profile',
                child: Container(
                  width: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(user.profileImageUrl),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        title: InkWell(
          onTap: () {
            // Navigator.pushNamed(
            //   context,
            //   Routes.profile,
            //   arguments: user,
            // );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.username,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 3),
                StreamBuilder(
                  stream: Provider.of<ChatAuthRepository>(context, listen: false).getUserPresenceStatus(uid: user.uid),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState != ConnectionState.active) {
                      return const SizedBox();
                    }
                    final singleUserModel = snapshot.data!;
                    final lastMessage = lastSeenMessage(singleUserModel.lastSeen);
                    return Text(
                      singleUserModel.active ? 'online' : "last seen $lastMessage ago",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        // actions: [
        //   CustomIconButton(
        //     onPressed: () {},
        //     icon: Icons.video_call,
        //     iconColor: Colors.white,
        //   ),
        //   CustomIconButton(
        //     onPressed: () {},
        //     icon: Icons.call,
        //     iconColor: Colors.white,
        //   ),
        //   CustomIconButton(
        //     onPressed: () {},
        //     icon: Icons.more_vert,
        //     iconColor: Colors.white,
        //   ),
        // ],
      ),
      body: Stack(
        children: [
          // Stream of Chat
          Container(
            height: double.maxFinite,
            width: double.maxFinite,
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child:
            Consumer<ChatRepository>(
        builder: (context, ChatRepo, _) {
      return StreamBuilder<List<MessageModel>>(
          stream: ChatRepo.getAllOneToOneMessage(user.uid),
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.active) {
        return ListView.builder(
          itemCount: 15,
          itemBuilder: (_, index) {
            final random = Random().nextInt(14);
            return Container(
              alignment: random.isEven ? Alignment.centerRight : Alignment.centerLeft,
              margin: EdgeInsets.only(
                top: 5,
                bottom: 5,
                left: random.isEven ? 150 : 15,
                right: random.isEven ? 15 : 150,
              ),
              child: ClipPath(
                clipper: UpperNipMessageClipperTwo(
                  random.isEven ? MessageType.send : MessageType.receive,
                  nipWidth: 8,
                  nipHeight: 10,
                  bubbleRadius: 12,
                ),
                child: Shimmer.fromColors(
                  baseColor: random.isEven
                      ? Colors.grey.withOpacity(.3)
                      : Colors.grey.withOpacity(.2),
                  highlightColor: random.isEven
                      ? Colors.grey.withOpacity(.4)
                      : Colors.grey.withOpacity(.3),
                  child: Container(
                    height: 40,
                    width: 170 +
                        double.parse(
                          (random * 2).toString(),
                        ),
                    color: Colors.red,
                  ),
                ),
              ),
            );
          },
        );
      }
      return PageStorage(
        bucket: pageStorageBucket,
        child: ListView.builder(
          key: const PageStorageKey('chat_page_list'),
          itemCount: snapshot.data!.length,
          shrinkWrap: true,
          controller: scrollController,
          itemBuilder: (_, index) {
            final message = snapshot.data![index];
            final isSender = message.senderId == FirebaseAuth.instance.currentUser!.uid;

            final haveNip = (index == 0) ||
                (index == snapshot.data!.length - 1 &&
                    message.senderId != snapshot.data![index - 1].senderId) ||
                (message.senderId != snapshot.data![index - 1].senderId &&
                    message.senderId == snapshot.data![index + 1].senderId) ||
                (message.senderId != snapshot.data![index - 1].senderId &&
                    message.senderId != snapshot.data![index + 1].senderId);
            final isShowDateCard = (index == 0) ||
                ((index == snapshot.data!.length - 1) &&
                    (message.timeSent.day > snapshot.data![index - 1].timeSent.day)) ||
                (message.timeSent.day > snapshot.data![index - 1].timeSent.day &&
                    message.timeSent.day <= snapshot.data![index + 1].timeSent.day);

            return Column(
              children: [
                if (index == 0) const YellowCard(),
                if (isShowDateCard) ShowDateCard(date: message.timeSent),
                MessageCard(
                  isSender: isSender,
                  haveNip: haveNip,
                  message: message,
                ),
              ],
            );
          },
        ),
      );
    });}),

          ),
          Container(
            alignment: const Alignment(0, 1),
            child: ChatTextField(
              receiverId: user.uid,
              scrollController: scrollController,
            ),
          ),
        ],
      ),
    ));
  }
}
