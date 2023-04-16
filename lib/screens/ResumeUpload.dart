
import 'dart:io';

import 'package:Aap_job/helper/uploader.dart';
import 'package:Aap_job/localization/language_constrants.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:Aap_job/screens/JobtypeSelect.dart';
import 'package:Aap_job/screens/profile_exp.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:Aap_job/models/common_functions.dart';
import 'package:Aap_job/providers/ads_provider.dart';
import 'package:Aap_job/providers/profile_provider.dart';
import 'package:Aap_job/screens/homepage.dart';
import 'package:Aap_job/screens/loginscreen.dart';
import 'package:Aap_job/screens/save_profile.dart';
import 'package:Aap_job/screens/videoApp.dart';
import 'package:Aap_job/screens/widget/adsView.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ResumeUpload extends StatefulWidget {
  ResumeUpload({Key? key}) : super(key: key);
  @override
  _ResumeUploadState createState() => new _ResumeUploadState();
}

class _ResumeUploadState extends State<ResumeUpload> {

  SharedPreferences? sharedPreferences;
  String pt="";
  bool fileselected=false, showextraedu=false, myexp=false;
  bool showoption=true;
  String Imagepath="", certificatepath="",pdfpath="";
  String filename="";
  String jobtitle="Fresher";
  String degree="";
  String Name="", jobcity="", joblocation="", company="", expyears="";
  TextEditingController degreeController = TextEditingController();
  TextEditingController collegenameController = TextEditingController();
  var _isLoading = false;
  File? file;
  var education = ['Select Your Education','10th or Below 10th','12th Passed','Diploma','ITI','Graduate',
    'Post Graduate'
  ];
  String eduvalue = 'Select Your Education';
  var shift = ['Select Prefered workshift','Day Shift','Night Shift','Any'
  ];
  String shiftvalue = 'Select Prefered workshift';
  final _formKey = GlobalKey<FormState>();
  @override
  initState() {
    super.initState();
    initializePreference().whenComplete((){
      setState(() {
          _isLoading=false;
        fileselected=false;
        showextraedu=false;
        myexp=false;

        myexp=sharedPreferences!.getBool("myexp")?? false;
          Imagepath=sharedPreferences!.getString("profileImage")?? "no Name";
        if(myexp) {
          jobtitle = sharedPreferences!.getString("jobtitle") ?? "no";
          company = sharedPreferences!.getString("companyname") ?? "no";
          expyears = sharedPreferences!.getString("totalexp") ?? "no";
        }
          String selectedIndexes= sharedPreferences!.getString("candidateskills")?? "no Specific Skill";
          print("candidate skills: "+selectedIndexes);
      });
    });
  }
  uploadFile() async {
    String taskId = await BackgroundUploader.uploadEnqueue(AppConstants.SAVE_RESUME_DATA_URI,file!,Provider.of<AuthProvider>(context, listen: false).getUserid(),"candidate","resume");
    if (taskId != null) {
      print("resume upload == "+taskId);
    } else {
      BackgroundUploader.uploader.cancelAll();
    }
  }

  Future<void> initializePreference() async{
    this.sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> _loadData(BuildContext context) async {
    await Provider.of<AdsProvider>(context, listen: false).getAds(context);
  }

  Future<void> _savestep4() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    if(eduvalue!='Select Your Education')
      {
        degree=degreeController.text.trim();
        String university=collegenameController.text.trim();
            if(degree.isNotEmpty&&university.isNotEmpty&&eduvalue.isNotEmpty)
              {
                if(eduvalue!='Select Prefered workshift') {
                  sharedPreferences!.setString("pref_shift",shiftvalue);
                  sharedPreferences!.setString("education", eduvalue);
                  sharedPreferences!.setString("degree", degree);
                  sharedPreferences!.setString("university", university);
                  sharedPreferences!.setBool("step5", true);
                  route();
                }
                else
                  {
                    setState(() {
                      _isLoading = false;
                    });
                    CommonFunctions.showInfoDialog("Please Select Prefered Work shift", context);
                  }
              }
            else
              {
                setState(() {
                  _isLoading = false;
                });
                CommonFunctions.showInfoDialog("Please Enter Education Details", context);
              }
      }
    else
      {
        CommonFunctions.showInfoDialog("Please Select Your Education.", context);
        setState(() {
          _isLoading = false;
        });
      }

    print("clicked");
   // route();
  }


