//
// import 'package:Aap_job/screens/HrVerificationScreen.dart';
// import 'package:Aap_job/screens/hrloginscreen.dart';
// import 'package:Aap_job/screens/loginscreen.dart';
// import 'package:Aap_job/screens/profile_exp.dart';
import 'package:Aap_job/data/chat/chat_auth_repository.dart';
import 'package:Aap_job/localization/language_constrants.dart';
import 'package:Aap_job/models/ChatUserModel.dart';
import 'package:Aap_job/providers/localization_provider.dart';
import 'package:Aap_job/screens/HrVerificationScreen.dart';
import 'package:Aap_job/screens/homepage.dart';
import 'package:Aap_job/screens/hr_save_profile.dart';
import 'package:Aap_job/screens/hrhomepage.dart';
import 'package:Aap_job/screens/hrloginscreen.dart';
import 'package:Aap_job/screens/loginscreen.dart';
import 'package:Aap_job/screens/myloginscreen.dart';
import 'package:Aap_job/screens/profile_exp.dart';
import 'package:Aap_job/screens/save_profile.dart';
import 'package:Aap_job/screens/selectOptionScreen.dart';
import 'package:Aap_job/screens/splashscreen.dart';
import 'package:Aap_job/screens/testing.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:Aap_job/utill/authentification.dart';
import 'package:flutter/material.dart';
import 'package:Aap_job/models/common_functions.dart';
import 'package:Aap_job/providers/ads_provider.dart';
// import 'package:Aap_job/screens/homepage.dart';
// import 'package:Aap_job/screens/hr_save_profile.dart';
// import 'package:Aap_job/screens/hrhomepage.dart';
// import 'package:Aap_job/screens/save_profile.dart';
// import 'package:Aap_job/screens/videoApp.dart';
import 'package:Aap_job/screens/widget/adsView.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:flutter/services.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';
import '../providers/auth_provider.dart';
import 'mainloginScreen.dart';

class SelectLanguage extends StatefulWidget {
  bool isHome=false;
  SelectLanguage({Key? key, required this.isHome}) : super(key: key);
  @override
  _SelectLanguageState createState() => new _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  final selectedIndexNotifier = ValueNotifier<int>(0);
  bool? languageselected;
  String? status;
  SharedPreferences? sharedPreferences;
  var _isLoading = false;
  int selectedIndex=0;
  @override
  initState() {
    initializePreference().whenComplete((){
      setState(() {
        languageselected=false;

        status=sharedPreferences!.getString("status")?? "0";
      });
    });
    super.initState();

  }
  @override
  void dispose() {
    super.dispose();
  }
  Future<void> initializePreference() async{
    this.sharedPreferences = await SharedPreferences.getInstance();
  }

  // Future<void> signOut() async {
  //   await Authentification().signOut();
  // }

  saveUserDataToFirebase() async {
    Provider.of<ChatAuthRepository>(context, listen: false).saveUserInfoToFirestore(
      username: Provider.of<AuthProvider>(context, listen: false).getName(),
      Phone: "+91"+Provider.of<AuthProvider>(context, listen: false).getMobile(),
      profileImage: Provider.of<AuthProvider>(context, listen: false).getprofileImage(),
      context: context,
      mounted: mounted, Jobcity: Provider.of<AuthProvider>(context, listen: false).getJobCity(),
    );
  }
  Future<void> _savestep1() async {
    setState(() {
      _isLoading = true;
    });
    Provider.of<LocalizationProvider>(context, listen: false).setLanguage(Locale(
      AppConstants.languages[selectedIndexNotifier.value-1].languageCode,
      AppConstants.languages[selectedIndexNotifier.value-1].countryCode,
    ));
    print("SelectedInd->${selectedIndexNotifier.value-1}");
    int sele=selectedIndexNotifier.value-1;
    sharedp.setBool("step1", true);
    sharedp.setString("language",sele.toString());
   // print("clicked");
    route();
  }

