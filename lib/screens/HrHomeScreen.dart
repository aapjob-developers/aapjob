
import 'package:Aap_job/localization/language_constrants.dart';
import 'package:Aap_job/models/JobsListModel.dart';
import 'package:Aap_job/providers/HrJobs_provider.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:Aap_job/providers/content_provider.dart';
import 'package:Aap_job/providers/notification_provider.dart';
import 'package:Aap_job/providers/profile_provider.dart';
import 'package:Aap_job/screens/EditJobLoading.dart';
import 'package:Aap_job/screens/JobAppliedCandidatesList.dart';
import 'package:Aap_job/screens/LiveDataScreen.dart';
import 'package:Aap_job/screens/NotificationScreen.dart';
import 'package:Aap_job/screens/myloginscreen.dart';
import 'package:Aap_job/screens/selectPlansScreen.dart';
import 'package:Aap_job/screens/splashscreen.dart';
import 'package:Aap_job/screens/widget/ChangeLocationScreen.dart';
import 'package:Aap_job/screens/widget/PlanDetailPopup.dart';
import 'package:Aap_job/screens/widget/VideoPopup.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:Aap_job/models/common_functions.dart';
import 'package:Aap_job/screens/EditJobPostScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:Aap_job/models/JobsModel.dart';
import 'package:Aap_job/screens/JobPostScreen.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'package:dio/dio.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../models/CurrentPlanModel.dart';
import '../providers/cities_provider.dart';
import '../providers/jobselect_category_provider.dart';
import '../providers/jobtitle_provider.dart';
import 'HrSupportScreen.dart';

class HrHomeScreen extends StatefulWidget {
  HrHomeScreen({Key? key}) : super(key: key);
  @override
  _HrHomeScreenState createState() => new _HrHomeScreenState();
}

class _HrHomeScreenState extends State<HrHomeScreen> {
  SharedPreferences? sharedPreferences;
  final Dio _dio = Dio();
  final _baseUrl = AppConstants.BASE_URL;
  var apidata;
  int activejob=0;
  String planname="",plantype="";
  String detail1="",detail2="",detail3="",detail4="",detail5="",detail6="";
  CurrentPlanModel currentplan= new CurrentPlanModel();
  final DateFormat formatter = DateFormat('dd-MMM-yyyy');
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  final _currentDate = DateTime.now();
  String dropdownvalue = 'Select A Reason';
  String content =AppConstants.BASE_URL+"/uploads/users/1.png";
  var _isLoading=false;


  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    _loadData(context, false);
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    if(mounted)
      setState(() {
      });
    _refreshController.loadComplete();
  }

  @override
  initState() {
    initializePreference().whenComplete((){
      setState(() {
        planname= sharedPreferences!.getString("HrplanName")?? "Starter";
        plantype= sharedPreferences!.getString("HrplanType")?? "r";
        if(plantype=="r")
          {
            detail1= sharedPreferences!.getString("RtotalJobPost")?? "r";
            detail2= sharedPreferences!.getString("RProfilePerApp")?? "r";
            detail3= sharedPreferences!.getString("RDays")?? "r";
            detail4= sharedPreferences!.getString("RType")?? "r";
          }
        else
          {
            detail1= sharedPreferences!.getString("CtotalJobPost")?? "r";
            detail2= sharedPreferences!.getString("Cperdaylimit")?? "r";
            detail4= sharedPreferences!.getString("CtotalResumes")?? "r";
            detail3= sharedPreferences!.getString("CDays")?? "r";
          }
        detail5= sharedPreferences!.getString("HrPurchaseDate")?? "r";

      });
     // getHrCurrentPlan();

    });

    super.initState();
  }

  checkapplied() async {
    try {
      Response response = await _dio.get(_baseUrl + AppConstants.CHECK_HR_PROFILE_STATUS_URI+Provider.of<AuthProvider>(context, listen: false).getUserid());
      print('Applied check : ${response.data}');
      if (response.statusCode == 200)
      {
        if(response.data.toString()=="5")
          {
            Provider.of<AuthProvider>(context, listen: false).clearSharedData().then((condition) {
              FirebaseMessaging.instance.deleteToken();
              Provider.of<AuthProvider>(context,listen: false).clearSharedData();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SplashScreen()), (route) => false);
            });
          }
        else
          {
            setState(() {
              sharedPreferences!.setString("profilestatus",response.data.toString());
            });
          }
      }
      else {
        print('${response.statusCode} ${response.data}');
        CommonFunctions.showErrorDialog("Error in Connection", context);
        setState(() {
          _isLoading=false;
        });
      }
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      setState(() {
        _isLoading=false;
      });
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

  Future<void> initializePreference() async{
    this.sharedPreferences = await SharedPreferences.getInstance();
    _loadData(context, false);
  }

  Future<void> _loadData(BuildContext context, bool reload) async {
    await Provider.of<HrJobProvider>(context, listen: false).initgetHrHomeJobsList(Provider.of<AuthProvider>(context, listen: false).getUserid(), context).then((bool isSuccess){
      Provider.of<NotificationProvider>(context, listen: false).initNotificationList2(context,Provider.of<AuthProvider>(context, listen: false).getUserid());
      Provider.of<HrJobProvider>(context, listen: false).initgetReasonList(context);
      checkapplied();
    });
  }
