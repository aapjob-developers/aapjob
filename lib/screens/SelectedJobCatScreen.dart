import 'dart:convert';
import 'dart:io';
import 'dart:developer';

import 'package:Aap_job/localization/language_constrants.dart';
import 'package:Aap_job/main.dart';
import 'package:Aap_job/models/CatJobsModel.dart';
import 'package:Aap_job/models/ContentModel.dart';
import 'package:Aap_job/models/categorymm.dart';
import 'package:Aap_job/models/categorywithjob.dart';
import 'package:Aap_job/models/common_functions.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:Aap_job/providers/content_provider.dart';
import 'package:Aap_job/providers/notification_provider.dart';
import 'package:Aap_job/screens/JobListOfCategory.dart';
import 'package:Aap_job/screens/JobLiveDataScreen.dart';
import 'package:Aap_job/screens/JobtypeSelect.dart';
import 'package:Aap_job/screens/NotificationScreen.dart';
import 'package:Aap_job/screens/SearchScreen.dart';
import 'package:Aap_job/screens/SupportScreen.dart';
import 'package:Aap_job/screens/getjobdetails.dart';
import 'package:Aap_job/screens/homepage.dart';
import 'package:Aap_job/screens/notification/notification_screen.dart';
import 'package:Aap_job/screens/widget/ChangeLocationScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:Aap_job/screens/widget/VideoPopup.dart';
import 'package:Aap_job/models/JobsModel.dart';
import 'package:Aap_job/models/category.dart';
import 'package:Aap_job/providers/category_provider.dart';
import 'package:Aap_job/screens/JobDetailScreen.dart';
import 'package:Aap_job/screens/basewidget/VideoPlayerScreen.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:Aap_job/utill/dimensions.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:dio/dio.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:Aap_job/utill/date_converter.dart';

import '../providers/jobselect_category_provider.dart';
import '../providers/profile_provider.dart';

class SelectedJobCatScreen extends StatefulWidget {
  SelectedJobCatScreen({Key? key}) : super(key: key);
  @override
  _SelectedJobCatScreenState createState() => new _SelectedJobCatScreenState();
}

class _SelectedJobCatScreenState extends State<SelectedJobCatScreen> {
  SharedPreferences? sharedPreferences;
  final ScrollController _scrollController = ScrollController();
  bool jobselected=false;
  var _isLoading = false;
  final Dio _dio = Dio();
  final _baseUrl = AppConstants.BASE_URL;
  var apidata;
  bool _hasJobCat=false;
  var _selectedCategoryList = <CategoryWithJob>[];
  var categorylist = <CategoryWithJob>[];
  var items = <CategoryWithJob>[];


  initState() {
    initializePreference().whenComplete((){
    });
    super.initState();

  }
  Future<void> initializePreference() async{
    await _loadData(context,false,);
  }
  showerror ()
  {
    CommonFunctions.showInfoDialog("You Can Select Maximum 5 Job Category or Minimum 1 Job Category.", context);
  }

