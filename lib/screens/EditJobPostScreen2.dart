import 'dart:convert';
import 'dart:io';
import 'package:Aap_job/localization/language_constrants.dart';
import 'package:Aap_job/models/JobsModel.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:Aap_job/models/CitiesModel.dart';

import 'package:Aap_job/models/JobTitleModel.dart';
import 'package:Aap_job/models/JobskillModel.dart';
import 'package:Aap_job/models/LocationModel.dart';
import 'package:Aap_job/models/common_functions.dart';

import 'package:Aap_job/screens/LocationSelectionScreen.dart';
import 'package:Aap_job/screens/hrhomepage.dart';
import 'package:Aap_job/screens/hrloginscreen.dart';
import 'package:Aap_job/screens/loginscreen.dart';
import 'package:Aap_job/screens/profile_exp.dart';
import 'package:Aap_job/screens/widget/CitySelectionScreen.dart';
import 'package:Aap_job/screens/widget/JobTitleSelectionScreen.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:Aap_job/utill/dimensions.dart';
import 'package:Aap_job/view/basewidget/animated_custom_dialog.dart';
import 'package:Aap_job/view/basewidget/textfield/custom_textfield.dart';
import 'package:video_player/video_player.dart';
import 'package:Aap_job/providers/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:google_language_fonts/google_language_fonts.dart';


class EditJobPostScreen2 extends StatefulWidget {
  EditJobPostScreen2({Key? key,required this.repost, required this.jobcityid, required this.JobTitle,required this.JobCategory, required this.Jobcatid, required this.openings, required this.jobtype, required this.workplace, required this.contract, required this.jobcity, required this.joblocation, required this.Gender,required this.education, required this.jobs }) : super(key: key);
  String jobcityid, JobTitle, JobCategory, Jobcatid, openings, jobtype, workplace, contract, jobcity, joblocation,Gender,education;
  JobsModel jobs;
  bool repost;
  @override
  _EditJobPostScreen2State createState() => new _EditJobPostScreen2State();
}

class _EditJobPostScreen2State extends State<EditJobPostScreen2> {
  final Dio _dio = Dio();
  final _baseUrl = AppConstants.BASE_URL;
  String jobtitle="",JobCategory="",openings="",jobtype="",workplace="",Gender="",joblocation="",education="",jobcity="";
  SharedPreferences? sharedPreferences;
  String apiresponse="",HrCompany="",HrWebsite="",HrName="",phone="";
  String jobcityid="0";
  String Jobcatid="0";
  String experience_level="Fresher";
  String callallow="Allow";
  String updateoptin="optin";
  bool allowvalue=true, optin=true;

  var apijobskilldata;
  final selectedIndexes = [];

  TextEditingController MinsalaryController= TextEditingController();
  TextEditingController MaxsalaryController= TextEditingController();

  TextEditingController addressController = TextEditingController();

  TextEditingController JobdescriptionController = TextEditingController();

