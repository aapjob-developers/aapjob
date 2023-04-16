import 'dart:convert';

import 'package:Aap_job/helper/LocationManager.dart';
import 'package:Aap_job/helper/SharedManager.dart';
import 'package:Aap_job/localization/language_constrants.dart';
import 'package:Aap_job/models/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:Aap_job/data/datasource/remote/dio/dio_client.dart';
import 'package:dio/dio.dart';

import 'package:Aap_job/models/CitiesModel.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';


class FriendsSearchScreen extends StatefulWidget {
  FriendsSearchScreen({Key? key}) : super(key: key);
  @override
  _FriendsSearchScreenState createState() => new _FriendsSearchScreenState();
}

class _FriendsSearchScreenState extends State<FriendsSearchScreen> {

  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }


 void filterSearchResult(String query) {
   // List<CityModel> dummySearchList = List<CityModel>();
   // dummySearchList.addAll(duplicateItems);
   // if(query.isNotEmpty) {
   //   List<CityModel> dummyListData = List<CityModel>();
   //   dummySearchList.forEach((item) {
   //     if(item.name.toUpperCase().contains(query.toUpperCase())) {
   //      // dummyListData.add(item);
   //       Navigator.pop(context,item);
   //     }
   //   });
   //  // CommonFunctions.showInfoDialog("Your Location is not in list. Please Select a city from list", context);
   //   return;
   // } else {
   //   CommonFunctions.showInfoDialog("Your Location is not in list. Please Select a city from list", context);
   // }

 }

  void filterSearchResults(String query) {
    // List<CityModel> dummySearchList = List<CityModel>();
    // dummySearchList.addAll(duplicateItems);
    // if(query.isNotEmpty) {
    //   List<CityModel> dummyListData = List<CityModel>();
    //   dummySearchList.forEach((item) {
    //     if(item.name.toUpperCase().contains(query.toUpperCase())) {
    //       dummyListData.add(item);
    //     }
    //   });
    //   setState(() {
    //     items.clear();
    //     items.addAll(dummyListData);
    //   });
    //   return;
    // } else {
    //   setState(() {
    //     items.clear();
    //     items.addAll(duplicateItems);
    //   });
    // }

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Primary,
        title:
          Container(
            width: MediaQuery.of(context).size.width,
            child: TextField(
              onChanged: (value) {
                filterSearchResults(value);
              },
              controller: editingController,
              decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                  hintText: getTranslated("SEARCH_BY_TITLE", context),
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder( borderRadius: BorderRadius.all(Radius.circular(8.0)))),
            ),
          ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            // _hasData?
            // Expanded(
            //   child: ListView.separated(
            //     shrinkWrap: true,
            //     itemCount: items.length,
            //     separatorBuilder: (context, index){
            //       return Divider(height: 1,);
            //     },
            //     itemBuilder: (context, index) {
            //       return ListTile(
            //         onTap: (){
            //           Navigator.pop(context,items[index]);
            //         },
            //         title: Text('${items[index].name}',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),),
            //       );
            //     },
            //   ),
            // ):
            // CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
