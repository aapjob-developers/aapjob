import 'package:Aap_job/localization/language_constrants.dart';
import 'package:Aap_job/providers/content_provider.dart';
import 'package:Aap_job/screens/EditCompanyProfile.dart';
import 'package:Aap_job/screens/EditProfileDetails.dart';
import 'package:Aap_job/screens/EditProfileImage.dart';
import 'package:Aap_job/screens/MyClosedJobs.dart';
import 'package:Aap_job/screens/ShareAppScreen.dart';
import 'package:Aap_job/screens/select_language.dart';
import 'package:Aap_job/screens/widget/ChangeLocationScreen.dart';
import 'package:Aap_job/screens/widget/VideoPopup.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Aap_job/providers/profile_provider.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:Aap_job/screens/widget/sign_out_confirmation_dialog.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:Aap_job/view/basewidget/animated_custom_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'EditProfileVideo.dart';
import 'package:lottie/lottie.dart';
import 'package:google_language_fonts/google_language_fonts.dart';

class HrProfileHomeScreen extends StatefulWidget {
  HrProfileHomeScreen({Key? key}) : super(key: key);
  @override
  _HrProfileHomeScreenState createState() => new _HrProfileHomeScreenState();
}

class _HrProfileHomeScreenState extends State<HrProfileHomeScreen> {
  SharedPreferences? sharedPreferences;
  String jobtitle="Fresher";
  var apidata;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.5,
          backgroundColor: Primary,
          title: Text("HR  Account")
      ),
      body:SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            new Container(
              width: deviceSize.width-3,
              padding: const EdgeInsets.all(5.0),
              decoration: new BoxDecoration(boxShadow: [new BoxShadow(
                color: Primary,
                blurRadius: 5.0,
              ),],color: Primary,),
              child:
              Column(
                children: [
                  imageProfile(),
                  SizedBox(height: 2,),
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap:(){
                            VideoPopup(title:Provider.of<ContentProvider>(context, listen: false).contentList[1].internalVideoSrc!).show(context);

                          },
                          child:
                            CachedNetworkImage(
                              imageUrl: AppConstants.BASE_URL+Provider.of<ContentProvider>(context, listen: false).contentList[1].imgSrc!,
                                width: MediaQuery.of(context).size.width*0.9,
                                height: MediaQuery.of(context).size.width*0.2,
                              placeholder: (context, url) => Image.asset('assets/images/no_data.png'),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          // FadeInImage.assetNetwork(
                          //   width: MediaQuery.of(context).size.width*0.9,
                          //   height: MediaQuery.of(context).size.width*0.2,
                          //   placeholder: 'assets/images/no_data.png',
                          //   image:AppConstants.BASE_URL+Provider.of<ContentProvider>(context, listen: false).resumecontentModel.imgSrc,
                          //   fit: BoxFit.contain,
                          // ),
                        )
                      ]),
                  new Container(
                    width: deviceSize.width*0.9,
                    padding: const EdgeInsets.all(5.0),
                    margin: EdgeInsets.only(left: 10.0,top: 5.0,right: 10.0,bottom: 5.0),
                    decoration: new BoxDecoration(boxShadow: [new BoxShadow(
                      color: Colors.white,
                      blurRadius: 5.0,
                    ),], gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.purple.shade900,
                          Primary,
                        ]),
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child:
                    new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Container( width: deviceSize.width*0.8,
                            padding: EdgeInsets.all(2),
                            child: new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(Provider.of<AuthProvider>(context, listen: false).getHrName(),style: LatinFonts.aclonica(color:Colors.white,fontSize: deviceSize.width*0.06 ),),
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (builder) => EditProfileDetails()));
                                          },
                                          child:
                                          Icon(Icons.mode_edit,size:deviceSize.width*0.06,color: Colors.white,),
                                        ),
                                      ]
                                  ),
                                  SizedBox(height: deviceSize.width*0.01,),
                                  new Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(Icons.account_balance_outlined,size:deviceSize.width*0.05,color: Colors.white,),
                                        SizedBox(width:deviceSize.width*0.04,),
                                        new Container(
                                            width: deviceSize.width*0.7-10,
                                            child:
                                            Text("Recruiting for ${Provider.of<AuthProvider>(context, listen: false).getHrCompanyName()}" ,style: LatinFonts.lato(color:Colors.white,fontSize: deviceSize.width*0.04 ),)
                                        ),
                                      ]
                                  ),
                                  SizedBox(height:deviceSize.width*0.02,),
                                  new Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(Icons.email,size: deviceSize.width*0.05,color: Colors.white,),
                                        SizedBox(width:deviceSize.width*0.04,),
                                        new Container(
                                            width: deviceSize.width*0.7-10,
                                            child:
                                            Text(Provider.of<AuthProvider>(context, listen: false).getEmail() ,style: LatinFonts.lato(color:Colors.white,fontSize: deviceSize.width*0.04 ),)
                                        ),
                                      ]
                                  ),
                                  SizedBox(height:deviceSize.width*0.02,),
                                  new Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(Icons.phone_android_rounded,size:deviceSize.width*0.04,color: Colors.white,),
                                        SizedBox(width:deviceSize.width*0.04,),
                                        new Container(
                                            width: deviceSize.width*0.7-10,
                                            child:
                                            Text(Provider.of<AuthProvider>(context, listen: false).getMobile() ,style: LatinFonts.lato(color:Colors.white,fontSize: deviceSize.width*0.04 ),)
                                        ),
                                      ]
                                  ),
                                  SizedBox(height:deviceSize.width*0.02,),
                                  Container(
                                    child: Divider(color: Colors.white,thickness: 2,),
                                  ),

                                  new Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Column(children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Icon(Icons.pin_drop_rounded,size: deviceSize.width*0.06, color: Colors.yellow,),
                                              SizedBox(width:deviceSize.width*0.03,),
                                              new Container(
                                                width: deviceSize.width*0.4-10,
                                                child:
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.max,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(Provider.of<AuthProvider>(context, listen: false).getHrLocality(),style: LatinFonts.lato(color:Colors.white,fontSize: deviceSize.width*0.025 ),),
                                                    Text(Provider.of<AuthProvider>(context, listen: false).getHrCity(),style: LatinFonts.lato(color:Colors.white,fontSize: deviceSize.width*0.04 ),)
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        ],),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context,  MaterialPageRoute(builder: (context)=> ChangeLocationScreen(CurrentCity: Provider.of<AuthProvider>(context, listen: false).getHrCity(), CurrentLocation: Provider.of<AuthProvider>(context, listen: false).getHrLocality(),usertype: "HR")));
                              },
                              child:
                              Icon(Icons.mode_edit,size:deviceSize.width*0.06,color: Colors.white,),
                            ),


                                      ]
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Divider(color: Colors.white,thickness: 2,),
                                  ),
                                  Provider.of<ProfileProvider>(context, listen: false).getProfileString()==""||Provider.of<ProfileProvider>(context, listen: false).getProfileString()=="no video"||Provider.of<ProfileProvider>(context, listen: false).getProfileString()==null
                                      ?
                                  GestureDetector(
                                      onTap: (){
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (builder) => EditProfileVideo(path: "", usertype:"HR")));
                                      },
                                      child:
                                      new Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Column(children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Icon(Icons.video_camera_back_rounded,size: 20, color: Colors.yellow,),
                                                  SizedBox(width: 10,),
                                                  new Container(
                                                      width: deviceSize.width*0.6-10,
                                                      child:
                                                      Text(getTranslated("ADD_YOUR_VIDEO_RESUME", context)!,style: LatinFonts.lato(color:Colors.white,fontSize: 14 ),)
                                                  ),
                                                ],
                                              )
                                            ],),
                                            Icon(Icons.add,size: 25,color: Colors.white,),
                                          ]
                                      )
                                  )
                                      :
                                  new Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Column(children: [
                                          GestureDetector(
                                            onTap: (){
                                              VideoPopup(
                                                  title: Provider.of<ProfileProvider>(context, listen: false).getProfileString()
                                              ).show(context);
                                            },
                                            child:
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Icon(Icons.video_camera_back_rounded,size: 20, color: Colors.yellow,),
                                                SizedBox(width: 10,),
                                                new Container(
                                                    width: deviceSize.width*0.6-10,
                                                    child:
                                                    Text(getTranslated("CLICK_TO_VIEW_VIDEO_RESUME", context)!,style: LatinFonts.lato(color:Colors.white,fontSize: 14),
                                                    )
                                                ),
                                                Icon(Icons.play_circle,size: 20, color: Colors.yellow,),
                                              ],
                                            )
                                          ),

                                        ],),

                                        GestureDetector(
                                          onTap: (){
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (builder) => EditProfileVideo(path: "", usertype:"HR")));
                                          },
                                          child:
                                          Icon(Icons.mode_edit,size: 25,color: Colors.white,),
                                        ),


                                      ]
                                  ),
                                ]
                            ),
                          ),
                        ]
                    ),

                  ),
                ],
              ),


            ),
            Divider(
              thickness: 1.2,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => EditCompanyProfile()));
              },
              child:
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(getTranslated('EDIT_COMPANY_DETAILS', context)!,style: LatinFonts.aBeeZee(fontSize: 14,fontWeight: FontWeight.bold, color: Color.fromARGB(255,39, 170, 225))),
                      Lottie.asset(
                        'assets/lottie/arrowright.json',
                        height: MediaQuery.of(context).size.width*0.08,
                        width: MediaQuery.of(context).size.width*0.08,
                        animate: true,),
                    ]

                ),
              ),
            ),
            Divider(
              thickness: 1.2,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => MyClosedJobs()));
              },
              child:
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(getTranslated('MY_CLOSED_JOBS', context)!,style: LatinFonts.aBeeZee(fontSize: 14,fontWeight: FontWeight.bold, color: Color.fromARGB(255,39, 170, 225))),
                      Lottie.asset(
                        'assets/lottie/arrowright.json',
                        height: MediaQuery.of(context).size.width*0.08,
                        width: MediaQuery.of(context).size.width*0.08,
                        animate: true,),
                    ]

                ),
              ),
            ),
            Divider(
              thickness: 1.2,
            ),
            InkWell(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (builder) => MyAppliedJobs()));
              },
              child:
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(getTranslated('MY_BILLING', context)!,style: LatinFonts.aBeeZee(fontSize: 14,fontWeight: FontWeight.bold,color: Color.fromARGB(255,39, 170, 225))),
                      Lottie.asset(
                        'assets/lottie/arrowright.json',
                        height: MediaQuery.of(context).size.width*0.08,
                        width: MediaQuery.of(context).size.width*0.08,
                        animate: true,),
                    ]

                ),
              ),
            ),
            Divider(
              thickness: 1.2,
            ),
            InkWell(
              onTap: () {
                Navigator.push( context,  MaterialPageRoute(builder: (context) => SelectLanguage(isHome: true)));
              },
              child:
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(getTranslated('CHANGE_LANGUAGE', context)!,style: LatinFonts.aBeeZee(fontSize: 14,fontWeight: FontWeight.bold,color: Color.fromARGB(255,39, 170, 225))),
                      Lottie.asset(
                        'assets/lottie/arrowright.json',
                        height: MediaQuery.of(context).size.width*0.08,
                        width: MediaQuery.of(context).size.width*0.08,
                        animate: true,),
                    ]

                ),
              ),
            ),
            Divider(
              thickness: 1.2,
            ),
            InkWell(
              onTap: () {
                Navigator.push( context,  MaterialPageRoute(builder: (context) => ShareAppScreen()));
              },
              child:
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(getTranslated('Rate_and_Share', context)!,style: LatinFonts.aBeeZee(fontSize: 14,fontWeight: FontWeight.bold,color: Color.fromARGB(255,39, 170, 225))),
                        Lottie.asset(
                          'assets/lottie/arrowright.json',
                          height: MediaQuery.of(context).size.width*0.08,
                          width: MediaQuery.of(context).size.width*0.08,
                          animate: true,),
                      ]

                  ),
                ),
              ),
            ),
            SizedBox(height: 30,),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  child: const Text('Logout'),
                  onPressed: () => showAnimatedDialog(context, SignOutConfirmationDialog(), isFlip: true),
                  style: ElevatedButton.styleFrom(
                      minimumSize: new Size(deviceSize.width * 0.5,20), backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      textStyle:
                      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                ),
              ],),
          ],
        ),
      ),
    );
  }
  Widget imageProfile() {
   String? _imageFile=Provider.of<AuthProvider>(context, listen: false).getprofileImage();
    return Center(
      child: Stack(children: <Widget>[
        _imageFile=="no profileImage" ?
        Lottie.asset(
          'assets/lottie/profilene.json',
          height: 150,
          width: 150,
          animate: true,)
            :
        _imageFile== null?
                    CircleAvatar(
                      radius: 80.0,
                      backgroundImage: AssetImage("assets/appicon.png"),
                    ):
                    CircleAvatar(
                    radius: 80.0,
                    backgroundImage: CachedNetworkImageProvider(AppConstants.BASE_URL+_imageFile!),
    )
                    ,
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => EditProfileImage(usertype:"HR")));
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.teal,
              size: 28.0,
            ),
          ),
        ),
      ]),
    );
  }
}