///////////////////////////////////

  Future<void> _showSimpleDialog(String jobid) async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog( // <-- SEE HERE
            title: const Text('Are you sure to close this job'),
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20,),
                decoration: new BoxDecoration(color: Colors.white),
                width: MediaQuery.of(context).size.width * 0.6,
                child:
                StatefulBuilder(
                    builder: (BuildContext context, StateSetter dropDownState){
          return Consumer<HrJobProvider>(builder: (_, provider, __) {
                      return DropdownButton<String>(
                        focusColor: Colors.white,
                        value: dropdownvalue,
                        underline: Container(),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          // Array list of items
                          items: provider.reasonList.map((String item) {
                            return DropdownMenuItem(
                              value: item,
                              child:
                              Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Lottie.asset(
                                        'assets/lottie/arrowright.json',
                                        height: MediaQuery.of(context).size.width*0.05,
                                        width: MediaQuery.of(context).size.width*0.05,
                                        animate: true,),
                                      SizedBox(width: 3,),
                                      Text(item,style: LatinFonts.aBeeZee(fontSize: 10,fontWeight: FontWeight.bold)),
                                    ]

                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            dropDownState(() {
                              dropdownvalue = newValue!;
                            });
                            print(newValue);
                          },
                      );
          },
          );
                    }
                ),
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(10.0),
                onPressed: () {
                  if(dropdownvalue!='Select A Reason') {
                    closeJob(jobid,dropdownvalue);
                    CommonFunctions.showSuccessToast("done");
                  }
                  else
                    {
                      CommonFunctions.showInfoDialog("Please select a reason before closing job", context);
                    }
                },
                child:
              Container(
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                child: Text('Yes I want to close this job',style:LatinFonts.aBeeZee(color:Colors.red),),
              ),


              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        });
  }

  bool checkjoballowed()
  {
    final planexpiredate = DateTime.parse(detail5).add(Duration(days: int.parse(detail3)));
    if(activejob>int.parse(detail1))
    {
      return false;
    }
    else
      {
        if(_currentDate.isAfter(planexpiredate))
            return false;
        else
          return true;
      }
  }

  postajob()
  {
    if(Provider.of<AuthProvider>(context, listen: false).getProfileStatus()!="0")
    {
      if(checkjoballowed()) {
        setState(() {
          _isLoading=false;
        });
        Navigator.push(context, MaterialPageRoute( builder: (context) => JobPostScreen()));
      }
      else
      {
        setState(() {
          _isLoading=false;
        });

        PlanDetailPopup(
            title: planname,
            message: plantype,
            detail1: detail1,
            detail2: detail2,
            detail3: detail3,
            detail4: detail4,
            detail5: detail5,
            rightButton: "Cancel",
            leftButton: "Upgrade"
        ).show(context);
      };
    }
    else
    {
      setState(() {
        _isLoading=false;
      });
      CommonFunctions.showInfoDialog("Your Account is not Approved yet.", context);
    }
  }

  closeJob(String jobid,String dropdownvalue) async {
    try {
      Response response = await _dio.get(_baseUrl + AppConstants.CLOSE_JOBS_URI+jobid+"&reason="+dropdownvalue);
      String closejob = response.data;
      if(closejob.toString()=="success")
        {
          Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context)=> HrHomeScreen()));
        }
      else
        {
          CommonFunctions.showErrorDialog("Error in Updating Job"+closejob, context);
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

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery
        .of(context)
        .size;
    return Container(
        decoration: new BoxDecoration(color: Primary),
        child:
        SafeArea(child:
              Scaffold(
      body:
    Scaffold(
    appBar: AppBar(
      automaticallyImplyLeading: false,
       toolbarHeight: deviceSize.height*0.2,
    centerTitle: true,
    elevation: 0.5,
    backgroundColor: Colors.white,
    titleTextStyle: TextStyle(color: Colors.black),
    title:
    Column(
      children: [
        Topbar(),
        new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap:(){
                  VideoPopup(title:Provider.of<ContentProvider>(context, listen: false).contentList[3].internalVideoSrc!).show(context);
                },
                child:
                CachedNetworkImage(
                  imageUrl: AppConstants.BASE_URL+Provider.of<ContentProvider>(context, listen: false).contentList[3].imgSrc!,
                  width: MediaQuery.of(context).size.width*0.9,
                  height: MediaQuery.of(context).size.width*0.2,
                  placeholder: (context, url) => Image.asset('assets/images/no_data.png'),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                // FadeInImage.assetNetwork(
                //   width: MediaQuery.of(context).size.width*0.9,
                //   height: MediaQuery.of(context).size.width*0.2,
                //   placeholder: 'assets/images/no_data.png',
                //   image:AppConstants.BASE_URL+Provider.of<ContentProvider>(context, listen: false).contentList[3].imgSrc,
                //   fit: BoxFit.contain,
                // ),
              )
            ]),

      ],
    ),
    ),
    body:
    SmartRefresher(
    enablePullDown: true,
    enablePullUp: false,
    header: WaterDropHeader(),
    footer: CustomFooter(
    builder: (BuildContext context,LoadStatus? mode){
    Widget body ;
    if(mode==LoadStatus.idle){
    body =  Text("pull up load");
    }
    else if(mode==LoadStatus.loading){
    body =  CupertinoActivityIndicator();
    }
    else if(mode == LoadStatus.failed){
    body = Text("Load Failed!Click retry!");
    }
    else if(mode == LoadStatus.canLoading){
    body = Text("release to load more");
    }
    else{
    body = Text("No more Data");
    }
    return Container(
    height: 55.0,
    child: Center(child:body),
    );
    },
    ),
    controller: _refreshController,
    onRefresh: _onRefresh,
    onLoading: _onLoading,
    child:
Container(
  margin: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
  child:
  Column(
    children: [
      Text(getTranslated('PULL_DOWN_TO_REFRESH', context)!),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              PlanDetailPopup(
                  title: planname,
                  message: plantype,
                  detail1: detail1,
                  detail2: detail2,
                  detail3: detail3,
                  detail4: detail4,
                  detail5: detail5,
                  rightButton: "Cancel",
                  leftButton: "Upgrade"
              ).show(context);
            },
            child:
          Container(
            width: deviceSize.width*0.3,
            padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
            decoration: new BoxDecoration(gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color.fromRGBO(255, 243, 59, 1.0),
                  Color.fromRGBO(242, 101, 34, 1.0),
                ]),
               // border: Border.all(color:Color.fromRGBO(255, 151, 0, 1.0),width: 2),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Column(children: [
                Text.rich(
                    TextSpan(
                        text: "Your Current Plan:",
                        style: LatinFonts.aBeeZee(fontSize: 8, fontWeight: FontWeight.bold, color:Colors.white),
                    )
                ),
              Text(planname,style: LatinFonts.aBeeZee(fontSize: 10, fontWeight: FontWeight.bold,color:Colors.white),),
              Text.rich(
                  TextSpan(
                    text: "( See full Plan details )",
                    style: LatinFonts.aBeeZee(fontSize: 6, fontWeight: FontWeight.bold, color:Colors.white),
                  )
              ),
            ],),
          ),),
            Container(
              width: deviceSize.width*0.3,
              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
              decoration: new BoxDecoration(color: Primary,border: Border.all(color:Primary,width: 2),borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Column(children: [
                Text.rich(
                    TextSpan(
                      text: "Total Active Jobs:",
                      style: LatinFonts.aBeeZee(fontSize: 8, fontWeight: FontWeight.bold, color:Colors.white),
                    )
                ),
                Text("${Provider.of<HrJobProvider>(context, listen: false).currentplanactivejobs.toString()} Jobs",style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold,color:Colors.white),),
              ],),
            ),
          GestureDetector(
            onTap: (){
              Navigator.push(context,  MaterialPageRoute(builder: (context)=> SelectPlansScreen()));
            },
            child: Lottie.asset(
              'assets/lottie/upgrade.json',
              //height: MediaQuery.of(context).size.width*0.15,
              width: MediaQuery.of(context).size.width*0.3,
              animate: true,),
          ),
      ],),
    Consumer<HrJobProvider>(
    builder: (context,hrJobProvider, child) {
      List<JobsListModel> myjobsList=hrJobProvider.jobsList;
      return hrJobProvider.jobsList.length == 0 ?
      Container( child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height*0.2,),
          Text(getTranslated("NO_JOB_POST", context)!, style: LatinFonts.aBeeZee(fontSize: 18, color:Primary),textAlign: TextAlign.center,),
          Padding(padding: EdgeInsets.all(20),
            child:
            _isLoading?
            CircularProgressIndicator()
                :
            ElevatedButton(
              child: const Text('Post a job Now'),
              onPressed: () {
                setState(() {
                  _isLoading=true;
                });
                postajob();
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: new Size(deviceSize.width * 0.5,20), backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  textStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),)
      :
      Expanded(
        child: ListView.builder(
          primary: false,
        //  controller: _scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: myjobsList.length,
          // separatorBuilder: (context, index) {
          //   return Divider(height: 1,);
          // },
          itemBuilder: (context, index) {
            JobsListModel job = myjobsList[index];
            return
              Container(width: MediaQuery.of(context).size.width * 0.9,
                decoration: new BoxDecoration(boxShadow: [new BoxShadow(
                  color: Color.fromRGBO(00, 132, 122, 1.0),
                  blurRadius: 5.0,
                ),
                ],
                    color: Color.fromRGBO(00, 132, 122, 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(5),
                child:
                Column(
                  children: [
                    new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Container(width: deviceSize.width * 0.6,
                            padding: EdgeInsets.all(8),
                            child: new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: <Widget>[
                                        new Container(
                                          padding: EdgeInsets.all(2.0),
                                          margin: EdgeInsets.only(bottom: 5.0),
                                          decoration: new BoxDecoration(
                                              color:  Color.fromARGB(
                                                  255, 224, 38, 7),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0))),
                                          width: deviceSize.width * 0.32,
                                          child:
                                          Text("Created on " + formatter.format(job.createdAt!),
                                            style: LatinFonts.aBeeZee(
                                                color: Colors.white,
                                                fontSize: 8,
                                                fontWeight: FontWeight.w200,
                                                fontStyle: FontStyle.italic),
                                            textAlign: TextAlign.center,),
                                        ),

                                        SizedBox(width: 3,),
                                        new Container(
                                          padding: EdgeInsets.all(2.0),
                                          margin: EdgeInsets.only(bottom: 5.0),
                                          decoration: new BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0))),
                                          width: deviceSize.width * 0.2,
                                          child:
                                          Text(
                                            "views : " + job.views.toString(),
                                            style: LatinFonts.aBeeZee(
                                                color: Colors.black,
                                                fontSize: 8,
                                                fontWeight: FontWeight.w200,
                                                fontStyle: FontStyle.italic),
                                            textAlign: TextAlign.center,),
                                        ),
                                      ]
                                  ),
                                  new Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: <Widget>[
                                        new Container(
                                        //  padding: EdgeInsets.symmetric(horizontal: 8),
                                          child:
                                          Text('${job.jobRole}',
                                            style: LatinFonts.aBeeZee(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),),
                                        ),
                                      ]
                                  ),
                                  new Container(
                                    padding: EdgeInsets.all(3),
                                    child:
                                    Text('${job.companyName}',
                                      style: LatinFonts.aBeeZee(fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),),
                                  ),
                                  new Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: <Widget>[
                                        new Image.asset(
                                          'assets/images/opening.png',
                                          fit: BoxFit.contain,
                                          height: 20,
                                          width: 20,
                                        ),
                                        new Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child:
                                          Text('Openings : ${job.openingsNo}',
                                            style: LatinFonts.aBeeZee(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),),
                                        ),
                                      ]),
                                  new Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: <Widget>[
                                        new Image.asset(
                                          'assets/images/city.png',
                                          fit: BoxFit.contain,
                                          height: 15,
                                          width: 15,
                                        ),
                                        new Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child:
                                          Row(
                                            children: [
                                              Text('${job.jobLocation} ,',
                                                style: LatinFonts.aBeeZee(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),maxLines: 2,),

                                            ],
                                          ),
                                        ),
                                      ]),
                                  new Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: <Widget>[
                                      SizedBox(width: 15,),
                                        new Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child:
                                          Row(
                                            children: [
                                              Text('${job.jobcity}',
                                                style: LatinFonts.aBeeZee(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),maxLines: 2,),

                                            ],
                                          ),
                                        ),
                                      ]),
                                  Container(
                                    child: Divider(
                                      color: Primary, thickness: 2,),
                                  ),
                                  new Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: <Widget>[
                                        SizedBox(width: 2,),
                                      ]
                                  ),
                                ]
                            ),
                          ),
                          new Container(
                            // padding: EdgeInsets.all(5.0),
                            width: deviceSize.width * 0.25,
                            child:
                            Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      job.applied != 0 ?
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => JobAppliedCandidatesList(jobid: job.id!,jobrole: job.jobRole!,jobapplied:job.applied!)))
                                          :
                                      Container()
                                      ;
                                    },
                                    child: new Container(
                                      margin: EdgeInsets.only(top: 10.0),
                                      padding: EdgeInsets.all(5.0),
                                      decoration: new BoxDecoration(
                                          color: Color.fromRGBO(
                                              93, 0, 147, 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      width: deviceSize.width * 0.25,
                                      child:
                                      Text("${job.applied} Applied ",
                                        style: LatinFonts.aBeeZee(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w200,
                                            fontStyle: FontStyle.italic),
                                        textAlign: TextAlign.center,),
                                    ),
                                  ),
                                  // job.status == "open" ?
                                  ElevatedButton(
                                    child:
                                    Row(
                                        children: [
                                          new Image.asset(
                                            'assets/images/editjob.png',
                                            fit: BoxFit.contain,
                                            width: 20,
                                          ),
                                          const Text('Edit Job',style:TextStyle(fontSize: 12)),
                                        ]
                                    ),

                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) =>
                                              EditJobLoading(jobid: job.id!, repost: false,)));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: new Size(
                                            deviceSize.width * 0.2, 0), backgroundColor: Color.fromRGBO(
                                            255, 151, 0, 1.0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                10)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        textStyle:
                                        const TextStyle(fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  // ElevatedButton(
                                  //   child:
                                  //   Row(
                                  //       children: [
                                  //         new Image.asset(
                                  //           'assets/images/editjob.png',
                                  //           fit: BoxFit.contain,
                                  //           width: 20,
                                  //         ),
                                  //         const Text('Repost Job'),
                                  //       ]
                                  //   ),
                                  //
                                  //   onPressed: () {
                                  //     Navigator.push(context, MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             EditJobPostScreen(
                                  //               job: job, repost: true,)));
                                  //   },
                                  //   style: ElevatedButton.styleFrom(
                                  //       minimumSize: new Size(
                                  //           deviceSize.width * 0.2, 0),
                                  //       shape: RoundedRectangleBorder(
                                  //           borderRadius: BorderRadius.circular(
                                  //               10)),
                                  //       padding: const EdgeInsets.symmetric(
                                  //           horizontal: 5, vertical: 5),
                                  //       primary: Color.fromRGBO(
                                  //           255, 151, 0, 1.0),
                                  //       textStyle:
                                  //       const TextStyle(fontSize: 14,
                                  //           fontWeight: FontWeight.bold)),
                                  // ),
                                  // job.status == "open" ?
                                  ElevatedButton(
                                    child:
                                    Row(
                                        children: [
                                          new Image.asset(
                                            'assets/images/closejob.png',
                                            fit: BoxFit.contain,
                                            width: 20,
                                          ),
                                          const Text('Close Job',style:TextStyle(fontSize: 12)),
                                        ]
                                    ),

                                    onPressed: () {
                                      _showSimpleDialog(job.id!);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: new Size(
                                            deviceSize.width * 0.2, 0), backgroundColor: Color.fromRGBO(192, 2, 0, 1.0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                15)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        textStyle:
                                        const TextStyle(fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ]
                            ),
                          ),
                        ]
                    ),
                    job.applied != 0 ?
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                JobAppliedCandidatesList(jobid: job.id!,jobrole: job.jobRole!,jobapplied:job.applied!)));
                      },
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: new BoxDecoration(color: Colors.amber,
                            borderRadius: BorderRadius.all(
                                Radius.circular(15.0))),
                        width: deviceSize.width * 0.5,
                        height: 30,
                        child:
                        Text(getTranslated('VIEW_ALL_APPLIED', context)!,
                          style: LatinFonts.aBeeZee(color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w200,
                              fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,),
                      ),
                    )
                        : Container(
                      padding: EdgeInsets.all(5.0),
                      decoration: new BoxDecoration(color: Colors.amber,
                          borderRadius: BorderRadius.all(
                              Radius.circular(15.0))),
                      width: deviceSize.width * 0.5,
                      height: 30,
                      child:
                      Text(getTranslated('No_CANDIDATES_APPLIED', context)!,
                        style: LatinFonts.aBeeZee(color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w200,
                            fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,),
                    ),
                  ],
                ),
              );
          },
        ),
      )

          ;
    }),
    ],
  )

),
    ),
    ),
                floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
                floatingActionButton:
                    _isLoading?
                        CircularProgressIndicator()
                        :
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            _isLoading=false;
                          });
                          postajob();
                        //  checkapplied();
                          //}
                        },
                      child:Lottie.asset(
                        'assets/lottie/add.json',
                        height: MediaQuery.of(context).size.width*0.2,
                        //width: MediaQuery.of(context).size.width*0.45,
                        animate: true,),
                    ),

    )
        ),
    );
  }
}


