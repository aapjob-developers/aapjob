import 'dart:convert';
import 'package:Aap_job/data/chat/chat_auth_repository.dart';
import 'package:Aap_job/models/categorymm.dart';
import 'package:Aap_job/providers/jobselect_category_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:Aap_job/models/category.dart';
import 'package:Aap_job/models/common_functions.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import 'package:Aap_job/providers/category_provider.dart';
import 'package:Aap_job/providers/profile_provider.dart';
import 'package:Aap_job/screens/homepage.dart';
import 'package:Aap_job/screens/otpscreen.dart';
import 'package:Aap_job/utill/dimensions.dart';
import 'package:Aap_job/view/basewidget/animated_custom_dialog.dart';
import 'package:Aap_job/view/basewidget/my_dialog.dart';
import '../models/register_model.dart';
import 'package:dio/dio.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobTypeSelect extends StatefulWidget {
  JobTypeSelect({Key? key}) : super(key: key);
  @override
  _JobTypeSelectState createState() => new _JobTypeSelectState();
}


class _JobTypeSelectState extends State<JobTypeSelect> {
  bool jobselected=false;
  SharedPreferences? sharedPreferences;
  var _isLoading = false;
  final Dio _dio = Dio();
  final _baseUrl = AppConstants.BASE_URL;
  var apidata;
  bool _hasJobCat=false;

  static List<String> _selectedCategoryList = [];
  var categorylist = <CategoryModel>[];
  var items = <CategoryModel>[];
  // int _categorySelectedIndex=0;

  Future<void> _loadData(BuildContext context, bool reload,) async {
    await Provider.of<JobServiceCategoryProvider>(context, listen: false).getCategoryList(reload, context);
    if(Provider.of<JobServiceCategoryProvider>(context, listen: false).jobcategoryList.isNotEmpty){
      setState(() {
        categorylist.addAll(Provider.of<JobServiceCategoryProvider>(context, listen: false).jobcategoryList);
        items.addAll(categorylist);
        _hasJobCat=true;
      });
    }
  }
  TextEditingController editingController = TextEditingController();

  saveUserDataToFirebase() async {
    Provider.of<ChatAuthRepository>(context, listen: false).saveUserInfoToFirestore(
      username: Provider.of<AuthProvider>(context, listen: false).getName(),
      Phone: "+91"+Provider.of<AuthProvider>(context, listen: false).getMobile(),
      profileImage: Provider.of<AuthProvider>(context, listen: false).getprofileImage(),
      context: context,
      mounted: mounted,
      Jobcity: Provider.of<AuthProvider>(context, listen: false).getJobCity(),
    );
  }

