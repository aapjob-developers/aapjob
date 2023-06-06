import 'dart:io';
import 'dart:convert';
import 'package:Aap_job/helper/uploader.dart';
import 'package:Aap_job/localization/language_constrants.dart';
import 'package:Aap_job/models/JobTitleModel.dart';
import 'package:Aap_job/models/JobskillModel.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:Aap_job/providers/jobtitle_provider.dart';
import 'package:Aap_job/screens/widget/JobTitleSelectionScreen.dart';
import 'package:flutter/material.dart';
import 'package:Aap_job/models/common_functions.dart';

import 'package:Aap_job/screens/ResumeUpload.dart';
import 'package:Aap_job/screens/homepage.dart';
import 'package:Aap_job/screens/save_profile.dart';
import 'package:Aap_job/screens/widget/Profilebox.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:Aap_job/view/basewidget/textfield/custom_textfield.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:Aap_job/providers/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:google_language_fonts/google_language_fonts.dart';

import '../main.dart';

class EditJobExp extends StatefulWidget {
  EditJobExp({Key? key}) : super(key: key);
  @override
  _EditJobExpState createState() => new _EditJobExpState();
}

class _EditJobExpState extends State<EditJobExp> {
  bool exp=false, test=false;
  String Name="", jobcity="", joblocation="",jobtitle="";
  Color yesbutton=Colors.amber,nobutton=Colors.amber;
  String pt="",emaile="";
  File? file;

  void initState() {
    super.initState();
    initializePreference().whenComplete((){
      setState(() {
        exp=Provider.of<AuthProvider>(context, listen: false).getmyexp();
        yesbutton=Colors.amber;
        nobutton=Colors.amber;
      });

    });
  }

  Future<void> initializePreference() async{
  }
  

  Future<void> _savestep3() async {
    if(exp)
      {
      }
    else {
      if (test == false) {
        CommonFunctions.showInfoDialog("Please Select Yes Or No to Continue", context);
      }
      else {
        sharedp!.setBool("myexp", false);
        sharedp!.setBool("step4", true);
        Navigator.pushAndRemoveUntil(
            context, MaterialPageRoute(builder: (context) => ResumeUpload()), (
            route) => false);
      }
    }

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
              Navigator.pop(context);}
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
              SizedBox(width: 10,),
              Container(
                width: MediaQuery.of(context).size.width*0.6,
                child: Text("Update Latest Job Experience",maxLines:2,style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.bold),

                ),
              ),
            ]
        ),
      ),
    backgroundColor: Colors.transparent,
    body:
    SingleChildScrollView(
      child:
      new Column(
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
                  Text(getTranslated('YOUR_EXPERIENCE', context)!,style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),),
                ]
            ),
            padding: const EdgeInsets.all(5.0),
          ),
            new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(getTranslated('DO_YOU_HAVE_EXP', context)!,style: TextStyle(fontSize: 16,color: Colors.white),)
                ]
            ),
            !exp?new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: deviceSize.width-40,
                    padding: EdgeInsets.all(3.0),
                    child:
                    new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                            child: const Text('Yes'),
                            onPressed: () {
                              setState(() {
                                test=true;
                                exp=true;
                                yesbutton=Colors.green;
                                nobutton=Colors.amber;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                minimumSize: new Size(deviceSize.width * 0.3,20),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                primary: yesbutton,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                textStyle:
                                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                          ),
                          SizedBox(width: 10,),
                          ElevatedButton(
                            child: const Text('No'),
                            onPressed: () {
                              setState(() {
                                test=true;
                                exp=false;
                                yesbutton=Colors.amber;
                                nobutton=Colors.green;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                minimumSize: new Size(deviceSize.width * 0.3,20),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                primary: nobutton,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                textStyle:
                                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                          ),
                        ]

                    ),
                  ),

                ]
            ):Container(),
          new Padding(
            child:
            new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  exp? ExpBox():
                  Container(width: deviceSize.width-40,),
                ]
            ),
            padding: const EdgeInsets.all(5.0),
          ),
          exp? Container(): Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
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
                          ElevatedButton(
                            child: const Text('Save'),
                            onPressed: () {
                              _savestep3();
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
              ]
          ),
        ],
      ),
    ),
    ),),);
}
  Widget imageProfile(String _imageFile) {
    return Center(
      child: Stack(children: <Widget>[
      _imageFile == null
      ?
        CircleAvatar(
          radius: 50.0,
          backgroundImage: AssetImage("assets/appicon.png"),
        )
    :
    CircleAvatar(
    radius: 50.0,
    backgroundImage: FileImage(File(_imageFile)),
    )
    ,

      ]),
    );
  }
  }


