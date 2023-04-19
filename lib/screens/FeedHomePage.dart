
import 'dart:convert';
import 'dart:ui';
import 'dart:io';
import 'dart:math';
import 'package:Aap_job/data/chat/chat_repository.dart';
import 'package:Aap_job/models/GroupModel.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:Aap_job/providers/notification_provider.dart';
import 'package:Aap_job/screens/InboxScreen.dart';
import 'package:Aap_job/screens/notification/notification_screen.dart';
import 'package:Aap_job/screens/widget/ChangeLocationScreen.dart';
import 'package:Aap_job/utill/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:dio/dio.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:dio/dio.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedHomeScreen extends StatefulWidget {
  FeedHomeScreen({Key? key}) : super(key: key);
  @override
  _FeedHomeScreenState createState() => new _FeedHomeScreenState();
}

class _FeedHomeScreenState extends State<FeedHomeScreen> {

  final Dio _dio = Dio();
  final _baseUrl = AppConstants.BASE_URL;
  var apidata;
  int userid=0;
  SharedPreferences? sharedPreferences;
  String Name="";

  @override
  initState() {
    initializePreference().whenComplete((){
      setState(() {
        userid= sharedPreferences!.getInt("userid")?? 0;
        Name= sharedPreferences!.getString("HrName")?? "HrName";
      });
      // getHrCurrentPlan();
      getmygroup();
    });

    super.initState();
  }

  Future<void> initializePreference() async{
    this.sharedPreferences = await SharedPreferences.getInstance();
  }
  bool _hasGroupModel=false;
  List<GroupModel> duplicateGroupModel = <GroupModel>[];