  TextEditingController editingController = TextEditingController();
  Future<void> _loadData(BuildContext context, bool reload,) async {
    //  await Provider.of<JobServiceCategoryProvider>(context, listen: false).getCategoryList(reload, context);
    if(Provider.of<CategoryProvider>(context, listen: false).NewcategoryList.isNotEmpty){
      setState(() {
        categorylist.addAll(Provider.of<CategoryProvider>(context, listen: false).NewcategoryList);
        _selectedCategoryList.addAll(Provider.of<CategoryProvider>(context, listen: false).NewSelectedcategoryList);
        items.addAll(categorylist);
        _hasJobCat=true;
      });
    }
  }
  void filterSearchResults(String query) {
    List<CategoryWithJob> dummySearchList = <CategoryWithJob>[];
    dummySearchList.addAll(Provider.of<CategoryProvider>(context, listen: false).NewcategoryList);
    if(query.isNotEmpty) {
      List<CategoryWithJob> dummyListData = <CategoryWithJob>[];
      dummySearchList.forEach((item) {
        if(item.name!.toUpperCase().contains(query.toUpperCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
        print("searched : ${items.length.toString()}");
        print("provider list : ${Provider.of<CategoryProvider>(context, listen: false).NewcategoryList.length.toString()}");
        print("catllist : ${categorylist.length.toString()}");
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(Provider.of<CategoryProvider>(context, listen: false).NewcategoryList);
        print("all : ${items.length.toString()}");
        print("all : ${Provider.of<CategoryProvider>(context, listen: false).NewcategoryList.length.toString()}");
        print("all : ${categorylist.length.toString()}");
      });
    }

  }

  adcategory(String categoryid,String perma, String type, CategoryWithJob _category) async {
    if(type=="remove")
    Provider.of<CategoryProvider>(context, listen: false).NewSelectedcategoryList.remove(_category);
    else
      Provider.of<CategoryProvider>(context, listen: false).NewSelectedcategoryList.add(_category);
    try {
      Response response = await _dio.get(_baseUrl + AppConstants.UPDATE_CATEGORY_URI+categoryid+"&userid="+Provider.of<AuthProvider>(context, listen: false).getUserid());
      apidata = response.data;
      //print('rev :'+apidata.toString());
      if(apidata.toString().contains("added"))
      {
        if(perma!=null)
        {FirebaseMessaging.instance.subscribeToTopic(perma); print('add cate : ${perma}'); }
      }
      else if(apidata.toString().contains("deleted"))
      {
        if(perma!=null)
          FirebaseMessaging.instance.unsubscribeFromTopic(perma);
        print('del cate : ${perma}');
      }
      _selectedCategoryList.addAll(Provider.of<CategoryProvider>(context, listen: false).NewSelectedcategoryList);
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
    return Container(
        decoration: new BoxDecoration(color: Primary),
        child:
        SafeArea(child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Please select atleast One Job Category to continue",
                  style: new TextStyle(
                      color: Colors.white, fontSize: 20),
                  textAlign: TextAlign.center,),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      filterSearchResults(value);
                    },
                    controller: editingController,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.black),
                        filled: true,
                        hintText: "Search Your Job Category",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                  ),
                ),
                _hasJobCat?
                Expanded(
                  child:
                  ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: items.length,
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      CategoryWithJob _category = items[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.greenAccent),
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white
                        ),
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                title:
                                new Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width:deviceSize.width*0.5,
                                        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                        child: Text(_category.name!, maxLines:3,overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold), ),
                                      ),
                                      Container(
                                        height:50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 2,),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: FadeInImage(
                                            placeholder: AssetImage('assets/images/appicon.png'),
                                            image: NetworkImage(AppConstants.BASE_URL+_category.icon!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ]

                                ),
                                // Text(_category.name),
                                //  value: _selectedCategoryList.contains(_category.id),
                                value: _category.selected,
                                onChanged: (context) {
                                  if(_selectedCategoryList.where((element) => element.id==_category.id).isNotEmpty&&_selectedCategoryList.length==1)
                                  {
                                    showerror();
                                  }
                                  else if(_selectedCategoryList.where((element) => element.id==_category.id).isNotEmpty)
                                  {
                                    log("in contain");
                                    setState(() {
                                      _category.selected=false;
                                      log("in contain2");
                                    });
                                    FirebaseMessaging.instance.unsubscribeFromTopic(_category.perma!);
                                    adcategory(_category.id.toString(),_category.perma.toString(),"remove",_category);// unselect
                                  } else if(_selectedCategoryList.length<5)
                                  {
                                    log("in compare");
                                    print("perma-${_category.perma}");
                                    FirebaseMessaging.instance.subscribeToTopic(_category.perma!);
                                    setState(() {
                                      _category.selected = true;
                                    });
                                    adcategory(_category.id.toString(),_category.perma.toString(),"add",_category);// un// select
                                  }
                                  else
                                  {
                                    showerror();
                                  }
                                  print(_selectedCategoryList.toString());

                                },
                                controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
                              ),
                            )
                          ],
                        ),
                      );

                    },
                  ),
                ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                Container(
                  width: deviceSize.width,
                  padding: EdgeInsets.all(3.0),
                  child:
                  new Padding(
                    child:
                    _selectedCategoryList.isNotEmpty?
                    new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          if (_isLoading)
                            CircularProgressIndicator()
                          else
                            ElevatedButton(
                              child: const Text('Exit'),
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                    builder: (context) => HomePage ()), (
                                    route) => false);                              },
                              style: ElevatedButton.styleFrom(
                                  minimumSize: new Size(deviceSize.width * 0.8,20),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  primary: Colors.amber,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  textStyle:
                                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                            ),

                        ]

                    ):new Row(),
                    padding: const EdgeInsets.all(10.0),
                  ),
                ),
                //),
              ],
            ),
          ),
        ),)
    );
  }
}


