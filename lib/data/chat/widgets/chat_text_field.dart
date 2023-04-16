import 'dart:io';

import 'package:Aap_job/data/chat/chat_auth_repository.dart';
import 'package:Aap_job/data/chat/chat_repository.dart';
import 'package:Aap_job/data/enum/message_type.dart';
import 'package:Aap_job/models/ChatUserModel.dart';
import 'package:Aap_job/screens/image_picker_page.dart';
import 'package:Aap_job/screens/widget/custom_icon_button.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ChatTextField extends StatefulWidget {
  const ChatTextField({
    super.key,
    required this.receiverId,
    required this.scrollController,
  });

  final String receiverId;
  final ScrollController scrollController;

  @override
  _ChatTextFieldState createState() => new _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  late TextEditingController messageController;

  bool isMessageIconEnabled = false;
  double cardHeight = 0;
  final ImagePicker _picker = ImagePicker();

  void sendImageMessageFromGallery() async {
    final image = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ImagePickerPage(),
        ));

    if (image != null) {
      sendFileMessage(image, MessageType.image);
      setState(() => cardHeight = 0);
    }
  }

  void sendImageMessageFromCamera() async {
    final pickedFile = await _picker.getImage(
      source: ImageSource.camera,
    );
    if(pickedFile!=null) {
      final image= File(pickedFile.path);
      if (image != null) {
        sendFileMessage(image, MessageType.image);
        setState(() => cardHeight = 0);
      }
    }
  }

  void sendFileMessage(var file, MessageType messageType) async {
    Provider.of<ChatAuthRepository>(context, listen: false).getCurrentUserInfo().then((value) {
      Provider.of<ChatRepository>(context, listen: false).sendFileMessage(
        context: context,
        file: file,
        receiverId:widget.receiverId,
        messageType:messageType,
        senderData: value!,
      );
    } );
    await Future.delayed(const Duration(milliseconds: 500));
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      widget.scrollController.animateTo(
        widget.scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void sendTextMessage() async {
    if (isMessageIconEnabled) {
      Provider.of<ChatRepository>(context, listen: false).sendTextMessage(
        context: context,
        textMessage: messageController.text,
        receiverId: widget.receiverId,
        // senderData: value!,
      );
      
      messageController.clear();
    }

    await Future.delayed(const Duration(milliseconds: 100));
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      widget.scrollController.animateTo(
        widget.scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  iconWithText({
    required VoidCallback onPressed,
    required IconData icon,
    required String text,
    required Color background,
  }) {
    return Column(
      children: [
        CustomIconButton(
          onPressed: onPressed,
          icon: icon,
          background: background,
          minWidth: 50,
          iconColor: Colors.white,
          border: Border.all(
            color: greyColor!.withOpacity(.2),
            width: 1,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          text,
          style: TextStyle(
            color: Primary,
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    messageController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: cardHeight,
          width: double.maxFinite,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: receiverChatCardBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // iconWithText(
                      //   onPressed: () {},
                      //   icon: Icons.book,
                      //   text: 'File',
                      //   background: const Color(0xFF7F66FE),
                      // ),
                      iconWithText(
                        onPressed:sendImageMessageFromCamera,
                        icon: Icons.camera_alt,
                        text: 'Camera',
                        background: const Color(0xFFFE2E74),
                      ),
                      iconWithText(
                        onPressed: sendImageMessageFromGallery,
                        icon: Icons.photo,
                        text: 'Gallery',
                        background: const Color(0xFFC861F9),
                      ),
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     iconWithText(
                  //       onPressed: () {},
                  //       icon: Icons.headphones,
                  //       text: 'Audio',
                  //       background: const Color(0xFFF96533),
                  //     ),
                  //     iconWithText(
                  //       onPressed: () {},
                  //       icon: Icons.location_on,
                  //       text: 'Location',
                  //       background: const Color(0xFF1FA855),
                  //     ),
                  //     iconWithText(
                  //       onPressed: () {},
                  //       icon: Icons.person,
                  //       text: 'Contact',
                  //       background: const Color(0xFF009DE1),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: messageController,
                  maxLines: 4,
                  minLines: 1,
                  onChanged: (value) {
                    value.isEmpty
                        ? setState(() => isMessageIconEnabled = false)
                        : setState(() => isMessageIconEnabled = true);
                  },
                  decoration: InputDecoration(
                    hintText: 'Message',
                    hintStyle: TextStyle(color: greyColor),
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        style: BorderStyle.none,
                        width: 0,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    // prefixIcon: Material(
                    //   color: Colors.transparent,
                    //   child: CustomIconButton(
                    //     onPressed: () {},
                    //     icon: Icons.emoji_emotions_outlined,
                    //     iconColor: Theme.of(context).listTileTheme.iconColor,
                    //   ),
                    // ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RotatedBox(
                          quarterTurns: 45,
                          child: CustomIconButton(
                            onPressed: () => setState(
                              () => cardHeight == 0 ? cardHeight = 120 : cardHeight = 0,
                            ),
                            icon: cardHeight == 0 ? Icons.attach_file : Icons.close,
                            iconColor: Theme.of(context).listTileTheme.iconColor,
                          ),
                        ),
                        CustomIconButton(
                          onPressed: sendImageMessageFromCamera,
                          icon: Icons.camera_alt_outlined,
                          iconColor: Theme.of(context).listTileTheme.iconColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              CustomIconButton(
                onPressed: sendTextMessage,
                icon: isMessageIconEnabled ? Icons.send_outlined : Icons.mic_none_outlined,
                background: Colors.green,
                iconColor: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
