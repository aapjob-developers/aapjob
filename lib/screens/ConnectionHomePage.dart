import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:ui';
import 'dart:math';
import 'package:Aap_job/data/chat/ContactsRepository.dart';
import 'package:Aap_job/localization/language_constrants.dart';
import 'package:Aap_job/models/ChatUserModel.dart';
import 'package:Aap_job/models/UserModel.dart';
import 'package:Aap_job/models/category.dart';
import 'package:Aap_job/screens/AppliedJobDetailScreen.dart';
import 'package:Aap_job/screens/FriendsSearchScreen.dart';
import 'package:Aap_job/screens/InboxScreen.dart';
import 'package:Aap_job/screens/JobAppliedCandidatesList.dart';
import 'package:Aap_job/screens/JobDetailScreen.dart';
import 'package:Aap_job/screens/NotificationScreen.dart';
import 'package:Aap_job/screens/basewidget/VideoPlayerScreen.dart';
import 'package:Aap_job/screens/chat_page.dart';
import 'package:Aap_job/screens/homepage.dart';
import 'package:Aap_job/screens/mainloginScreen.dart';
import 'package:Aap_job/screens/widget/contact_permission_dialog.dart';
import 'package:Aap_job/screens/widget/custom_icon_button.dart';
import 'package:Aap_job/view/basewidget/animated_custom_dialog.dart';
import 'package:Aap_job/widgets/contact_cards.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:intl/intl.dart';
import 'package:Aap_job/models/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:Aap_job/screens/basewidget/title_row.dart';
import 'package:Aap_job/screens/select_language.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:Aap_job/utill/dimensions.dart';

import 'package:Aap_job/screens/profile_exp.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:Aap_job/view/basewidget/textfield/custom_textfield.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:video_player/video_player.dart';
import 'package:Aap_job/providers/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:dio/dio.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_language_fonts/google_language_fonts.dart';

class ConnectionHomeScreen extends StatefulWidget {
  ConnectionHomeScreen({Key? key}) : super(key: key);
  @override
  _ConnectionHomeScreenState createState() => new _ConnectionHomeScreenState();
}

class _ConnectionHomeScreenState extends State<ConnectionHomeScreen> with WidgetsBindingObserver {
  static bool isGrant=false;

