import 'dart:async';

import 'package:Aap_job/data/chat/chat_auth_repository.dart';

import 'package:Aap_job/localization/language_constrants.dart';
import 'package:Aap_job/models/common_functions.dart';
import 'package:Aap_job/screens/chat_home_page.dart';
import 'package:Aap_job/screens/widget/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:Aap_job/data/datasource/remote/dio/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:Aap_job/models/CitiesModel.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';


class InboxScreen extends StatefulWidget {
  InboxScreen({Key? key}) : super(key: key);
  @override
  _InboxScreenState createState() => new _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  late Timer timer;
  updateUserPresence() {
    Provider.of<ChatAuthRepository>(context, listen: false).updateUserPresence();
  }
  @override
  void initState() {
    updateUserPresence();
    timer = Timer.periodic(
      const Duration(minutes: 1),
          (timer) => setState(() {}),
    );
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
      SafeArea(
          child: Scaffold(
            appBar: new AppBar(
              backgroundColor: Primary,
              title: new Text("Inbox"),
              // actions: [CustomIconButton(onPressed: () {
              //   Navigator.push( context, MaterialPageRoute(builder: (context) => InboxScreen()));
              // }, icon: Icons.message),],
            ),
            body: ChatHomePage(),
    ));
  }
}