  Future<void> initializePreference() async{
    this.sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    initializePreference().whenComplete((){
      setState(() {

        HrCompany= sharedPreferences!.getString("HrCompanyName")?? "no Job Title";
        HrWebsite= sharedPreferences!.getString("HrWebsite")?? "no Job Title";
        jobcityid= widget.jobcityid;
        HrName=sharedPreferences!.getString("HrName")?? "no Job Title";
        phone=sharedPreferences!.getString("phone")?? "no Job Title";
        jobtitle=  widget.JobTitle;
        JobCategory= widget.JobCategory;
        openings= widget.openings;
        jobtype= widget.jobtype;
        workplace= widget.workplace;
        Gender= widget.Gender;
        joblocation= widget.joblocation;
        education= widget.education;
        jobcity= widget.jobcity;
        Jobcatid= widget.Jobcatid;
        getJobSkills();
        Minexp=widget.jobs.minExp+" Years";
        Maxexp=widget.jobs.maxExp+" Years";
        Minsalary=widget.jobs.minSalary;
        Maxsalary=widget.jobs.maxSalary;
        MinsalaryController.text=widget.jobs.minSalary;
        MaxsalaryController.text=widget.jobs.maxSalary;
        incentive=widget.jobs.incentive;
        if(incentive=="1")
          {
            incentivevalue=true;
          }
        else
          {
            incentivevalue=false;
          }

        shift=widget.jobs.shift;
        if(shift=="Day Shift") {
          showday = false;
          shownight = false;
          selectedday = true;
          selectednight = false;
        }
        else
          {
            showday = false;
            shownight = false;
            selectedday = false;
            selectednight = true;
          }


        englishlevel=widget.jobs.englishLevel;

        if(englishlevel=="No English") {
          shownoenglish=false;
          showcasual=false;
          showintermidiate=false;
          showfluent=false;
        selectednoenglish=true;
        selectedcasual=false;
        selectedintermidiate=false;
        selectedfluent=false;
        }
        else if(englishlevel=="Casual")
        {
          shownoenglish=false;
          showcasual=false;
          showintermidiate=false;
          showfluent=false;
          selectednoenglish=false;
          selectedcasual=true;
          selectedintermidiate=false;
          selectedfluent=false;
        } else if(englishlevel=="Intermediate")
        {
          shownoenglish=false;
          showcasual=false;
          showintermidiate=false;
          showfluent=false;
          selectednoenglish=false;
          selectedcasual=false;
          selectedintermidiate=true;
          selectedfluent=false;
        }
        else if(englishlevel=="Expert")
        {
          shownoenglish=false;
          showcasual=false;
          showintermidiate=false;
          showfluent=false;
          selectednoenglish=false;
          selectedcasual=false;
          selectedintermidiate=false;
          selectedfluent=true;
        }
        address=widget.jobs.address;
        addressController.text=widget.jobs.address;

        experience_level=widget.jobs.experienceLevel;

        Jobdescription=widget.jobs.des;

        JobdescriptionController.text=widget.jobs.des;
      });
    });

    super.initState();
  }
  ///////////////////////////// Job Skill
  List<JobskillModel> duplicateJobSkill = <JobskillModel>[];
  bool _hasJobSkill=false;
  getJobSkills() async {
    duplicateJobSkill.clear();
    try {
      Response response = await _dio.get(_baseUrl + AppConstants.JOB_CAT_SKILL_URI+Jobcatid);
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

  //////////////////////////// Experience
  var minexp = [
    'Min exp.',
    '0 Year',
    '1 Year',
    '2 Years',
    '3 Years',
    '4 Years',
    '5 Years',
    '6 Years',
    '7 Years',
    '8 Years',
    '9 Years',
    '10 Years',
    '11 Years',
    '12 Years',
    '13 Years',
    '14 Years',
    '15 Years',
    '16 Years',
    '17 Years',
    '18 Years',
    '19 Years',
    '20 Years',
  ];
  var maxexp = [
    'Max exp.',
    '0 Year',
    '1 Year',
    '2 Years',
    '3 Years',
    '4 Years',
    '5 Years',
    '6 Years',
    '7 Years',
    '8 Years',
    '9 Years',
    '10 Years',
    '11 Years',
    '12 Years',
    '13 Years',
    '14 Years',
    '15 Years',
    '16 Years',
    '17 Years',
    '18 Years',
    '19 Years',
    '20 Years',
  ];
  String Minexp = 'Min exp.';
  String Maxexp = 'Max exp.';
/////////////////////
  //////////////////// Salary
  String Minsalary="";
  String Maxsalary="";
  /////////////////
  //////////////////// incentive
  bool incentivevalue = false;
  String incentive="0";
  ///////////////////////////

  /////////////////// job Benefits
  bool selectedCab=false,selectedMeal=false,selectedInsurance=false, selectedPF=false,selectedMedical=false,selectedOther=false;
  String Others="";
  /////////////////////
//////////////////// address
  String address="";
  ///////////////////////////

  /////////////////Shift
  bool showday=true,shownight=true;
  bool selectedday=false,selectednight=false;
  String shift="";

  /////////////////English Level
  bool shownoenglish=true,showcasual=true,showintermidiate=true,showfluent=true;
  bool selectednoenglish=false,selectedcasual=false,selectedintermidiate=false,selectedfluent=false;
  String englishlevel="";

//////////////////////////

  /////////////////////////////// job description
   String Jobdescription="";
  bool _isLoading=false;

  _savedata() async {
    setState(() {
      _isLoading=true;
    });


    if (Minexp=="Min exp."||Maxexp=="Max exp."||Minsalary==""||Minsalary.isEmpty||Maxsalary==""||Maxsalary.isEmpty||shift==""||englishlevel==""||address==""||address.isEmpty)
    {
      setState(() {
        _isLoading=false;
      });
      CommonFunctions.showErrorDialog("Please fill All Details", context);
    }
    else{
      FormData formData = new FormData.fromMap(
          {"repost":widget.repost,"jobid":widget.jobs.id,"recruiter_id": Provider.of<AuthProvider>(context, listen: false).getUserid(), "category_id":Jobcatid, "job_role":jobtitle,
        "workplace":workplace,"company_name":HrCompany,"company_website":HrWebsite,
        "job_city_id":jobcityid,"address":address,"job_location":joblocation,
        "type_of_job":jobtype,"min_salary":Minsalary,"max_salary":Maxsalary,"isContractJob":widget.contract,
            "openings_no":openings,"shift":shift,"min_qualification":education,
            "gender":Gender,"experience_level":experience_level,"min_exp":Minexp,
            "max_exp":Maxexp,"incentive":incentive,"english_level":englishlevel,
            "des":Jobdescription,"recruiter_name":HrName,"recruiter_mobile":phone,
            "call_allow":callallow,"whatsapp_optin":updateoptin,"status":"open","jobskills":selectedIndexes.toString(),
        "cab":selectedCab,"meal":selectedMeal,"insurance":selectedInsurance,"PF":selectedPF,
            "medical":selectedMedical,"Other":selectedOther,"otherbenefits":Others});

      try {
        Response response = await _dio.post(_baseUrl + AppConstants.SAVE_JOB_DATA_URI,data:formData );
        apiresponse= response.data;
        print('Save Response: ${apiresponse}');
        if(apiresponse.toString()=="success")
          {
            setState(() {
              _isLoading=false;
            });

            widget.repost?
            CommonFunctions.showSuccessToast("Congratulatrion!! Job Posted Suuccessfully")
                :
            CommonFunctions.showSuccessToast("Congratulatrion!! Job Updated Suuccessfully");

            sharedPreferences!.remove("Min exp");
            sharedPreferences!.remove("Max exp");
            sharedPreferences!.remove("Min salary");
            sharedPreferences!.remove("Max salary");
            sharedPreferences!.remove("incentive");
            sharedPreferences!.remove("cab");
            sharedPreferences!.remove("meal");
            sharedPreferences!.remove("insurance");
            sharedPreferences!.remove("PF");
            sharedPreferences!.remove("medical");
            sharedPreferences!.remove("other");
            sharedPreferences!.remove("otherbenefits");
            sharedPreferences!.remove("shift");
            sharedPreferences!.remove("englishlevel");
            sharedPreferences!.remove("address");
            sharedPreferences!.remove("jobdes");
            sharedPreferences!.remove("Experience");
            sharedPreferences!.remove("jobcityid");
            sharedPreferences!.remove("JobTitle");
            sharedPreferences!.remove("JobCategory");
            sharedPreferences!.remove("Jobcatid");
            sharedPreferences!.remove("openings");
            sharedPreferences!.remove("jobtype");
            sharedPreferences!.remove("workplace");
            sharedPreferences!.remove("jobcity");
            sharedPreferences!.remove("joblocation");
            sharedPreferences!.remove("Gender");
            sharedPreferences!.remove("education");
            sharedPreferences!.remove("postjobstep1");
            Navigator.pushAndRemoveUntil( context,  MaterialPageRoute(builder: (context) => HrHomePage()), (Route route) => false);
          }
        else
          {
            setState(() {
              _isLoading=false;
            });
            CommonFunctions.showErrorDialog(apiresponse.toString(), context);
          }
      } on DioError catch (e) {
        CommonFunctions.showErrorDialog(e.message!, context);
        // The request was made and the server responded with a status code
        // that falls out of the range of 2xx and is also not 304.
        if (e.response != null) {
          setState(() {
            _isLoading=false;
          });
          print('Dio error!');
          print('STATUS: ${e.response?.statusCode}');
          print('DATA: ${e.response?.data}');
          print('HEADERS: ${e.response?.headers}');
        }
        else {
          // Error due to setting up or sending the request
          print('Error sending request!');
          print(e.message);
          setState(() {
            _isLoading=false;
          });
        }
      }

    }

  }



  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery
        .of(context)
        .size;
    return Container(
      decoration: new BoxDecoration(color: Colors.white),
      child:
      SafeArea(child:
      Scaffold(
        backgroundColor: Colors.transparent,
        body:
        SingleChildScrollView(
          child:
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child:new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width:deviceSize.width,
                        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10.0),
                        decoration: new BoxDecoration(color: Colors.pink.shade300),
                        child:
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.file_copy_sharp,size: 30,color: Colors.white,),
                              SizedBox(width: 5,),
                              Text(getTranslated("ONE_LAST_STEP", context)!,style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),),
                            ]

                        ),

                      ),
                      //////Experience
                      SizedBox(height: 10,),
                      new Padding(
                        child:
                        Text.rich(
                            TextSpan(
                                text: 'Required Experience in '+jobtitle,
                                style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: '*',
                                    style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold,color:Colors.red),
                                  )
                                ]
                            )
                        ),
                        // Text('Job Title',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),),
                        padding: const EdgeInsets.all(10.0),
                      ),
                  new Padding(
                    child:
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                    Container(
                    width:deviceSize.width*0.45,
                        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10.0),
                        child:
                          DropdownButton(
                            alignment: AlignmentDirectional.bottomCenter,
                            isExpanded:true,
                            focusColor: Colors.white,
                            value: Minexp,
                            // Down Arrow Icon
                            icon: const Icon(Icons.keyboard_arrow_down),
                            // Array list of items
                            items: minexp.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (String? newValue) async {
                              setState(() {
                                Minexp= newValue!;
                                if(Minexp=="0 Year")
                                  {
                                    experience_level="Fresher";
                                  }
                                else
                                  {
                                    experience_level="Experienced";
                                  }
                              });
                            },
                          ),
                    ),
                    Container(
                        width:deviceSize.width*0.45,
                        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10.0),
                        child:
                          DropdownButton(
                            alignment: AlignmentDirectional.bottomCenter,
                            isExpanded:true,
                            focusColor: Colors.white,
                            value: Maxexp,
                            // Down Arrow Icon
                            icon: const Icon(Icons.keyboard_arrow_down),
                            // Array list of items
                            items: maxexp.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (String? newValue) async {
                              setState(() {
                                Maxexp= newValue!;
                                if(Maxexp=="0 Year")
                                {
                                  experience_level="Fresher";

                                }
                                else
                                {
                                  experience_level="Experienced";
                                }
                              });

                            },
                          ),
                    ),
                        ]
                    ),
                    padding: const EdgeInsets.all(10.0),
                  ),
      //////////////////////////////////// Salary
                      new Padding(
                        child:
                        Text.rich(
                            TextSpan(
                                text: 'In-Hand Salary',
                                style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: ' (per Month )',
                                    style: LatinFonts.aBeeZee(fontSize: 12, fontWeight: FontWeight.bold,color:Colors.grey),
                                  ),
                                  TextSpan(
                                    text: '*',
                                    style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold,color:Colors.red),
                                  )
                                ]
                            )
                        ),
                        // Text('Job Title',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),),
                        padding: const EdgeInsets.all(10.0),
                      ),
                      new Padding(
                        child:
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width:deviceSize.width*0.45,
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child:
                                TextField(
                                  keyboardType: TextInputType.phone,
                                  onChanged: (value) {
                                    setState(() {
                                      Minsalary=value;
                                    });
                                  },
                                   controller: MinsalaryController,
                                  decoration: InputDecoration(
                                      isDense: true,
                                      filled: true,
                                      fillColor: Colors.white,
                                      // labelText:"Number of Openings",
                                      hintText:"10,000",
                                      prefixIcon: Icon(Icons.currency_rupee),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                                ),
                              ),
                              Container(
                                width:deviceSize.width*0.45,
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child:
                                TextField(
                                  keyboardType: TextInputType.phone,
                                  onChanged: (value) {
                                    setState(() {
                                      Maxsalary=value;
                                    });

                                  },
                                   controller: MaxsalaryController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                      filled: true,
                                      fillColor: Colors.white,
                                      // labelText:"Number of Openings",
                                      hintText:"50,000",
                                      prefixIcon: Icon(Icons.currency_rupee),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                                ),
                              ),
                            ]
                        ),
                        padding: const EdgeInsets.all(10.0),
                      ),
        ////////////////////// incentive
                      ////////////////////////////////// Incentives
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          child:
                          Row(
                            children: [
                              Checkbox(
                                value: this.incentivevalue,
                                onChanged: (bool? value) {
                                  setState(() {
                                    this.incentivevalue = value!;
                                    if(value==true)
                                    {
                                      incentive="1";
                                    }
                                    else
                                    {
                                      incentive="0";
                                    }
                                  });
                                },
                              ),
                              Text(' Plus extra incentives',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),),
                            ],
                          )
                        //Checkbox
                      ),
                      //////////////////////////////////// Job Benefits
                      new Padding(
                        child:
                        Text.rich(
                            TextSpan(
                                text: 'Job Benefits ',
                                style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: '(optional)',
                                    style: LatinFonts.aBeeZee(fontSize: 12,color:Colors.grey),
                                  )
                                ]
                            )
                        ),
                        // Text('Job Title',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),),
                        padding: const EdgeInsets.all(10.0),
                      ),
                      new Padding(
                        child:
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              //////////Cab
                              selectedCab?
                        GestureDetector(
                        onTap: (){
                      setState(() {
                      selectedCab=false;
                      });
                      },
                          child:
                              Container(
                                decoration: new BoxDecoration(color: Colors.pink.shade200,border: Border.all(color:Primary,width: 1),borderRadius: BorderRadius.all(Radius.circular(25))),
                                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                margin: EdgeInsets.all(5),
                                width: deviceSize.width*0.2,
                                child:
                                new Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text("Cab",style: TextStyle(color: Primary,fontSize: 14),),
                                        Icon(Icons.check,size: 20,color: Colors.black,),

                                    ]
                                ),
                              ),)
                                  :
                GestureDetector(
                onTap: (){
          setState(() {
          selectedCab=true;
          });
          },
              child:
                              Container(
                                decoration: new BoxDecoration(color: Colors.white,border: Border.all(color:Primary,width: 1),borderRadius: BorderRadius.all(Radius.circular(25))),
                                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                margin: EdgeInsets.all(5),
                                width: deviceSize.width*0.2,
                                child:
                                new Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text("Cab",style: TextStyle(color: Primary,fontSize: 14),),

                                        Icon(Icons.add,size: 20,color: Colors.black,),

                                    ]
                                ),
                              ),
                ),

                              //////////Cab
                              selectedMeal?
                              GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      selectedMeal=false;
                                    });
                                  },
                                  child:
                              Container(
                                decoration: new BoxDecoration(color: Colors.pink.shade200,border: Border.all(color:Primary,width: 1),borderRadius: BorderRadius.all(Radius.circular(25))),
                                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                margin: EdgeInsets.all(5),
                                width: deviceSize.width*0.2,
                                child:
                                new Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text("Meal",style: TextStyle(color: Primary,fontSize: 14),),

                                        Icon(Icons.check,size: 20,color: Colors.black,),

                                    ]
                                ),
                              ),):
                              GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      selectedMeal=true;
                                    });
                                  },
                                  child:
                              Container(
                                decoration: new BoxDecoration(color: Colors.white,border: Border.all(color:Primary,width: 1),borderRadius: BorderRadius.all(Radius.circular(25))),
                                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                margin: EdgeInsets.all(5),
                                width: deviceSize.width*0.2,
                                child:
                                new Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text("Meal",style: TextStyle(color: Primary,fontSize: 14),),

                                        Icon(Icons.add,size: 20,color: Colors.black,),

                                    ]
                                ),),),


                              //////////Cab
                              selectedInsurance?
                              GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      selectedInsurance=false;
                                    });
                                  },
                                  child:
                              Container(
                                decoration: new BoxDecoration(color: Colors.pink.shade200,border: Border.all(color:Primary,width: 1),borderRadius: BorderRadius.all(Radius.circular(25))),
                                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                margin: EdgeInsets.all(5),
                                width: deviceSize.width*0.3,
                                child:
                                new Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text("Insurance",style: TextStyle(color: Primary,fontSize: 14),),

                                        Icon(Icons.check,size: 20,color: Colors.black,),

                                    ]
                                ),
                              ),):
                              GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      selectedInsurance=true;
                                    });
                                  },
                                  child:
                              Container(
                                decoration: new BoxDecoration(color: Colors.white,border: Border.all(color:Primary,width: 1),borderRadius: BorderRadius.all(Radius.circular(25))),
                                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                margin: EdgeInsets.all(5),
                                width: deviceSize.width*0.3,
                                child:
                                new Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text("Insurance",style: TextStyle(color: Primary,fontSize: 14),),

                                        Icon(Icons.add,size: 20,color: Colors.black,),

                                    ]
                                ),
                              ),),

                            ]
                        ),
                        // Text('Job Title',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),),
                        padding: const EdgeInsets.all(5.0),
                      ),
                      new Padding(
                        child:
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              //////////Cab
                              selectedPF?
                        GestureDetector(
                        onTap: (){
                      setState(() {
                      selectedPF=false;
                      });
                      },
                          child:
                              Container(
                                decoration: new BoxDecoration(color: Colors.pink.shade200,border: Border.all(color:Primary,width: 1),borderRadius: BorderRadius.all(Radius.circular(25))),
                                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                margin: EdgeInsets.all(5),
                                width: deviceSize.width*0.2,
                                child:
                                new Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text("PF",style: TextStyle(color: Primary,fontSize: 14),),

                                        Icon(Icons.check,size: 20,color: Colors.black,),

                                    ]
                                ),
                              ),)
                                  :
                GestureDetector(
                onTap: (){
          setState(() {
          selectedPF=true;
          });
          },
              child:
                              Container(
                                decoration: new BoxDecoration(color: Colors.white,border: Border.all(color:Primary,width: 1),borderRadius: BorderRadius.all(Radius.circular(25))),
                                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                margin: EdgeInsets.all(5),
                                width: deviceSize.width*0.2,
                                child:
                                new Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text("PF",style: TextStyle(color: Primary,fontSize: 14),),

                                        Icon(Icons.add,size: 20,color: Colors.black,),

                                    ]
                                ),
                              ),),

                              //////////Cab
                              selectedMedical?
                              GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      selectedMedical=false;
                                    });
                                  },
                                  child:
                              Container(
                                decoration: new BoxDecoration(color: Colors.pink.shade200,border: Border.all(color:Primary,width: 1),borderRadius: BorderRadius.all(Radius.circular(25))),
                                padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                                margin: EdgeInsets.all(5),
                                width: deviceSize.width*0.35,
                                child:
                                new Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text("Medical Benefits",style: TextStyle(color: Primary,fontSize: 14),),

                                        Icon(Icons.check,size: 20,color: Colors.black,),
                                    ]
                                ),
                              ),):
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    selectedMedical=true;
                                  });
                                },
                                child:
                              Container(
                                decoration: new BoxDecoration(color: Colors.white,border: Border.all(color:Primary,width: 1),borderRadius: BorderRadius.all(Radius.circular(25))),
                                padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                                margin: EdgeInsets.all(5),
                                width: deviceSize.width*0.35,
                                child:
                                new Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text("Medical Benefits",style: TextStyle(color: Primary,fontSize: 14),),

                                        Icon(Icons.add,size: 20,color: Colors.black,),

                                    ]
                                ),
                              ),),

                              //////////Cab
                              selectedOther?
                              Container():
                              GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      selectedOther=true;
                                    });
                                  },
                                  child:
                              Container(
                                decoration: new BoxDecoration(color: Colors.white,border: Border.all(color:Primary,width: 1),borderRadius: BorderRadius.all(Radius.circular(25))),
                                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                margin: EdgeInsets.all(5),
                                width: deviceSize.width*0.3,
                                child:
                                new Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text("Add More",style: TextStyle(color: Primary,fontSize: 14),),

                                        Icon(Icons.add,size: 20,color: Colors.black,),

                                    ]
                                ),
                              ),),
                            ]
                        ),
                        // Text('Job Title',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),),
                        padding: const EdgeInsets.all(5.0),
                      ),
                      selectedOther?new Padding(
                        child:
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width:deviceSize.width*0.9,
                                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10.0),
                                child:
                                TextField(
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    setState(() {
                                      Others=value;
                                    });
                                  },
                                  // controller: editingController,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      // labelText:"Number of Openings",
                                      hintText:"Other Perks e.g. Breakfast, gym,childcare etc",
                                      // prefixIcon: Icon(Icons.numbers),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                                ),
                              ),
                            ]
                        ),
                        // Text('Job Title',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),),
                        padding: const EdgeInsets.all(5.0),
                      ):Container(),
                      ////////////////// Job Type
                      new Padding(
                        child:
                        Text.rich(
                            TextSpan(
                                text: 'Timings',
                                style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: '*',
                                    style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold,color:Colors.red),
                                  )
                                ]
                            )
                        ),
                        // Text('Job Title',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),),
                        padding: const EdgeInsets.all(10.0),
                      ),
                      new Padding(
                        child:
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              showday?
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    showday=false;
                                    shownight=false;
                                    selectedday=true;
                                    selectednight=false;
                                    shift="Day Shift";
                                  });
                                },
                                child:
                                Container(
                                  decoration: new BoxDecoration(color: Colors.white,border: Border.all(color:Primary,width: 1),borderRadius: BorderRadius.all(Radius.circular(25))),
                                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                  margin: EdgeInsets.all(5),
                                  width: deviceSize.width*0.4,
                                  child:
                                  Text("Day Shift",style: TextStyle(color: Primary,fontSize: 14),),
                                ),

                              ):
                              selectedday? Container(
                                decoration: new BoxDecoration(color: Colors.pink.shade200,border: Border.all(color:Primary,width: 1),borderRadius: BorderRadius.all(Radius.circular(25))),
                                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                margin: EdgeInsets.all(5),
                                width: deviceSize.width*0.4,
                                child:
                                new Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(" Day Shift",style: TextStyle(color: Primary,fontSize: 14),),
                                      GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            showday=true;
                                            shownight=true;
                                            selectedday=true;
                                            selectednight=false;
                                            shift="";
                                          });
                                        },
                                        child:
                                        Icon(Icons.highlight_off_sharp,size: 20,color: Colors.black,),
                                      ),
                                    ]
                                ),
                              ):Container(),
                              shownight?
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    showday=false;
                                    shownight=false;
                                    selectedday=false;
                                    selectednight=true;
                                    shift="Night Shift";
                                  });
                                },
                                child:
                                Container(
                                  decoration: new BoxDecoration(color: Colors.white,border: Border.all(color:Primary,width: 1),borderRadius: BorderRadius.all(Radius.circular(25))),
                                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                  margin: EdgeInsets.all(5),
                                  width: deviceSize.width*0.4,
                                  child:
                                  Text("Night Shift",style: TextStyle(color: Primary,fontSize: 14),),
                                ),

                              ):
                              selectednight? Container(
                                decoration: new BoxDecoration(color: Colors.pink.shade200,border: Border.all(color:Primary,width: 1),borderRadius: BorderRadius.all(Radius.circular(25))),
                                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                margin: EdgeInsets.all(5),
                                width: deviceSize.width*0.4,
                                child:
                                new Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text("Night Shift",style: TextStyle(color: Primary,fontSize: 14),),
                                      GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            showday=true;
                                            shownight=true;
                                            selectedday=false;
                                            selectednight=false;
                                            shift="";
                                          });
                                        },
                                        child:
                                        Icon(Icons.highlight_off_sharp,size: 20,color: Colors.black,),
                                      ),
                                    ]
                                ),
                              ):Container(),
                            ]
                        ),
                        // Text('Job Title',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),),
                        padding: const EdgeInsets.all(5.0),
                      ),
                      ////////////////// English Speaking
                      new Padding(
                        child:
                        Text.rich(
                            TextSpan(
                                text: 'English Knowledge',
                                style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: '*',
                                    style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold,color:Colors.red),
                                  )
                                ]
                            )
                        ),
                        // Text('Job Title',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),),
                        padding: const EdgeInsets.all(10.0),
                      ),
                      new Padding(
                        child:
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              ///////////////No english
                              shownoenglish?
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    shownoenglish=false;
                                    showcasual=false;
                                    showintermidiate=false;
                                    showfluent=false;

                                    selectednoenglish=true;
                                    selectedcasual=false;
                                    selectedintermidiate=false;
                                    selectedfluent=false;
                                    englishlevel="No English";
                                  });
                                },
                                child:
                                Container(
                                  decoration: new BoxDecoration(color: Colors.white,border: Border.all(color:Primary,width: 1),borderRadius: BorderRadius.all(Radius.circular(25))),
                                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                  margin: EdgeInsets.all(5),
                                  width: deviceSize.width*0.2,
                                  child:
                                  Text("No English",style: TextStyle(color: Primary,fontSize: 12),),
                                ),

                              ):
                              selectednoenglish?
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    shownoenglish=true;
                                    showcasual=true;
                                    showintermidiate=true;
                                    showfluent=true;

                                    selectednoenglish=false;
                                    selectedcasual=false;
                                    selectedintermidiate=false;
                                    selectedfluent=false;
                                    englishlevel="";
                                  });
                                },
                                child:
                              Container(
                                decoration: new BoxDecoration(color: Colors.pink.shade200,border: Border.all(color:Primary,width: 1),borderRadius: BorderRadius.all(Radius.circular(25))),
                                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                margin: EdgeInsets.all(5),
                                width: deviceSize.width*0.3,
                                child:
                                new Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text("No english",style: TextStyle(color: Primary,fontSize: 12),),

                                        Icon(Icons.highlight_off_sharp,size: 15,color: Colors.black,),

                                    ]
                                ),
                              ),):Container(),
                              ////////////// Casual
                              showcasual?
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    shownoenglish=false;
                                    showcasual=false;
                                    showintermidiate=false;
                                    showfluent=false;

                                    selectednoenglish=false;
                                    selectedcasual=true;
                                    selectedintermidiate=false;
                                    selectedfluent=false;
                                    englishlevel="Casual";
                                  });
                                },
                                child:
                                Container(
                                  decoration: new BoxDecoration(color: Colors.white,border: Border.all(color:Primary,width: 1),borderRadius: BorderRadius.all(Radius.circular(25))),
                                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                  margin: EdgeInsets.all(5),
                                  width: deviceSize.width*0.2,
                                  child:
                                  Text("Casual",style: TextStyle(color: Primary,fontSize: 12),),
                                ),

                              ):
                              selectedcasual?
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    shownoenglish=true;
                                    showcasual=true;
                                    showintermidiate=true;
                                    showfluent=true;

                                    selectednoenglish=false;
                                    selectedcasual=false;
                                    selectedintermidiate=false;
                                    selectedfluent=false;
                                    englishlevel="";
                                  });
                                },
                                child:
                                Container(
                                  decoration: new BoxDecoration(color: Colors.pink.shade200,border: Border.all(color:Primary,width: 1),borderRadius: BorderRadius.all(Radius.circular(25))),
                                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                  margin: EdgeInsets.all(5),
                                  width: deviceSize.width*0.3,
                                  child:
                                  new Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text("Casual",style: TextStyle(color: Primary,fontSize: 12),),

                                        Icon(Icons.highlight_off_sharp,size: 15,color: Colors.black,),

                                      ]
                                  ),
                                ),):Container(),
                              ////////////// Intermediate
                              showintermidiate?
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    shownoenglish=false;
                                    showcasual=false;
                                    showintermidiate=false;
                                    showfluent=false;

                                    selectednoenglish=false;
                                    selectedcasual=false;
                                    selectedintermidiate=true;
                                    selectedfluent=false;
                                    englishlevel="Intermediate";
                                  });
                                },
                                child:
                                Container(
                                  decoration: new BoxDecoration(color: Colors.white,border: Border.all(color:Primary,width: 1),borderRadius: BorderRadius.all(Radius.circular(25))),
                                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                  margin: EdgeInsets.all(5),
                                  width: deviceSize.width*0.2,
                                  child:
                                  Text("Intermediate",style: TextStyle(color: Primary,fontSize: 12),),
                                ),

                              ):
                              selectedintermidiate?
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    shownoenglish=true;
                                    showcasual=true;
                                    showintermidiate=true;
                                    showfluent=true;

                                    selectednoenglish=false;
                                    selectedcasual=false;
                                    selectedintermidiate=false;
                                    selectedfluent=false;
                                    englishlevel="";
                                  });
                                },
                                child:
                                Container(
                                  decoration: new BoxDecoration(color: Colors.pink.shade200,border: Border.all(color:Primary,width: 1),borderRadius: BorderRadius.all(Radius.circular(25))),
                                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                  margin: EdgeInsets.all(5),
                                  width: deviceSize.width*0.3,
                                  child:
                                  new Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text("Intermediate",style: TextStyle(color: Primary,fontSize: 12),),
                                        Icon(Icons.highlight_off_sharp,size: 15,color: Colors.black,),

                                      ]
                                  ),
                                ),):Container(),
                              ////////////// Expert
                              showfluent?
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    shownoenglish=false;
                                    showcasual=false;
                                    showintermidiate=false;
                                    showfluent=false;

                                    selectednoenglish=false;
                                    selectedcasual=false;
                                    selectedintermidiate=false;
                                    selectedfluent=true;
                                    englishlevel="Expert";
                                  });
                                },
                                child:
                                Container(
                                  decoration: new BoxDecoration(color: Colors.white,border: Border.all(color:Primary,width: 1),borderRadius: BorderRadius.all(Radius.circular(25))),
                                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                  margin: EdgeInsets.all(5),
                                  width: deviceSize.width*0.2,
                                  child:
                                  Text("Expert",style: TextStyle(color: Primary,fontSize: 12),),
                                ),

                              ):
                              selectedfluent?
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    shownoenglish=true;
                                    showcasual=true;
                                    showintermidiate=true;
                                    showfluent=true;

                                    selectednoenglish=false;
                                    selectedcasual=false;
                                    selectedintermidiate=false;
                                    selectedfluent=false;
                                    englishlevel="";
                                  });
                                },
                                child:
                                Container(
                                  decoration: new BoxDecoration(color: Colors.pink.shade200,border: Border.all(color:Primary,width: 1),borderRadius: BorderRadius.all(Radius.circular(25))),
                                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                  margin: EdgeInsets.all(5),
                                  width: deviceSize.width*0.3,
                                  child:
                                  new Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text("Expert",style: TextStyle(color: Primary,fontSize: 12),),
                                        Icon(Icons.highlight_off_sharp,size: 15,color: Colors.black,),

                                      ]
                                  ),
                                ),):Container(),
                            ]
                        ),
                        // Text('Job Title',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),),
                        padding: const EdgeInsets.all(5.0),
                      ),
                      //////////////////////////////////////////////////////////////////////////////////////////////////////////
                      new Padding(
                        child:
                        Text.rich(
                            TextSpan(
                                text: 'Job Skills',
                                style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: ' (optional)',
                                    style: LatinFonts.aBeeZee(fontSize: 12, fontWeight: FontWeight.w200,color:Colors.grey),
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
                          child:
                          ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Container(
                                child: Row(
                                  children: [ Checkbox(
                                    value: selectedIndexes.contains(duplicateJobSkill[index].name),
                                    onChanged: (bool? value) {
                                      if(selectedIndexes.contains(duplicateJobSkill[index].name)) {
                                        selectedIndexes.remove(duplicateJobSkill[index].name); // unselect
                                      } else {
                                        selectedIndexes.add(duplicateJobSkill[index].name);  // select
                                      }
                                      setState(() {});
                                    },
                                    checkColor: Colors.greenAccent,
                                    activeColor: Colors.black,
                                  ), Text(
                                    "${duplicateJobSkill[index].name}",
                                    style: TextStyle(fontSize: 17.0),
                                  ),  ],
                                ),
                              );
                            },
                            itemCount: duplicateJobSkill.length,
                          )
                      ):Text("No Specific Job skill available."),
                      //////////////////////////////////// Address
                      new Padding(
                        child:
                        Text.rich(
                            TextSpan(
                                text: 'Full Interview Address',
                                style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: '*',
                                    style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold,color:Colors.red),
                                  )
                                ]
                            )
                        ),
                        // Text('Job Title',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),),
                        padding: const EdgeInsets.all(10.0),
                      ),
                      Container(
                        width:deviceSize.width*0.9,
                        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10.0),
                        child:
                        TextField(
                          keyboardType: TextInputType.multiline,
                          onChanged: (value) {
                            setState(() {
                              address=value;
                            });

                          },
                          controller: addressController,
                          decoration: InputDecoration(
                            isDense:true,
                              filled: true,
                              fillColor: Colors.white,
                              // labelText:"Number of Openings",
                              hintText:"Enter Interview Address",
                             // prefixIcon: Icon(Icons.numbers),
                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                        ),
                      ),