  Future<void> _savelang(String lang) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences!.setString("lang", lang);
    setState(() {
      languageselected=true;
    });
  }



  route() async {
    if(Provider.of<AuthProvider>(context, listen: false).getacctype()=="hr")
    {
      if(widget.isHome)
      {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) => HrHomePage ()), (
            route) => false);
      }
      else
      {
        //  print("mobile number saved->"+Provider.of<AuthProvider>(context, listen: false).getMobile());
        //print("sub->"+Provider.of<AuthProvider>(context, listen: false).getfullsubmited());
        if( await Provider.of<AuthProvider>(context, listen: false).getfullsubmited()=="1")
        {
          if (status == "0") {
            // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            //     builder: (context) => HrSaveProfile(path: "",)), (
            //     route) => false);
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => HrLoginScreen()));
          }
          else {
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => HrHomePage()));
          }
        }
        else
        {
          if( Provider.of<AuthProvider>(context, listen: false).getMobile()=="no Mobile"||!Provider.of<AuthProvider>(context, listen: false).IsMobileVerified()) {
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => HrLoginScreen()));
          }
          else{
            print("mobile number saved->"+Provider.of<AuthProvider>(context, listen: false).getMobile());
            sharedPreferences!.setBool("step2", true);
            if( Provider.of<AuthProvider>(context, listen: false).getHrName()=="no Name") {
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => HrSaveProfile(path: "")));
            }
            else
            {
              sharedPreferences!.setBool("step3", true);
              //print("GST->"+Provider.of<AuthProvider>(context, listen: false).getHrGST());
              if( Provider.of<AuthProvider>(context, listen: false).getHrGST()=="no GST") {
                Navigator.push( context, MaterialPageRoute(builder: (context) => HrVerificationScreen()));
              }
              else
              {
                sharedPreferences!.setBool("step4", true);
                Navigator.push( context, MaterialPageRoute(builder: (context) => HrHomePage()));
              }

            }
          }
        }
      }
    }
    else
    {
      if(widget.isHome)
      {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) => HomePage()), (
            route) => false);
      }
      else
      {
        if(Provider.of<AuthProvider>(context, listen: false).getfullsubmited()=="1") {
          if (status == "0") {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (context) => LoginScreen()), (
                route) => false);
          }
          else {
            ChatUserModel? senderData= await Provider.of<ChatAuthRepository>(context, listen: false).getCurrentUserInfo();
            if(senderData==null)
              {
                saveUserDataToFirebase();
              }
          //  await Future.delayed(Duration(milliseconds: 5000));
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (context) => HomePage()), (route) => false);
          }
        }
        else
        {
          if( Provider.of<AuthProvider>(context, listen: false).getMobile()=="no Mobile"||!Provider.of<AuthProvider>(context, listen: false).IsMobileVerified()) {
          print(Provider.of<AuthProvider>(context, listen: false).getMobile());
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (context) => LoginScreen()), (route) => false);
          }
          else
          {
            sharedPreferences!.setBool("step2", true);
            if( Provider.of<AuthProvider>(context, listen: false).getName()=="no Name") {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (context) => SaveProfile(path:"")), (route) => false);
            }
            else
            {
              sharedPreferences!.setBool("step3", true);
              if(Provider.of<AuthProvider>(context, listen: false).getfullsubmited()=="0") {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                    builder: (context) => ProfileExp()), (route) => false);
              }
              else
              {
                ChatUserModel? senderData= await Provider.of<ChatAuthRepository>(context, listen: false).getCurrentUserInfo();
                if(senderData==null)
                {
                  saveUserDataToFirebase();
                }
              //  await Future.delayed(Duration(milliseconds: 5000));
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                    builder: (context) => HomePage()), (route) => false);
              }

            }

          }
        }
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    if(widget.isHome)
      selectedIndex = Provider.of<LocalizationProvider>(context, listen: false).languageIndex;
    return WillPopScope(
      onWillPop: () async{
        widget.isHome
            ?
        Provider.of<AuthProvider>(context, listen: false).getacctype()=="hr"
            ?
        Navigator.pushReplacement( context,  MaterialPageRoute(builder: (context) => HrHomePage()),)
            :
        Navigator.pushReplacement( context,  MaterialPageRoute(builder: (context) => HomePage()),)
            :
        SystemNavigator.pop();
        return true;
      },
      child:
      Container(
        decoration: new BoxDecoration(color: Primary),
        child:
        SafeArea(child:
        Scaffold(
          backgroundColor: Colors.transparent,
          body:
          SingleChildScrollView(
            child:Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child:new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Padding(
                        child:
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("Choose Your Language",style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),),

                            ]

                        ),
                        padding: const EdgeInsets.all(15.0),
                      ),
                      widget.isHome? Container():
                      new Padding(
                        child:
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("+91-"+Provider.of<AuthProvider>(context, listen: false).getMobile(),
                                style: new TextStyle(
                                    color: Colors.white, fontSize: 16),
                                textAlign: TextAlign.center,),
                            ]

                        ),
                        padding: const EdgeInsets.all(8.0),
                      ),
                      widget.isHome? Container():
                      new Padding(
                        child:
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(getTranslated('NOT_YOU', context)!,
                                style: new TextStyle(
                                    color: Colors.white, fontSize: 14),
                                textAlign: TextAlign.center,),

                            ]

                        ),
                        padding: const EdgeInsets.all(1.0),
                      ),
                      widget.isHome? Container():
                      new Padding(
                        child:
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Flexible(child:
                              GestureDetector(
                                onTap: (){
                                  Provider.of<AuthProvider>(context, listen: false).clearSharedData().then((condition) {
                                    Provider.of<AuthProvider>(context,listen: false).clearSharedData();
                                    //signOut();
                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SplashScreen()), (route) => false);
                                  });
                                },
                                child: Text(getTranslated("CLICK_HERE_TO_CHANGE_ACCOUNT", context)!,
                                  style: new TextStyle(
                                    color: Colors.white, fontSize: 14,decoration: TextDecoration.underline,),
                                  textAlign: TextAlign.center,),
                              ),
                              ),
                            ]

                        ),
                        padding: const EdgeInsets.all(2.0),
                      ),
                      Center(
                          child: ValueListenableBuilder<int>(
                            valueListenable: selectedIndexNotifier,
                            builder: (_, selectedIndex, __) =>
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    for (int i = 1; i <=12; i=i+3)
                                      new Padding(
                                        child:
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children:[
                                              for (int j = 1; j <= 3; j++)
                                                MyWidget(
                                                    key: ValueKey(i+j-1),
                                                    text: i+j-1==1?'English':i+j-1==2?'Hindi':i+j-1==3?'Kannada':i+j-1==4?'Bengali':i+j-1==5?'Telugu':i+j-1==6?'Tamil':i+j-1==7?'Gujarati':i+j-1==8?'Marathi':i+j-1==9?'Odia':i+j-1==10?'Assamese':i+j-1==11?'Punjabi':'Malayalam',
                                                    isFavorite: selectedIndex == i+j-1,
                                                    onPressed: () {
                                                      selectedIndex == i+j-1 ?  selectedIndexNotifier.value = 0 : selectedIndexNotifier.value = i+j-1;
                                                      _savelang(i+j-1==1?'English':i+j-1==2?'Hindi':i+j-1==3?'Kannada':i+j-1==4?'Bengali':i+j-1==5?'Telugu':i+j-1==6?'Tamil':i+j-1==7?'Gujarati':i+j-1==8?'Marathi':i+j-1==9?'Odia':i+j-1==10?'Assamese':i+j-1==11?'Punjabi':'Malayalam');
                                                    }
                                                )
                                            ]
                                        ),
                                        padding: EdgeInsets.all(5),
                                      )
                                  ],
                                ),
                          )),
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              decoration: new BoxDecoration(color: Color.fromARGB(
                                  255, 204, 204, 204)),
                              width: deviceSize.width*0.8,
                              height: deviceSize.width*0.8,
                              padding: EdgeInsets.all(3.0),
                              child:
                              Center(child: AdsView(width:deviceSize.width*0.8,height:deviceSize.width*0.8),),
                              //Center(child: VideoApp(path:'https://www.youtube.com/watch?v=GFPUy8nNAFI'),),
                            ),
                          ]
                      ),

                      Container(
                        width: deviceSize.width,
                        padding: EdgeInsets.all(3.0),
                        child:
                        new Padding(
                          child:
                          new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                if (_isLoading)
                                  CircularProgressIndicator()
                                else
                                  ElevatedButton(
                                    child: const Text('Save'),
                                    onPressed: () {
                                      languageselected==true
                                          ?
                                      _savestep1()
                                          :
                                      CommonFunctions.showSuccessToast('Please Select Language');
                                    },
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: new Size(deviceSize.width * 0.5,20),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16)),
                                        primary: Colors.amber,
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                        textStyle:
                                        const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                                  ),

                              ]

                          ),
                          padding: const EdgeInsets.all(10.0),
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
        ),
      ),);
  }

}