  late Future<void> _launched;
  openwhatsapp(phoneNumber) async {
    String textmsg="*Hi, I am using Aap job to find right job for me! it's a fast, simple, and secure app . Download Aap Job Now and Apply :* shorturl.at/afmVZ";
    var whatsappURl_android = "whatsapp://send?phone=$phoneNumber"+"&text="+textmsg;
    var whatappURL_ios = "https://wa.me/$phoneNumber?text=${Uri.parse("hello Sir")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text(getTranslated('whatsapp_no_installed', context)!+":")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text(getTranslated('whatsapp_no_installed', context)!+":")));
      }
    }
  }

  shareSmsLink(phoneNumber) async {
    Uri sms = Uri.parse(
      "sms:$phoneNumber?body=Hi, I am using Aap job to find right job for me! it's a fast, simple, and secure app . Get it at https://aapjob.com",
    );
    if (await launchUrl(sms)) {
    } else {}
  }
  @override
  initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
    init();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      check();
    }
  }

  void init() async {
    if(await FlutterContacts.requestPermission())
      {
        setState(() {
          isGrant=true;
        });
      }
  }
  void check() async {
    if(await Permission.contacts.status.isGranted)
    {
      setState(() {
        isGrant=true;
      });
    }

  }


  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery
        .of(context)
        .size;
    return 
      SafeArea(
        child: Scaffold(
          appBar: new AppBar(
            backgroundColor: Primary,
            title: new Text("Aap Friends"),
            actions: [CustomIconButton(onPressed: () {
              Navigator.push( context, MaterialPageRoute(builder: (context) => InboxScreen()));
            }, icon: Icons.message),],
          ),
        body:
        isGrant?
        Column(children: [
        // CustomAppBar(title: getTranslated('notification', context), isBackButtonExist: isBacButtonExist),
        Expanded(
        child:
        // Consumer<ContactsRepository>(
        //     builder: (context, contactsRespository, child) {
        //       List<List<ChatUserModel>> allContacts= contactsRespository.getAllContacts() as List<List<ChatUserModel>>;
        //
        //     })
        Consumer<ContactsRepository>(
          builder: (context, contactsRepo, _) {
            return FutureBuilder<List<List<ChatUserModel>>>(
              future: contactsRepo.getAllContacts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    width:MediaQuery.of(context).size.width,
                    height:MediaQuery.of(context).size.height,
                    child:Lottie.asset(
                      'assets/lottie/gps.json',
                      height: MediaQuery.of(context).size.width*0.1,
                      //width: MediaQuery.of(context).size.width*0.45,
                      animate: true,),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<ChatUserModel> firebaseContactsList = snapshot.data![0];
                  List<ChatUserModel> phoneContactsList = snapshot.data![1];
                  // Use the contacts here
                  return ListView.builder(
                    itemCount: firebaseContactsList.length + phoneContactsList.length,
                    itemBuilder: (context, index) {
                      ChatUserModel? firebaseContacts;
                      ChatUserModel? phoneContacts;

                      if (index < firebaseContactsList.length) {
                        firebaseContacts = firebaseContactsList[index];
                      } else {
                        phoneContacts = phoneContactsList[index - firebaseContactsList.length];
                      }
                      return index < firebaseContactsList.length
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == 0)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  child: Text(
                                    'Your Friends on Aap Job',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Primary,
                                      fontSize: 25
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ContactCard(
                            onTap: () {
                              Navigator.push( context, MaterialPageRoute(builder: (context) => ChatPage(user: firebaseContacts!)));
                            },
                            contactSource: firebaseContacts!,
                          ),
                        ],
                      )
                          : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == firebaseContactsList.length)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              child: Text(
                                'Invite Your friends to Aap job',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Primary,
                                  fontSize: 14
                                ),
                              ),
                            ),
                          ContactCard(
                            contactSource: phoneContacts!,
                            onTap: () =>
                                openwhatsapp(phoneContacts!.phoneNumber),
                             //   shareSmsLink(phoneContacts!.phoneNumber),
                          )
                        ],
                      );
                    },
                  );
                }
              },
            );
          },
        )
        ),
        ])
            :Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset('assets/lottie/hiring.json', height: 100, width: 100, fit: BoxFit.cover),
              SizedBox(height: 32),
              Text("Find Your Friends on Aap Job", style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              Text("Please Allow permission to access you contacts.", style: TextStyle(color: Primary), textAlign: TextAlign.center),
              SizedBox(height: 32),
              ElevatedButton(
                child: const Text('Allow Permission'),
                onPressed: () async {
                  if(await FlutterContacts.requestPermission())
                  {
                    setState(() {
                      isGrant=true;
                    });
                  }
                  else
                    {
                      if(await Permission.contacts.status.isDenied)
                        {
                          showAnimatedDialog(context, PermissionDialog(), isFlip: true);
                        }

                    }
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: new Size(deviceSize.width * 0.4,20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    primary: Colors.amber,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    textStyle:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),

    ),
      )
    ;
  }

  ListTile myListTile({
    required IconData leading,
    required String text,
    IconData? trailing,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.only(top: 10, left: 20, right: 10),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.green,
        child: Icon(
          leading,
          color: Colors.white,
        ),
      ),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        trailing,
        color: Colors.grey,
      ),
    );
  }
}

