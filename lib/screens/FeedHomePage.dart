
import 'dart:convert';
import 'dart:ui';
import 'dart:io';
import 'dart:math';
import 'package:Aap_job/models/GroupModel.dart';
import 'package:Aap_job/utill/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:Aap_job/utill/colors.dart';
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
          centerTitle: true,
          elevation: 0.5,
          backgroundColor: Primary,
          title: Text("Aap Groups")
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
      // SingleChildScrollView(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.start,
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Center(child:Container(
      //         padding: EdgeInsets.only(top: 10,right: 10,left: 10,bottom: 10),
      //         width: MediaQuery.of(context).size.width,
      //         child:
      //         ListView.separated(
      //           shrinkWrap: true,
      //           itemCount: duplicateGroupModel.length,
      //           separatorBuilder: (context, index){
      //             return Divider(height: 1,);
      //           },
      //           itemBuilder: (context, index) {
      //             return
      //               GestureDetector(
      //                 onTap:(){
      //                   joingroup(duplicateGroupModel[index].link);
      //                 } ,
      //                 child: Container(
      //                   width: MediaQuery.of(context).size.width*0.9,
      //                   decoration: new BoxDecoration(
      //                       boxShadow: [new BoxShadow(
      //                         color: Color.fromRGBO(00, 132, 122, 1.0),
      //                         blurRadius: 5.0,
      //                       ),],
      //                       color:Colors.white,
      //                       //Color.fromRGBO(00, 132, 122, 1.0),
      //                       borderRadius: BorderRadius.all(Radius.circular(5.0))),
      //                   margin: EdgeInsets.all(5),
      //                   padding: EdgeInsets.all(5),
      //                   child:
      //                   Row(
      //                     children: [
      //                       Container(
      //                         height: MediaQuery.of(context).size.width*0.2,
      //                         width: MediaQuery.of(context).size.width*0.2,
      //                         padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
      //                         decoration: BoxDecoration(
      //                           color: Color(0xFFF9F9F9),
      //                           borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
      //                         ),
      //                         child:
      //                         FadeInImage.assetNetwork(
      //                           placeholder: 'assets/images/appicon.png',
      //                           image: '${AppConstants.BASE_URL}/${duplicateGroupModel[index].iconSrc}',
      //                           fit: BoxFit.contain,
      //                         ),
      //                       ),
      //                       SizedBox(width: 10,),
      //                       Container(
      //                         width: MediaQuery.of(context).size.width*0.6,
      //                         child:Text(duplicateGroupModel[index].name ?? '', style: LatinFonts.aBeeZee(fontSize: 16,fontWeight: FontWeight.bold), maxLines: 3, overflow: TextOverflow.ellipsis),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               );
      //           },
      //         ),
      //       ),)
      //     ],
      //   ),
      // ),
    );
  }
}