class Topbar extends StatelessWidget {
  Topbar({Key? key}) : super(key: key);

  String? Joblist, templist;
  SharedPreferences? sharedPreff;

  @override
  Widget build(BuildContext context) {
    final  deviceSize= MediaQuery.of(context).size;
    Stream<int> getnotificationcount() => Stream<int>.periodic(Duration(seconds: 1),(count)=>Provider.of<NotificationProvider>(context, listen: false).hr_noti_count!,);

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
                  Navigator.push(context,  MaterialPageRoute(builder: (context)=> ChangeLocationScreen(CurrentCity: Provider.of<AuthProvider>(context, listen: false).getHrCity(), CurrentLocation: Provider.of<AuthProvider>(context, listen: false).getHrLocality(), usertype: "HR")));
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
                            Text(Provider.of<AuthProvider>(context, listen: false).getHrLocality(),style:LatinFonts.aBeeZee(fontSize: 8),textAlign: TextAlign.center,),
                            Text(Provider.of<AuthProvider>(context, listen: false).getHrCity(),style: LatinFonts.aBeeZee(fontSize: 8, fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
                          ],
                        ),

                      ]
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(5.0),
                width: MediaQuery.of(context).size.width*0.25,
                child:
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                      Text(getTranslated("WELCOME", context)!,style: LatinFonts.aBeeZee(fontSize:12),),
                      Text(Provider.of<AuthProvider>(context, listen: false).getHrName(),style: LatinFonts.aBeeZee(fontSize:10,fontWeight: FontWeight.bold),),
                    ]),
              ),
              Container(
                padding: EdgeInsets.all(5.0),
                width: MediaQuery.of(context).size.width*0.4,
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context,  MaterialPageRoute(builder: (context)=> LiveDataScreen()));
                      },
                      child: Lottie.asset(
                        'assets/lottie/liveprofile.json',
                        height: MediaQuery.of(context).size.width*0.1,
                        width: MediaQuery.of(context).size.width*0.1,
                        animate: true,),
                    ),

                    SizedBox(width: MediaQuery.of(context).size.width*0.005,),
                    // new Image.asset(
                    //   'assets/images/map.png',
                    //   fit:BoxFit.contain,
                    //   width: MediaQuery.of(context).size.width*0.09,
                    // ),
                  GestureDetector(
                  onTap: (){
                  Navigator.push(context,  MaterialPageRoute(builder: (context)=> HrSupportScreen()));
                  },
                  child:
                    Lottie.asset(
                      'assets/lottie/support.json',
                      height: MediaQuery.of(context).size.width*0.15,
                      width: MediaQuery.of(context).size.width*0.15,
                      animate: true,),
             ),
                    SizedBox(width: MediaQuery.of(context).size.width*0.005,),
                    StreamBuilder<int>(
                        initialData: Provider.of<NotificationProvider>(context, listen: false).noti_count,
                        stream: getnotificationcount(),
                        builder: (context, snapshot) {
                          return new Stack(
                            children: <Widget>[
                              GestureDetector(
                                onTap: (){
                                  if(Provider.of<AuthProvider>(context, listen: false).setCurrentNotificationCount(snapshot.data!)) {
                                    print("data${snapshot.data}");
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) =>
                                            NotificationScreen2(
                                                Userid: Provider.of<
                                                    AuthProvider>(
                                                    context, listen: false)
                                                    .getUserid())));
                                  }
                                    },
                                child:
                                Lottie.asset(
                                  'assets/lottie/notification_bell.json',
                                  height: MediaQuery.of(context).size.width*0.1,
                                  width: MediaQuery.of(context).size.width*0.1,
                                  animate: true,),
                              ),
                              snapshot.data == Provider.of<AuthProvider>(context, listen: false).getCurrentNotificationCount() ?
                              new Container(): snapshot.data!<Provider.of<AuthProvider>(context, listen: false).getCurrentNotificationCount()?
                              new Container():
                              new Positioned(
                                right: 5,
                                top: 5,
                                child: new Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: new BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 10,
                                    minHeight: 10,
                                  ),
                                  child: Text(
                                    (snapshot.data!-Provider.of<AuthProvider>(context, listen: false).getCurrentNotificationCount()).toString(),
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
                        }
                    ),

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
