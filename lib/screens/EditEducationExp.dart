
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

import '../main.dart';



class EditEducationExp extends StatefulWidget {
  EditEducationExp({Key? key}) : super(key: key);
  @override
  _EditEducationExpState createState() => new _EditEducationExpState();
}

class _EditEducationExpState extends State<EditEducationExp> {

  String pt="";
  bool fileselected=false, myexp=false;
  bool showoption=true;
  String Imagepath="", certificatepath="",pdfpath="";
  String filename="";
  String jobtitle="Fresher";
  String degree="";
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
          String selectedIndexes= sharedp!.getString("candidateskills")?? "no Specific Skill";
           if(Provider.of<AuthProvider>(context, listen: false).getEducation().contains("12th"))
           {
             eduvalue='12th Passed';
           }
           else if(Provider.of<AuthProvider>(context, listen: false).getEducation().contains("10th")) {
             eduvalue='10th or Below 10th';
           } else
             {
               eduvalue=Provider.of<AuthProvider>(context, listen: false).getEducation();
             }
          print(eduvalue);
          degreeController.text=Provider.of<AuthProvider>(context, listen: false).getDegree();
          collegenameController.text=Provider.of<AuthProvider>(context, listen: false).getuniversity();
          shiftvalue=Provider.of<AuthProvider>(context, listen: false).getshift();
      });
    });
  }

  Future<void> initializePreference() async{

  }

  Future<void> _savestep4() async {

    if(eduvalue!='Select Your Education')
      {
        degree=degreeController.text.trim();
        String university=collegenameController.text.trim();
            if(degree.isNotEmpty&&university.isNotEmpty&&eduvalue.isNotEmpty)
              {
                if(shiftvalue!='Select Prefered workshift') {
                  await Provider.of<ProfileProvider>(context, listen: false)
                      .updateUserEducation(eduvalue,degree,university,shiftvalue)
                      .then((response) {
                    if (response.isSuccess) {
                      sharedp!.setString("shift",shiftvalue);
                      sharedp!.setString("education", eduvalue);
                      sharedp!.setString("degree", degree);
                      sharedp!.setString("university", university);
                      Navigator.pushReplacement( context,  MaterialPageRoute(builder: (context) => HomePage()),);
                    } else {
                      CommonFunctions.showErrorDialog(response.message, context);
                    }
                  });
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
   // route();
  }

  route() async {
    setState(() {
      _isLoading = false;
    });
    Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(builder: (context)=> JobTypeSelect()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery
        .of(context)
        .size;
    return Container(
    decoration: new BoxDecoration(color: Primary),
    child:
    SafeArea(child: Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
            onPressed:()
            {
             Navigator.pop(context);
            }
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
                child: Text("Update Latest Education",maxLines:2,style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.bold),

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
                },
              ),
            ),

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
                          if (value == null || value.isEmpty||value!.length<4) {
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
    _savestep4();
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
            new Padding(
              child:
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
                    ),
                  ]
              ),
              padding: const EdgeInsets.all(10.0),
            ),
          ],
        ),
      ),
    ),
    ),
    ),
    );
  }

}