  Future<void> _savejob() async {
    setState(() {
      _isLoading = true;
    });

     if(_selectedCategoryList.isNotEmpty)
       {
         if(_selectedCategoryList.length<6) {
           print("joblist: " + _selectedCategoryList.toString());
           await Provider.of<ProfileProvider>(context, listen: false)
               .updateUserInfo()
               .then((response) {
             if (response.isSuccess) {
               _submit();
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
           CommonFunctions.showInfoDialog("Please select Maximum 5 Job category to Continue",context);
         }
       }
     else
       {
         setState(() {
           _isLoading = false;
         });
         CommonFunctions.showInfoDialog("Please select atleast One Job category to Continue",context);
       }
  }

  _submit() async {
    String acctype="candidate";
      await Provider.of<AuthProvider>(context, listen: false).checkaccount(acctype,Provider.of<AuthProvider>(context, listen: false).getEmail(), Provider.of<AuthProvider>(context, listen: false).getAccessToken(), route);
  }

  route(bool isRoute, String route,String status, String errorMessage) async {
   // print(route);
    sharedPreferences!.setString("route", route);
    if (isRoute) {
      sharedPreferences!.setBool("loggedin", true);
      saveUserDataToFirebase();
    //  await Future.delayed(Duration(milliseconds: 5000));
      Navigator.pushReplacement( context,  MaterialPageRoute(builder: (context) => HomePage()),);
    } else {
      CommonFunctions.showErrorDialog(errorMessage,context);
      setState(() {
        _isLoading = false;
      });
    }

  }


  //
  // getJobCategories() async {
  //   categorylist.clear();
  //   try {
  //     Response response = await _dio.get(_baseUrl + AppConstants.CATEGORIES_URI+"?userid="+Provider.of<AuthProvider>(context, listen: false).getUserid());
  //     apidata = response.data;
  //     print('Job categories : ${apidata}');
  //     List<dynamic> data=json.decode(apidata);
  //     if(data.toString()=="[]")
  //     {
  //       categorylist=[];
  //       setState(() {
  //         _hasJobCat = false;
  //       });
  //     }
  //     else
  //     {
  //       data.forEach((cat) =>
  //           categorylist.add(CategoryModel.fromJson(cat)));
  //       data.forEach((cat) =>
  //           items.add(CategoryModel.fromJson(cat)));
  //       setState(() {
  //         _hasJobCat=true;
  //       });
  //     }
  //     print('Job Category List: ${categorylist}');
  //
  //   } on DioError catch (e) {
  //     // The request was made and the server responded with a status code
  //     // that falls out of the range of 2xx and is also not 304.
  //     if (e.response != null) {
  //       print('Dio error!');
  //       print('STATUS: ${e.response?.statusCode}');
  //       print('DATA: ${e.response?.data}');
  //       print('HEADERS: ${e.response?.headers}');
  //     } else {
  //       // Error due to setting up or sending the request
  //       print('Error sending request!');
  //       print(e.message);
  //     }
  //   }
  //
  // }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  getdata() async{
    this.sharedPreferences = await SharedPreferences.getInstance();
    await _loadData(context,false,);
  }


  Future<void> _savejobtype() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences!.setString("jobtypelist",json.encode(_selectedCategoryList));
  }
    showerror ()
    {
      CommonFunctions.showInfoDialog("You Can Select Maximum 5 Job Category", context);
    }

  void filterSearchResults(String query) {
    List<CategoryModel> dummySearchList = <CategoryModel>[];
    dummySearchList.addAll(Provider.of<JobServiceCategoryProvider>(context, listen: false).jobcategoryList);
    if(query.isNotEmpty) {
      List<CategoryModel> dummyListData = <CategoryModel>[];
      dummySearchList.forEach((item) {
        if(item.name.toUpperCase().contains(query.toUpperCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
        print("searched : ${items.length.toString()}");
        print("provider list : ${Provider.of<JobServiceCategoryProvider>(context, listen: false).jobcategoryList.length.toString()}");
        print("catllist : ${categorylist.length.toString()}");
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(Provider.of<JobServiceCategoryProvider>(context, listen: false).jobcategoryList);
        print("all : ${items.length.toString()}");
        print("all : ${Provider.of<JobServiceCategoryProvider>(context, listen: false).jobcategoryList.length.toString()}");
        print("all : ${categorylist.length.toString()}");
      });
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
                        CategoryModel _category = items[index];
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
                                          child: Text(_category.name, maxLines:3,overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold), ),
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
                                              image: NetworkImage(AppConstants.BASE_URL+_category.icon),
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
                                    if (_selectedCategoryList.contains(_category.id)) {
                                      _selectedCategoryList.remove(_category.id);
                                      FirebaseMessaging.instance.unsubscribeFromTopic(_category.perma);
                                      setState(() {
                                        _category.selected=false;
                                      });// unselect
                                    } else {
                                      if(_selectedCategoryList.length<5) {
                                        _selectedCategoryList.add(_category.id);
                                        print("perma-${_category.perma}");
                                        FirebaseMessaging.instance.subscribeToTopic(_category.perma);
                                        setState(() {
                                          _category.selected = true;
                                        }); // un// select
                                      }
                                      else
                                        {
                                          showerror();
                                        }
                                    }
                                    print(_selectedCategoryList.toString());
                                    _savejobtype();
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

                    // Consumer<CategoryProvider>(
                    //   builder: (context, categoryProvider, child) {
                    //     return categoryProvider.categoryList.length != 0 ?
                    //     Expanded(
                    //       child:
                    //       ListView.builder(
                    //         physics: BouncingScrollPhysics(),
                    //         itemCount: categoryProvider.categoryList.length,
                    //         padding: EdgeInsets.all(0),
                    //         itemBuilder: (context, index) {
                    //           Category _category = categoryProvider.categoryList[index];
                    //           return GestureDetector(
                    //             // onTap: () {
                    //             //   Provider.of<CategoryProvider>(context, listen: false).changeSelectedIndex(index);
                    //             //   CommonFunctions.showSuccessToast("hitt");
                    //             // },
                    //             child:
                    //             CategoryItem(
                    //               title: _category.name,
                    //               icon: _category.icon,
                    //               isSelected: categoryProvider.categorySelectedIndex == index,
                    //               id: _category.id,
                    //             ),
                    //           );
                    //
                    //         },
                    //       ),
                    //     )
                    //         : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
                    //   },
                    // ),
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
                            child: const Text('Save and Continue'),
                            onPressed: () {
                              _savejob();
                            },
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

class CategoryItem extends StatefulWidget {
  final String title;
  final String icon;
  final bool isSelected;
  final String id;
  CategoryItem({required this.title, required this.icon, required this.isSelected, required this.id});
  @override
  _CategoryItemState createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  bool value = false;
  static List<String> _selectedCategoryList = [];

  Future<void> _savejobtype() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences!.setString("jobtypelist",json.encode(_selectedCategoryList));
  }

  Future<void> _savejobtypebool(bool savejobtypebool) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences!.setBool("jobtypeselected",savejobtypebool);
  }

  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
           if(value)
             {
               value=false;
               _selectedCategoryList.removeWhere((element) => element==widget.id);
             }
           else
             {
               value=true;
               _selectedCategoryList.add(widget.id);
             }

        });
      //  print(_selectedCategoryList.toString());
        _savejobtype();
        if(_selectedCategoryList.isEmpty)
          {
            _savejobtypebool(false);
          }
        else
          {
            _savejobtypebool(true);
          }
        // Navigator.push(context, MaterialPageRoute(builder: (_) => BrandAndCategoryProductScreen(
        //   isBrand: false,
        //   id: id.toString(),
        //   name: name,
        // )));
      },
      child:
      new Padding(
        child:
        Container(
          width: MediaQuery.of(context).size.width-40,
          height: 80,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white
          ),
            child:
            new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height:50,
                    width: 50,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: widget.isSelected ? Theme.of(context).accentColor : Theme.of(context).hintColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/appicon.png',
                        image: AppConstants.BASE_URL+widget.icon,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    child: Text(widget.title, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold), ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    child:
                    Checkbox(
                      value: this.value,
                      onChanged: (bool? value) {
                        setState(() {
                          this.value = value!;
                          if(value!)
                          {
                            value=false;
                            _selectedCategoryList.removeWhere((element) => element==widget.id);
                          }
                          else
                          {
                            print(_selectedCategoryList.toString());
                            if(_selectedCategoryList.length<6) {
                              value = true;
                              _selectedCategoryList.add(widget.id);
                            }
                            else
                              {
                                CommonFunctions.showInfoDialog("You Can Select Maximum 5 Job Category", context);
                              }
                          }
                        });

                        _savejobtype();
                        if(_selectedCategoryList.isEmpty)
                        {
                          _savejobtypebool(false);
                        }
                        else
                        {
                          _savejobtypebool(true);
                        }
                      },
                    ), //Checkbox
                  ),
                ]

            ),
        ),
        padding: const EdgeInsets.all(5.0),
      ),

    );
  }
}