  getmygroup() async {
    duplicateGroupModel.clear();
    try {
      Response response = await _dio.get(_baseUrl + "api/mygroups?userid="+userid.toString());
      apidata = response.data;
      print('duplicateGroupModelList : ${apidata}');
      List<dynamic> data=json.decode(apidata);
      if(data.toString()=="[]")
      {
        duplicateGroupModel=[];
        setState(() {
          _hasGroupModel = false;
        });
      }
      else
      {
        data.forEach((jobs) =>
            duplicateGroupModel.add(GroupModel.fromJson(jobs)));
        setState(() {
          _hasGroupModel=true;
        });
      }
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(e.message);
      }
    }

  }

  joingroup(String Link) async {
    if(await canLaunch(Link)){
      await launch(Link);
    }else {
      throw 'Could not launch $Link';
    }
  }
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: deviceSize.height*0.15,
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(color: Colors.black),
        title:
        Column(
          children: [
            Topbar(),
          ],
        ),

      ),
      body:
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: duplicateGroupModel.length,
          separatorBuilder: (context, index){
            return Divider(height: 1,);
          },
          itemBuilder: (context, index) {
            return
              GestureDetector(
                onTap:(){
                  joingroup(duplicateGroupModel[index].link);
                } ,
                child: Container(
                  width: MediaQuery.of(context).size.width*0.9,
                  decoration: new BoxDecoration(
                      boxShadow: [new BoxShadow(
                        color: Color.fromRGBO(00, 132, 122, 1.0),
                        blurRadius: 5.0,
                      ),],
                      color:Colors.white,
                      //Color.fromRGBO(00, 132, 122, 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(5),
                  child:
                  Row(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.width*0.2,
                        width: MediaQuery.of(context).size.width*0.2,
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        decoration: BoxDecoration(
                          color: Color(0xFFF9F9F9),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                        ),
                        child:
                        FadeInImage.assetNetwork(
                          placeholder: 'assets/images/appicon.png',
                          image: '${AppConstants.BASE_URL}/${duplicateGroupModel[index].iconSrc}',
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(width: 10,),
                      Container(
                        width: MediaQuery.of(context).size.width*0.6,
                        child:Text(duplicateGroupModel[index].name ?? '', style: LatinFonts.aBeeZee(fontSize: 16,fontWeight: FontWeight.bold), maxLines: 3, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
              );
          },
        ),
      ),
    );
  }
}
class Topbar extends StatefulWidget {
  Topbar({Key? key}) : super(key: key);
  @override
  _TopbarState createState() => new _TopbarState();
}
class _TopbarState extends State<Topbar> {
  String? Joblist, templist;
  SharedPreferences? sharedPreff;

  final Dio _dio = Dio();
  final _baseUrl = AppConstants.BASE_URL;
  var apidata;
  @override
  void initState() {
    initializePreference().whenComplete((){
    });
    super.initState();
  }

  Future<void> initializePreference() async{
    this.sharedPreff = await SharedPreferences.getInstance();
  }

  Stream<int> getnotificationcount() => Stream<int>.periodic(Duration(seconds: 1),(count)=>Provider.of<NotificationProvider>(context, listen: false).noti_count,);
  @override
  Widget build(BuildContext context) {
    final  deviceSize= MediaQuery.of(context).size;
    final TextStyle? textStyle = Theme
        .of(context)
        .textTheme
        .caption;
    return Container(
      // decoration: new BoxDecoration(border: Border.all(color: Primary),),
      width: deviceSize.width,
      child:
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.push(context,  MaterialPageRoute(builder: (context)=> ChangeLocationScreen(CurrentCity: Provider.of<AuthProvider>(context, listen: false).getJobCity(), CurrentLocation:Provider.of<AuthProvider>(context, listen: false).getJobLocation(),usertype: "candidate",)));
                },
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  width: MediaQuery.of(context).size.width*0.20,
                  child:
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:[
                        Lottie.asset(
                          'assets/lottie/locatione.json',
                          height: MediaQuery.of(context).size.width*0.15,
                          width: MediaQuery.of(context).size.width*0.15,
                          animate: true,),

                        Column(
                          children: [
                            Text(Provider.of<AuthProvider>(context, listen: false).getJobLocation(),style:LatinFonts.aBeeZee(fontSize: 12),textAlign: TextAlign.center,),
                            Text(Provider.of<AuthProvider>(context, listen: false).getJobCity(),style: LatinFonts.aBeeZee(fontSize: 10, fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
                          ],
                        ),

                      ]
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(5.0),
                width: MediaQuery.of(context).size.width*0.4,
                child:
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                      Text("Aap Groups",style: LatinFonts.aBeeZee(fontSize:MediaQuery.of(context).size.width*0.06, fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
                      //Text(Provider.of<AuthProvider>(context, listen: false).getName(),style: LatinFonts.aBeeZee(fontSize:12,fontWeight: FontWeight.bold),),
                    ]),
              ),
              Container(
                padding: EdgeInsets.all(5.0),
                width: MediaQuery.of(context).size.width * 0.3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.005,
                    ),
                    StreamBuilder<int>(
                        initialData: Provider.of<NotificationProvider>(context,
                            listen: false)
                            .noti_count,
                        stream: getnotificationcount(),
                        builder: (context, snapshot) {
                          if (snapshot.data! <
                              Provider.of<AuthProvider>(context, listen: false)
                                  .getCurrentNotificationCount()) {
                            Provider.of<AuthProvider>(context, listen: false)
                                .setCurrentNotificationCount(snapshot.data!);
                          }
                          return new Stack(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  if (Provider.of<AuthProvider>(context,
                                      listen: false)
                                      .setCurrentNotificationCount(
                                      snapshot.data!))
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NotificationScreen(
                                                    Userid: Provider.of<
                                                        AuthProvider>(
                                                        context,
                                                        listen: false)
                                                        .getUserid())));
                                },
                                child: Lottie.asset(
                                  'assets/lottie/notification_bell.json',
                                  height:
                                  MediaQuery.of(context).size.width * 0.1,
                                  width:
                                  MediaQuery.of(context).size.width * 0.1,
                                  animate: true,
                                ),
                              ),
                              snapshot.data ==
                                  Provider.of<AuthProvider>(context,
                                      listen: false)
                                      .getCurrentNotificationCount()
                                  ? new Container()
                                  : new Positioned(
                                right: 5,
                                top: 5,
                                child: new Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: new BoxDecoration(
                                    color: Colors.red,
                                    borderRadius:
                                    BorderRadius.circular(6),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 10,
                                    minHeight: 10,
                                  ),
                                  child: Text(
                                    (snapshot.data! -
                                        Provider.of<AuthProvider>(
                                            context,
                                            listen: false)
                                            .getCurrentNotificationCount())
                                        .toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 6,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            ],
                          );
                        }),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.005,
                    ),
                    Consumer<ChatRepository>(
                        builder: (context, ChatRepo, _) {
                          return StreamBuilder<int>(
                              stream: ChatRepo.getAllUnseenMessage(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState != ConnectionState.active) {

                                }
                                return new Stack(
                                  children: <Widget>[
                                    GestureDetector(
                                        onTap: () {
                                          if (Provider.of<AuthProvider>(context,
                                              listen: false)
                                              .setCurrentNotificationCount(
                                              snapshot.data!))
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        InboxScreen()));
                                        },
                                        child: Image.asset(
                                          'assets/images/msg.png',
                                          height:
                                          MediaQuery.of(context).size.width * 0.1,
                                          width:
                                          MediaQuery.of(context).size.width * 0.1,
                                        )
                                      // Lottie.asset(
                                      //   'assets/lottie/notification_bell.json',
                                      //   height:
                                      //       MediaQuery.of(context).size.width * 0.1,
                                      //   width:
                                      //       MediaQuery.of(context).size.width * 0.1,
                                      //   animate: true,
                                      // ),
                                    ),
                                    snapshot.data ==0 ? new Container()
                                        : new Positioned(
                                      right: 5,
                                      top: 5,
                                      child: new Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: new BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                          BorderRadius.circular(6),
                                        ),
                                        constraints: BoxConstraints(
                                          minWidth: 10,
                                          minHeight: 10,
                                        ),
                                        child: Text(
                                          snapshot.data.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 6,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              });}),

                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