class MyWidget extends StatelessWidget {
  const MyWidget({
    Key? key,
    required this.text,
    required this.isFavorite,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    print("lang->${this.text}");
    return SizedBox(
      height: 50, //height of button
      width: (MediaQuery
          .of(context)
          .size
          .width / 3) - 10,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(8.0),
          ),
          primary: isFavorite ? Colors.red : Colors.green,
          elevation: 3,
        ),
        child:
        text == 'Hindi' ?
        Text(
          'हिंदी',
          style: DevanagariFonts.hind(textStyle: TextStyle(fontSize: 16)),
        )
            : text == 'English' ?
        Text(
          'English',
          style: LatinFonts.aBeeZee(textStyle: TextStyle(fontSize: 16)),
        )
            : text == 'Kannada' ?
        Text(
          'ಕನ್ನಡ',
          style: KannadaFonts.balooTamma(textStyle: TextStyle(fontSize: 16)),
        ) :
        text == 'Bengali' ?
        Text(
          'বাংলা',
          style: BengaliFonts.atma(textStyle: TextStyle(fontSize: 16)),
        ) :
        text == 'Telugu' ?
        Text(
          'తెలుగు',
          style: TeluguFonts.balooTammudu(textStyle: TextStyle(fontSize: 16)),
        ) :
        text == 'Tamil' ?
        Text(
          'தமிழ்',
          style: TamilFonts.arimaMadurai(textStyle: TextStyle(fontSize: 16)),
        ) :
        text == 'Gujarati' ?
        Text(
          'ગુજરાતી',
          style: TamilFonts.arimaMadurai(textStyle: TextStyle(fontSize: 16)),
        ) :
        text == 'Marathi' ?
        Text(
          'मराठी',
          style: DevanagariFonts.amita(textStyle: TextStyle(fontSize: 16)),
        ) :
        text == 'Odia' ?
        Text(
          'ଓଡିଆ',
          style: OriyaFonts.balooBhaina(textStyle: TextStyle(fontSize: 16)),
        ) :
        text == 'Assamese' ?
        Text(
          'অসমীয়া',
          style: LatinFonts.notoSans(textStyle: TextStyle(fontSize: 16)),
        ) :
        text == 'Malayalam' ?
        Text(
          'ਪੰਜਾਬੀ',
          style: GurmukhiFonts.balooPaaji(textStyle: TextStyle(fontSize: 16)),
        ) : Text(
          'മലയാളം',
          style: LatinFonts.notoSans(textStyle: TextStyle(fontSize: 16)),
        )
        ,

        onPressed: onPressed,
      ),);
  }
  final String text;
  final bool isFavorite;
  final VoidCallback onPressed;
}