class ExpBox extends StatefulWidget {
  ExpBox({Key? key}) : super(key: key);

  @override
  _ExpBoxState createState() => new _ExpBoxState();
}
class _ExpBoxState extends State<ExpBox> {
  final selectedIndexNotifier = ValueNotifier<int>(0);
  bool expselected=false;

  var apidata, apidatacat;
  final Dio _dio = Dio();
  final _baseUrl = AppConstants.BASE_URL;
  String apijobskilldata="";
  final selectedIndexes = [];
  TextEditingController companynameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
// Initial Selected Value
  String dropdownvalue = 'Please Select Salary';
  String totalexp="none";
  // List of items in our dropdown menu
  var items = [
    'Please Select Salary',
    '0- Rs. 10,000',
    'Rs. 10,000- Rs. 15,000',
    'Rs. 15,000- Rs. 20,000',
    'Rs. 20,000- Rs. 30,000',
    'Rs. 30,000- Rs. 40,000',
    'Rs. 40,000- Rs. 50,000',
    'Rs. 50,000- Rs. 70,000',
    'Rs. 70,000- Rs. 1,00,000',
    'Rs. 1,00,000- Rs. 1,25,000',
    'Rs. 1,25,000- Rs. 1,50,000',
    'More than Rs. 1,50,0000',
  ];

  bool _hasJobTitle=false;

  TextEditingController _jobtitleController = TextEditingController();

  List<JobTitleModel> duplicateJobTitle = <JobTitleModel>[];

  @override
  void initState() {
    super.initState();
    duplicateJobTitle= Provider.of<JobtitleProvider>(context, listen: false).jobtitleList;
    setState(() {
      expselected=Provider.of<AuthProvider>(context, listen: false).getmyexp();
      if(Provider.of<AuthProvider>(context, listen: false).getmyexp()) {
        _jobtitleController.text =
            Provider.of<AuthProvider>(context, listen: false).getJobtitle();
        companynameController.text =
            Provider.of<AuthProvider>(context, listen: false).getCompany();
        switch (Provider.of<AuthProvider>(context, listen: false).gettotalexp())
        {
          case '<1 year':
            totalexp=' < 1 ';
            selectedIndexNotifier.value=1;
            break;
          case '1-3 year':
            totalexp='1-3 ';
            selectedIndexNotifier.value=2;
            break;
          case '3-5 year':
            totalexp='3-5 ';
            selectedIndexNotifier.value=3;
            break;
          case '5-10 year':
            totalexp='5-10 ';
            selectedIndexNotifier.value=4;
            break;
          case '10+ year':
            totalexp=' 10+ ';
            selectedIndexNotifier.value=5;
            break;
        }
        switch (Provider.of<AuthProvider>(context, listen: false).getCurrentSalary())
        {
      case '0-10,000':
      dropdownvalue='0- Rs. 10,000';
        break;
      case '10,000 - 15,000':
      dropdownvalue='Rs. 10,000- Rs. 15,000';
      break;
      case '15,000 - 20,000':
      dropdownvalue='Rs. 15,000- Rs. 20,000';
      break;
      case '20,000 - 30,000':
      dropdownvalue='Rs. 20,000- Rs. 30,000';
      break;
      case '30,000 - 40,000':
      dropdownvalue='Rs. 30,000- Rs. 40,000';
      break;
      case '40,000 - 50,000':
      dropdownvalue='Rs. 40,000- Rs. 50,000';
      break;
      case '50,000 - 70,000':
      dropdownvalue='Rs. 50,000- Rs. 70,000';
      break;
      case '70,000 - 1,00,000':
      dropdownvalue='Rs. 70,000- Rs. 1,00,000';
      break;
      case '1,00,000 - 1,25,000':
      dropdownvalue='Rs. 1,00,000- Rs. 1,25,000';
      break;
      case '1,25,000 - 1,50,000':
      dropdownvalue='Rs. 1,25,000- Rs. 1,50,000';
      break;
      case '1,50,000 +':
      dropdownvalue='More than Rs. 1,50,0000';
      break;
    }
        }

    });
  }
///////////////////////////////////job titles ////////////////////