// class FriendTopbar extends StatefulWidget {
//   FriendTopbar({Key? key}) : super(key: key);
//   @override
//   _FriendTopbarState createState() => new _FriendTopbarState();
// }
// class _FriendTopbarState extends State<FriendTopbar> {
//   String? message, templist;
//   SharedPreferences? sharedPreff;
//
//   final Dio _dio = Dio();
//   final _baseUrl = AppConstants.BASE_URL;
//   var apidata;
//   @override
//   void initState() {
//     initializePreference().whenComplete((){
//     });
//     super.initState();
//   }
//
//   Future<void> initializePreference() async{
//     this.sharedPreff = await SharedPreferences.getInstance();
//   }
//
//   Stream<int> getnotificationcount() => Stream<int>.periodic(Duration(seconds: 1),(count)=>Provider.of<NotificationProvider>(context, listen: false).noti_count,);
//   @override
//   Widget build(BuildContext context) {
//     final  deviceSize= MediaQuery.of(context).size;
//     final TextStyle? textStyle = Theme
//         .of(context)
//         .textTheme
//         .caption;
//
//     return Container(
//       // decoration: new BoxDecoration(border: Border.all(color: Primary),),
//       width: deviceSize.width,
//       child:
//       Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         mainAxisSize: MainAxisSize.max,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             mainAxisSize: MainAxisSize.max,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               GestureDetector(
//                 onTap: (){
//                   Navigator.push(context,  MaterialPageRoute(builder: (context)=> ChangeLocationScreen(CurrentCity: Provider.of<AuthProvider>(context, listen: false).getJobCity(), CurrentLocation:Provider.of<AuthProvider>(context, listen: false).getJobLocation(),usertype: "candidate",)));
//                 },
//                 child: Container(
//                   padding: EdgeInsets.all(5.0),
//                   width: MediaQuery.of(context).size.width*0.20,
//                   child:
//                   Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       mainAxisSize: MainAxisSize.max,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children:[
//                         Lottie.asset(
//                           'assets/lottie/locatione.json',
//                           height: MediaQuery.of(context).size.width*0.15,
//                           width: MediaQuery.of(context).size.width*0.15,
//                           animate: true,),
//
//                         Column(
//                           children: [
//                             Text(Provider.of<AuthProvider>(context, listen: false).getJobLocation(),style:LatinFonts.aBeeZee(fontSize: 12),textAlign: TextAlign.center,),
//                             Text(Provider.of<AuthProvider>(context, listen: false).getJobCity(),style: LatinFonts.aBeeZee(fontSize: 10, fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
//                           ],
//                         ),
//
//                       ]
//                   ),
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.all(5.0),
//                 width: MediaQuery.of(context).size.width*0.25,
//                 child:
//                 Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.max,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children:[
//                       Text(getTranslated("WELCOME", context)!,style: LatinFonts.aBeeZee(fontSize:12),),
//                       Text(Provider.of<AuthProvider>(context, listen: false).getName(),style: LatinFonts.aBeeZee(fontSize:12,fontWeight: FontWeight.bold),),
//                     ]),
//
//
//               ),
//               Container(
//                 padding: EdgeInsets.all(5.0),
//                 width: MediaQuery.of(context).size.width*0.4,
//                 child:
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.max,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     GestureDetector(
//                       onTap: (){
//                         Navigator.push(context,  MaterialPageRoute(builder: (context)=> JobLiveDataScreen()));
//                       },
//                       child: Lottie.asset(
//                         'assets/lottie/liveprofile.json',
//                         height: MediaQuery.of(context).size.width*0.1,
//                         width: MediaQuery.of(context).size.width*0.1,
//                         animate: true,),
//                     ),
//
//                     SizedBox(width: MediaQuery.of(context).size.width*0.005,),
//                     // new Image.asset(
//                     //   'assets/images/map.png',
//                     //   fit:BoxFit.contain,
//                     //   width: MediaQuery.of(context).size.width*0.09,
//                     // ),
//                     GestureDetector(
//                       onTap: (){
//                         Navigator.push(context,  MaterialPageRoute(builder: (context)=> SupportScreen()));
//                       },
//                       child:
//                       Lottie.asset(
//                         'assets/lottie/support.json',
//                         height: MediaQuery.of(context).size.width*0.15,
//                         width: MediaQuery.of(context).size.width*0.15,
//                         animate: true,),
//                     ),
//                     SizedBox(width: MediaQuery.of(context).size.width*0.005,),
//                     StreamBuilder<int>(
//                         initialData: Provider.of<NotificationProvider>(context, listen: false).noti_count,
//                         stream: getnotificationcount(),
//                         builder: (context, snapshot) {
//                           if(snapshot.data!<Provider.of<AuthProvider>(context, listen: false).getCurrentNotificationCount()){
//                             Provider.of<AuthProvider>(context, listen: false).setCurrentNotificationCount(snapshot.data!);}
//                           return new Stack(
//                             children: <Widget>[
//                               GestureDetector(
//                                 onTap: (){
//                                   if(Provider.of<AuthProvider>(context, listen: false).setCurrentNotificationCount(snapshot.data!))
//                                     Navigator.push(context,  MaterialPageRoute(builder: (context)=>NotificationScreen(Userid: Provider.of<AuthProvider>(context, listen: false).getUserid())));
//                                 },
//                                 child:
//                                 Lottie.asset(
//                                   'assets/lottie/notification_bell.json',
//                                   height: MediaQuery.of(context).size.width*0.1,
//                                   width: MediaQuery.of(context).size.width*0.1,
//                                   animate: true,),
//                               ),
//                               snapshot.data == Provider.of<AuthProvider>(context, listen: false).getCurrentNotificationCount() ?
//                               new Container():
//                               new Positioned(
//                                 right: 5,
//                                 top: 5,
//                                 child: new Container(
//                                   padding: EdgeInsets.all(2),
//                                   decoration: new BoxDecoration(
//                                     color: Colors.red,
//                                     borderRadius: BorderRadius.circular(6),
//                                   ),
//                                   constraints: BoxConstraints(
//                                     minWidth: 10,
//                                     minHeight: 10,
//                                   ),
//                                   child: Text(
//                                     (snapshot.data!-Provider.of<AuthProvider>(context, listen: false).getCurrentNotificationCount()).toString(),
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 6,
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ),
//                               )
//                             ],
//                           );
//                         }
//                     ),
//
//                     // new Image.asset(
//                     //   'assets/images/map.png',
//                     //   fit:BoxFit.contain,
//                     //   width: MediaQuery.of(context).size.width*0.08,
//                     // ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Padding(
//             padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
//             child:
//             GestureDetector(
//               onTap: (){
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (builder) => SearchScreen()));
//               },
//               child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 padding: EdgeInsets.all(3),
//                 decoration: new BoxDecoration(color: Colors.white,border: Border.all(color:Primary,width: 2),borderRadius: BorderRadius.all(Radius.circular(5))),
//                 child:  Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.max,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Icon(Icons.search_rounded,color: Colors.black,),
//                       SizedBox(width: 5,),
//                       Text(getTranslated("SEARCH_BY_TITLE", context)!, style: TextStyle(fontSize: 12),)
//                     ]),
//               ),
//             ),
//             //BannersView(),
//           ),
//           Container(
//             height: 60.0,
//             decoration: BoxDecoration(color: Colors.blue.shade200),
//             child:
//             Consumer<CategoryProvider>(
//               builder: (context, categoryProvider, child) {
//                 return categoryProvider.categoryList.length != 0 ?
//                 ListView.separated(
//                   physics: BouncingScrollPhysics(),
//                   itemCount: categoryProvider.categoryList.length,
//                   padding: EdgeInsets.all(0),
//                   scrollDirection: Axis.horizontal,
//                   separatorBuilder: (context, index){
//                     return SizedBox(width: 10);
//                   },
//                   itemBuilder: (context, index) {
//                     Category category = categoryProvider.categoryList[index];
//                     print("cat--${category.name}");
//                     print("perma--${category.perma}");
//                     print("icon--${category.icon}");
//                     bool isSelected=category.selected;
//                     return
//                       GestureDetector(
//                           onTap: (){
//                             //   if(categoryProvider.TotalSelectedIndex<=5) {
//                             adcategory(category.id.toString(),category.perma.toString());
//
//                             print("Totalin->"+categoryProvider.TotalSelectedIndex.toString());
//                             categoryProvider.TotalSelectedIndex=categoryProvider.TotalSelectedIndex+1;
//                             Provider.of<CategoryProvider>(
//                                 context, listen: false)
//                                 .changeSelectedIndexColor(
//                                 index, category.selected, category);
//                             // }
//                           },
//                           child:Chip(
//                             ///backgroundColor: isSelected? Colors.primaries[Random().nextInt(Colors.primaries.length)]:Colors.white,
//                               backgroundColor: category.mycolor,
//                               // avatar: CircleAvatar( radius: 50,
//                               //   backgroundImage: NetworkImage('${AppConstants.BASE_URL}/${category.icon}',scale:.8), //NetworkImage
//                               // ), //CircleAvatar
//                               // label:
//                               //  Text(" "+category.name,style:LatinFonts.lato(fontStyle: FontStyle.italic,color: Colors.black,fontWeight: FontWeight.bold),),
//
//
//                               label:          Row(
//                                 children: [
//                                   // FadeInImage.assetNetwork(
//                                   //   width: 40,
//                                   //   height: 40,
//                                   //   placeholder: 'assets/images/appicon.png',
//                                   //   image: '${AppConstants.BASE_URL}/${category.icon}',
//                                   //   fit: BoxFit.contain,
//                                   // ),
//                                   CircleAvatar( radius: 15,
//                                     backgroundImage: NetworkImage('${AppConstants.BASE_URL}/${category.icon}',scale:.8), //NetworkImage
//                                   ),
//                                   Text(" "+category.name!,style:LatinFonts.lato(fontStyle: FontStyle.italic,color: Colors.black,fontWeight: FontWeight.bold),),
//                                 ],
//                               )
//                           )
//                       )
//                     ;
//
//                     //   HCategoryItem(
//                     //   title: _category.name,
//                     //   isSelected: categoryProvider.categorySelectedIndex == index,
//                     //   id: _category.id,
//                     //
//                     // );
//                   },
//                 )
//                     : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
//               },
//             ),
//
//           ),
//         ],
//       ),
//     );
//   }
//
// }


