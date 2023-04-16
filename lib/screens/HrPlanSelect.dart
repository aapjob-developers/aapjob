import 'dart:convert';
import 'dart:math';

import 'package:Aap_job/utill/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:Aap_job/models/HrPlanModel.dart';
import 'package:Aap_job/models/category.dart';
import 'package:Aap_job/models/common_functions.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:Aap_job/providers/category_provider.dart';
import 'package:Aap_job/providers/hrplan_provider.dart';
import 'package:Aap_job/providers/profile_provider.dart';
import 'package:Aap_job/screens/homepage.dart';
import 'package:Aap_job/screens/hrhomepage.dart';
import 'package:Aap_job/screens/otpscreen.dart';
import 'package:Aap_job/utill/dimensions.dart';
import 'package:Aap_job/view/basewidget/animated_custom_dialog.dart';
import 'package:Aap_job/view/basewidget/my_dialog.dart';
import '../models/register_model.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class HrPlanSelect extends StatefulWidget {
  HrPlanSelect({Key? key}) : super(key: key);
  @override
  _HrPlanSelectState createState() => new _HrPlanSelectState();
}


class _HrPlanSelectState extends State<HrPlanSelect> {
  bool planselected=false;

  Future<void> _savejob() async {
    final sharedPreferences = await SharedPreferences.getInstance();
   // planselected=sharedPreferences!.getBool("jobtypeselected")??false;
    planselected=true;
    if(planselected)
    {
      await Provider.of<ProfileProvider>(context, listen: false).updateHrInfo().then((response) {
        if (response.isSuccess) {
          sharedPreferences!.setBool("loggedin",true);
          Navigator.pushReplacement( context,  MaterialPageRoute(builder: (context) => HrHomePage()),);
        } else {
          CommonFunctions.showErrorDialog(response.message, context);
        }
      });
    }
    else
    {
      CommonFunctions.showSuccessToast("Please select");
    }
  }

  Future<void> _loadData(BuildContext context, bool reload) async {
    await Provider.of<HrPlanProvider>(context, listen: false).getHrPlanList(reload, context,);
  }

  @override
  void initState() {
    // _foundcategoryList  = _categoryList;
    super.initState();
    _loadData(context, false);
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
                  "Please select atleast One Plan to continue ",
                  style: new TextStyle(
                      color: Colors.white, fontSize: 20),
                  textAlign: TextAlign.center,),
                const SizedBox(
                  height: 20,
                ),
                new Container(
                  width: deviceSize.width*0.9,
                  height: deviceSize.height*0.6,
                  padding: const EdgeInsets.all(10.0),
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
                    Text("Plans Comming Soon", style: GoogleFonts.abhayaLibre(fontSize: 28,color:Colors.white),),

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
                          ElevatedButton(
                            child: const Text('Next'),
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

                    ),
                    padding: const EdgeInsets.all(10.0),
                  ),
                ),

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
  final int id;
  CategoryItem({required this.title, required this.icon, required this.isSelected, required this.id});
  @override
  _CategoryItemState createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  bool value = false;
  static List<int> _selectedCategoryList = [];

  Future<void> _savejobtype() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    // sharedPreferences!.setString("jobtypelist",_selectedCategoryList.toString());
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
        print(_selectedCategoryList.toString());
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
                      });
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