  Future<void> _fileipload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'png', 'jpeg'],
    );

    if (result != null) {
      String? resumepath = result.files.single.path;
      sharedPreferences!.setString("resume", resumepath!);

      setState(() {
        fileselected=true;
        filename=result.files.single.name;
        file=File(resumepath);
        if(result.files.single.extension=="jpg"||result.files.single.extension=="png"||result.files.single.extension=="jpeg")
        {
          certificatepath=result.files.single.path!;
          pdfpath="";
        }
        else
        {
          certificatepath="";
          pdfpath=result.files.single.path!;
          print("Path: "+pdfpath);
        }
      });

    } else {
      CommonFunctions.showInfoDialog("Please Select a file", context);
    }
  }
  route() async {
    setState(() {
      _isLoading = false;
    });
    uploadFile();
    Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(builder: (context)=> JobTypeSelect()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery
        .of(context)
        .size;

    _loadData(context);

    return Container(
    decoration: new BoxDecoration(color: Primary),
    child:
    SafeArea(child: Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
            onPressed:()
            {
              sharedPreferences!.setBool("step4", false);
              Navigator.pushReplacement( context,  MaterialPageRoute(builder: (context) => ProfileExp()),);}
        ),
        automaticallyImplyLeading: true,
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Primary,
        title:
        new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                'assets/images/appicon.png',
                fit: BoxFit.contain,
                height: 30,
                width: 30,
              ),
              SizedBox(width: 5,),
              Container(
                width: MediaQuery.of(context).size.width*0.6,
                child: Text(Provider.of<AuthProvider>(context, listen: false).getEmail(),maxLines:2,style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.bold),

                ),
              ),
            ]
        ),
      ),
    backgroundColor: Colors.transparent,
    body:
    Form(
      key: _formKey,
      child: SingleChildScrollView(
        child:new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Container(
              width: MediaQuery.of(context).size.width*0.9,
              padding: const EdgeInsets.all(5.0),
              decoration: new BoxDecoration(boxShadow: [new BoxShadow(
                color: Colors.white,
                blurRadius: 5.0,
              ),],color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(5.0))),
              child:
              new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                   // Profilebox(path:Provider.of<ProfileProvider>(context, listen: false).getProfileString()==null? AppConstants.BASE_URL+'uploads/ads/smallest_video4.mp4': Provider.of<ProfileProvider>(context, listen: false).getProfileString(),),
                    imageProfile(),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      width: deviceSize.width*0.5,
                      child: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(Provider.of<AuthProvider>(context, listen: false).getName(),style: TextStyle(fontSize: 24,color: Primary,fontWeight: FontWeight.w900),),
                                ]
                            ),
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Icon(Icons.pin_drop_sharp,size: 20,),
                                  Text("  "+Provider.of<AuthProvider>(context, listen: false).getJobCity(),style: TextStyle(fontSize: 16,color: Primary),),
                                ]
                            ),
                            SizedBox(height: 3,),
                            myexp
                                ?
                            Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(Icons.account_circle,size: 15,),
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.35,
                                      child:
                                    Text(" "+jobtitle,style: TextStyle(fontSize: 14,color: Primary,fontWeight: FontWeight.bold),),),
                                  ]
                              ),
                            )
                                :Container(
                              child:
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(jobtitle,style: TextStyle(fontSize: 14,color: Primary),)
                                    ]
                                ),
                            ),
                            SizedBox(height: 3,),
                            myexp
                                ?
                            Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(Icons.badge_rounded,size: 15,),
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.35,
                                      child:
                                    Text(company,style: TextStyle(fontSize: 14,color: Primary,fontWeight: FontWeight.bold),),),
                                  ]
                              ),
                            )
                                :Container(
                              child:
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(jobtitle,style: TextStyle(fontSize: 14,color: Primary),)
                                    ]
                                ),
                            ),

                            // myexp
                            //     ?
                            // new Row(
                            //     mainAxisAlignment: MainAxisAlignment.start,
                            //     mainAxisSize: MainAxisSize.max,
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: <Widget>[
                            //       Container(
                            //         width: deviceSize.width*0.4,
                            //         child:
                            //         Text("at "+company ,style: TextStyle(fontSize: 14,color: Primary),textAlign: TextAlign.end,)
                            //
                            //       ),
                            //
                            //     ]
                            // )
                            //     : Container(),
                            myexp ?
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Icon(Icons.access_alarm,size: 15,),
                                  Text("  "+expyears +" Years",style: TextStyle(fontSize: 16,color: Primary),),
                                ]
                            )
                                :Container(),
                            SizedBox(height: 3,),
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Icon(Icons.account_balance,size: 15,),
                                  Text(" "+eduvalue,style: TextStyle(fontSize: 14,color: Primary),),
                                ]
                            ),
                          //  showextraedu?
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      width: deviceSize.width*0.4,
                                      child:
                                      Text(degreeController.text ,style: TextStyle(fontSize: 12,color: Primary))

                                  ),
                                ]
                            ),
                                //: Container(),
                          //  showextraedu?
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      width: deviceSize.width*0.4,
                                      child:
                                      Text("( "+collegenameController.text+" )" ,style: TextStyle(fontSize: 12,color: Primary))

                                  ),
                                ]
                            ),
                                //: Container(),

                          ]
                      ),
                    ),
                  ]
              ),

            ),

            Container(
              padding: EdgeInsets.only(bottom: 5,top: 10),
              width: deviceSize.width * 0.8,
              // padding: EdgeInsets.all(16.0),
              child:
              Text("Prefered Work Shift",style: new TextStyle(color: Colors.white,fontSize: 14,)),
            ),
            Container(
              padding: EdgeInsets.only(left: 20,),
              decoration: new BoxDecoration(color: Colors.white),
              width: deviceSize.width * 0.8,
              child:
              DropdownButton(
                focusColor: Colors.white,
                value: shiftvalue,
                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down),
                // Array list of items
                items: shift.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (value) {
                  setState(() {
                    shiftvalue= value!;
                  });
                },
              ),
            ),
            //  showextraedu?
            Container(
              padding: EdgeInsets.only(bottom: 5),
              width: deviceSize.width * 0.8,
              // padding: EdgeInsets.all(16.0),
              child:
              Text(getTranslated("HIGHEST_CURRENT_EDUCATION", context)!,style: new TextStyle(color: Colors.white,fontSize: 14,)),
            ),
            Container(
              padding: EdgeInsets.only(left: 20,),
              decoration: new BoxDecoration(color: Colors.white),
              width: deviceSize.width * 0.8,
              child:
              DropdownButton(
                focusColor: Colors.white,
                value: eduvalue,
                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down),
                // Array list of items
                items: education.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (value) {
                  setState(() {
                    eduvalue= value!;
                  });
                  // if(newValue!="10th or Below 10th"&&newValue!="12th Passed")
                  // {
                  //   setState(() {
                  //     showextraedu= true;
                  //   });
                  // }
                  // else
                  //   {
                  //     setState(() {
                  //       showextraedu= false;
                  //     });
                  //   }
                },
              ),
            ),
          //  showextraedu?
            Container(
              width: deviceSize.width-40,
              padding: EdgeInsets.all(3.0),
              child:
              new Padding(
                child:
                new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        style: new TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Course Name/Stream Name/Subject Name',
                            focusColor: Colors.white// myIcon is a 48px-wide widget.
                        ),
                        keyboardType: TextInputType.text,
                        controller: degreeController,
                  validator: (value) {
            if (value == null || value.isEmpty) {
            return 'Please Enter Course Name/Stream Name/Subject Name';
            }
            return null;
            },
                      ),
                      TextFormField(
                        style: new TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Board/University/Institute Name',
                            focusColor: Colors.white// myIcon is a 48px-wide widget.
                        ),
                        keyboardType: TextInputType.text,
                        controller: collegenameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Board/University/Institute Name';
                          }
                          return null;
                        },
                      ),
                    ]
                ),
                padding: const EdgeInsets.all(10.0),
              ),
            ),
            //    :Container(),
            new Padding(
              child:
              new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(getTranslated("UPLOAD_RESUME", context)!,style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                  ]

              ),
              padding: const EdgeInsets.all(5.0),
            ),
            fileselected?
            new Padding(
              child:
              new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: deviceSize.width*0.8,
                      child:
                      Text(filename,style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.bold),),
                    )
                  ]

              ),
              padding: const EdgeInsets.all(5.0),
            ): Container(),
            certificatepath==""?
            Container():
            new Padding(
              child:
              new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width:deviceSize.width*0.8,
                      child:
                      Image.file(
                          File(certificatepath)),
                    )
                  ]

              ),
              padding: const EdgeInsets.all(5.0),
            ),
            pdfpath==""?
            Container():
            new Padding(
              child:
              new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: new BoxDecoration(border: Border.all(color:Colors.white,width: 2),borderRadius: BorderRadius.all(Radius.circular(5))),
                      width:deviceSize.width*0.9,
                      height: deviceSize.width*0.9,
                      child:PdfView(path: pdfpath),
                    )
                  ]

              ),
              padding: const EdgeInsets.all(5.0),
            ),
            Container(
              width: deviceSize.width,
              padding: EdgeInsets.all(3.0),
              child:
              new Padding(
                child:
                new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        child: fileselected? Text('Select Another File'):Text('Select file to Upload'),
                        onPressed: () {
                          _fileipload();
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: new Size(deviceSize.width * 0.5,20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            primary: Colors.amber,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            textStyle:
                            const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                      ),

                    ]

                ),
                padding: const EdgeInsets.all(5.0),
              ),
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
    if (_formKey.currentState!.validate())
      {
    setState(() {
    _isLoading=true;
    });
    fileselected
    ?
    _savestep4()
        :
    setState(() {
    _isLoading=false;
    CommonFunctions.showSuccessToast('Please Select file to upload');
    });
    }
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: new Size(deviceSize.width * 0.5,20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            primary: Colors.amber,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            textStyle:
                            const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ),

                    ]

                ),
                padding: const EdgeInsets.all(10.0),
              ),
            ),
          ],
        ),
      ),
    ),
    ),
    ),
    );

  }
  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: 50.0,
          backgroundImage: FileImage(File(Provider.of<AuthProvider>(context, listen: false).getprofileImage())),
        ),

      ]),
    );
  }
}