////////////////////////////////////////////////////////////Job Description
                      new Padding(
                        child:
                        Text.rich(
                            TextSpan(
                                text: 'Job Description',
                                style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: '*',
                                    style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold,color:Colors.red),
                                  )
                                ]
                            )
                        ),
                        // Text('Job Title',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),),
                        padding: const EdgeInsets.all(10.0),
                      ),
                      Container(
                        width:deviceSize.width*0.9,
                        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10.0),
                        child:
                        TextField(
                          scrollPadding: EdgeInsets.all(20.0),
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          autofocus: true,
                          onChanged: (value) {
                            setState(() {
                              Jobdescription=value;
                            });

                          },
                          controller: JobdescriptionController,
                          decoration: InputDecoration(
                              isDense:true,
                              filled: true,
                              fillColor: Colors.white,
                              // labelText:"Number of Openings",
                              hintText:"Enter Additional Details",
                              // prefixIcon: Icon(Icons.numbers),
                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                        ),
                      ),
                      ///////////////////////////// Warning

                      new Padding(
                        child:
                        Text.rich(
                            TextSpan(
                                text: 'Communication Preferences',
                                style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: '*',
                                    style: LatinFonts.aBeeZee(fontSize: 16, fontWeight: FontWeight.bold,color:Colors.red),
                                  )
                                ]
                            )
                        ),
                        // Text('Job Title',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),),
                        padding: const EdgeInsets.all(10.0),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          child:
                          Row(
                            children: [
                              Checkbox(
                                value: this.allowvalue,
                                onChanged: (bool? value) {
                                  setState(() {
                                    this.allowvalue = value!;
                                    if(value==true)
                                    {
                                      callallow="Allow";
                                    }
                                    else
                                    {
                                      callallow="Not Allow";

                                    }
                                  });
                                },
                              ),
                              Container(
                                width: deviceSize.width*0.8,
                                child: Text(' Allow candidates to call between 10:00am - 7:00pm on +91'+phone,style: LatinFonts.aBeeZee(fontSize: 10, fontWeight: FontWeight.bold),),

                              )
                            ],
                          )
                        //Checkbox
                      ),

                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          child:
                          Row(
                            children: [
                              Checkbox(
                                value: this.optin,
                                onChanged: (bool? value) {
                                  setState(() {
                                    this.optin = value!;
                                    if(value==true)
                                    {
                                      updateoptin="optin";
                                    }
                                    else
                                    {
                                      updateoptin="optout";

                                    }
                                  });
                                },
                              ),
                              Column(
                                children: [
                                  Container(
                                    width: deviceSize.width*0.8,
                                    child:
                                    Text(' Receive updates on WhatsApp from Aap Jobs',style: LatinFonts.aBeeZee(fontSize: 10, fontWeight: FontWeight.bold),),
                                  ),
                                  Container(
                                    width: deviceSize.width*0.8,
                                    child:
                                    Text('( You can opt-out anytime from the profile section )',style: LatinFonts.aBeeZee(fontSize: 10,color: Colors.grey),),
                                  ),
                                ],
                              )

                            ],
                          )
                        //Checkbox
                      ),

                      new Padding(
                        child:
                        Container(
                          width:deviceSize.width*0.9,
                            decoration: new BoxDecoration(color: Colors.yellow.shade100,border: Border.all(color:Colors.yellowAccent,width: 1),borderRadius: BorderRadius.all(Radius.circular(5))),
                            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10.0),
                          child:
                          Row(
                            children: [
                              Icon(Icons.warning_amber,size: 20,color: Colors.yellow,),
                              Container(
                                width:deviceSize.width*0.7,
                                padding: EdgeInsets.only(left: 10),
                                child:
                                Text.rich(
                                    TextSpan(
                                        text: 'Important',
                                        style: LatinFonts.aBeeZee(fontSize: 8, fontWeight: FontWeight.bold),
                                        children: <InlineSpan>[
                                          TextSpan(
                                            text: 'Your account will be blocked & legal action will be taken incase of fraudulent activity.',
                                            style: LatinFonts.aBeeZee(fontSize: 8),
                                          )
                                        ]
                                    )
                                ),
                              )
                            ],
                          )
                        ),
                        // Text('Job Title',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),),
                        padding: const EdgeInsets.all(10.0),
                      ),
                      ////////////////////////////////////////////// Post Job Button
                      new Padding(
                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _isLoading?
                            CircularProgressIndicator()
                                :
                            ElevatedButton(
                              child: widget.repost?Text('Post Job'): Text('Update Job'),
                              onPressed: () {
                                _savedata();
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

                        // Text('Job Title',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),),
                        padding: const EdgeInsets.all(10.0),
                      ),
                    ],
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

}