  _JobtitleDisplaySelection(BuildContext context) async {
    _hasJobTitle = duplicateJobTitle.length >= 1;
    if(_hasJobTitle) {
      final JobTitleModel result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            JobTitleSelectionScreen()),
      );
      if (result !=null)
      {
        _jobtitleController.text=result.name;
        await getJobSkills(result.id);
      }
    }
    else
    {
      CommonFunctions.showInfoDialog("Please Wait..", context);
    }



  }

///////////////////////////////////////////////////////

  Future<void> _savestep3() async {
      String _Jobtitle = _jobtitleController.text.trim();
      String _companyname = companynameController.text.trim();
      if (_Jobtitle.isEmpty || _companyname.isEmpty || totalexp == "none") {
        CommonFunctions.showInfoDialog(
            "Please select Years of Experience", context);
      } else if(dropdownvalue == "Please Select Salary")
        {
          CommonFunctions.showInfoDialog("Please select your Salary", context);
        }
      else {

        await Provider.of<ProfileProvider>(context, listen: false)
            .updateUserExperience(true,_Jobtitle, _companyname,totalexp,dropdownvalue,selectedIndexes.toString())
            .then((response) {
          if (response.isSuccess) {
            sharedp!.setBool("myexp", true);
            sharedp!.setString("jobtitle", _Jobtitle);
            sharedp!.setString("companyname", _companyname);
            sharedp!.setString("totalexp", totalexp);
            sharedp!.setString("currentsalary", dropdownvalue);
            sharedp!.setString("candidateskills", selectedIndexes.toString());
            Navigator.pushReplacement( context,  MaterialPageRoute(builder: (context) => HomePage()),);
          } else {
            CommonFunctions.showErrorDialog(response.message, context);
          }
        });
      }


  }
  Future<void> _saveexp(String exper) async {
    setState(() {
      expselected=true;
      totalexp=exper;
    });
  }

  List<JobskillModel> duplicateJobSkill = <JobskillModel>[];
  bool _hasJobSkill=false;

  getJobSkills(String jobtitleid) async {
    duplicateJobSkill.clear();
    try {
      Response response = await _dio.get(_baseUrl + AppConstants.JOB_TITLE_SKILL_URI+jobtitleid);
      apijobskilldata = response.data;
      print('JobSkill : ${apijobskilldata}');
      List<dynamic> data=json.decode(apijobskilldata);
      if(data.toString()=="[]")
      {
        duplicateJobSkill=[];
        setState(() {
          _hasJobSkill = false;
        });
      }
      else
      {
        data.forEach((jobskill) =>
            duplicateJobSkill.add(JobskillModel.fromJson(jobskill)));
        setState(() {
          _hasJobSkill =true;
        });
      }
      print('JobSkill List: ${duplicateJobSkill}');

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
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return  Container(
      width: deviceSize.width-40,
      padding: EdgeInsets.all(5.0),
      child:

      Form(
        key: _formKey,
        child: Column(
          children: [
            new Padding(
              child:
              Container(
                width: deviceSize.width-20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Primary),
                  borderRadius: BorderRadius.only(topRight: Radius.circular(6), topLeft: Radius.circular(6),bottomLeft:Radius.circular(6), bottomRight: Radius.circular(6) ),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 3, offset: Offset(0, 1)) // changes position of shadow
                  ],
                ),
                child: TextFormField(
                  readOnly: true,
                  onTap: () {
                    _JobtitleDisplaySelection(context);
                  },
                  controller: _jobtitleController,
                  decoration: InputDecoration(
                    hintText:"Job Title",
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
                    isDense: true,
                    counterText: '',
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor)),
                    errorStyle: TextStyle(height: 1.5),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Select a Job Title';
                    }
                    return null;
                  },
                ),
              ),
              padding: const EdgeInsets.all(10.0),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 5),
              width: deviceSize.width * 0.8,
              // padding: EdgeInsets.all(16.0),
              child:
              TextFormField(
                style: new TextStyle(fontSize: 14),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Company\'s Name',
                    focusColor: Colors.white// myIcon is a 48px-wide widget.
                ),
                keyboardType: TextInputType.text,
    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z\s]'))],
    validator: (value) {
    if (value!.isEmpty||value!.length<5) {
                    return 'Please Enter your Company Name';
                  }
                },
               controller: companynameController,
              ),
            ),
            Container(
             // padding: EdgeInsets.only(bottom: 5),
              width: deviceSize.width * 0.8,
              // padding: EdgeInsets.all(16.0),
              child:
              Text("Total Experience ( in Years )",style: new TextStyle(color: Colors.white,fontSize: 14,)),
            ),
            Container(
             // padding: EdgeInsets.only(bottom: 5),
              width: deviceSize.width * 0.8,
              // padding: EdgeInsets.all(16.0),
              child:
                Row(
                  children: [
                    Center(
                        child: ValueListenableBuilder<int>(
                          valueListenable: selectedIndexNotifier,
                          builder: (_, selectedIndex, __) =>
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children:[
                                    for (int j = 1; j <= 5; j++)
                                     Container(
                                       padding: EdgeInsets.all(1),
                                       child: MyWidget(
                                           key: ValueKey(j),
                                           text: j==1?' < 1 ':j==2?'1-3 ':j==3?'3-5 ':j==4?'5-10 ':' 10+ ',
                                           isFavorite: selectedIndex == j,
                                           onPressed: () {
                                             selectedIndex == j ?  selectedIndexNotifier.value = 0 : selectedIndexNotifier.value = j;
                                             _saveexp(j==1?' < 1 ':j==2?'1-3 ':j==3?'3-5 ':j==4?'5-10 ':' 10+ ');
                                           }
                                       ),
                                     )
                                  ]
                              ),
                        )),
                  ],
                ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 5),
              width: deviceSize.width * 0.8,
              // padding: EdgeInsets.all(16.0),
              child:
              Text("Current Monthly Salary",style: new TextStyle(color: Colors.white,fontSize: 14,)),
            ),
            Container(
              padding: EdgeInsets.only(left: 20,),
              decoration: new BoxDecoration(color: Colors.white),
              width: deviceSize.width * 0.8,
              child:
              DropdownButton(
               focusColor: Colors.white,
                value: dropdownvalue,
                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down),
                // Array list of items
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (value) {
                  setState(() {
                    dropdownvalue = value!;
                  });
                },
              ),
            ),
            SizedBox(height: 3,),
            new Padding(
              child:
              Text.rich(
                  TextSpan(
                      text: 'Your Job Skills',
                      style: LatinFonts.aBeeZee(fontSize: 12, fontWeight: FontWeight.bold,color:Colors.white),
                      children: <InlineSpan>[
                        TextSpan(
                          text: ' (optional)',
                          style: LatinFonts.aBeeZee(fontSize: 10, fontWeight: FontWeight.w200,color:Colors.white),
                        )
                      ]
                  )
              ),
              // Text('Job Title',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),),
              padding: const EdgeInsets.all(10.0),
            ),
            _hasJobSkill?
            Container(
                width:deviceSize.width*0.9,
                height: duplicateJobSkill.length*50.0,
                decoration: BoxDecoration(color: Colors.white),
                child:
                ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      width:deviceSize.width*0.85,
                      child: Row(
                        children: [ Checkbox(
                          value: selectedIndexes.contains(duplicateJobSkill[index].name),
                          onChanged: (value) {
                            if(selectedIndexes.contains(duplicateJobSkill[index].name)) {
                              selectedIndexes.remove(duplicateJobSkill[index].name); // unselect
                            } else {
                              selectedIndexes.add(duplicateJobSkill[index].name);  // select
                            }
                            setState(() {});
                          },
                          checkColor: Colors.greenAccent,
                          activeColor: Colors.black,
                        ),
                          Container(
                            width:deviceSize.width*0.7,
                            child: Text(
                              "${duplicateJobSkill[index].name}",
                              style: TextStyle(fontSize: 12.0),
                              maxLines: 4,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: duplicateJobSkill.length,
                )
            ):Text("No Specific Job skill available.",                     style: LatinFonts.aBeeZee(fontSize: 12, fontWeight: FontWeight.bold,color:Colors.white),),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(

                    padding: EdgeInsets.all(3.0),
                    child:
                    new Padding(
                      child:
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              child: const Text('Save'),
                              onPressed: () {
    if (_formKey.currentState!.validate()) {
      _savestep3();
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
                ]
            ),
          ],
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
  Widget build(BuildContext context) =>
      SizedBox(
        // height:50, //height of button
         width:(MediaQuery.of(context).size.width/6.5),
        child:
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(8.0),
            ),
            primary: isFavorite ? Colors.red : Colors.green,
            elevation: 3,
          ),
          child: Text(text),
          onPressed: onPressed,
        ),);

  final String text;
  final bool isFavorite;
  final VoidCallback onPressed;
}