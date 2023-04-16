import 'dart:convert';

import 'package:Aap_job/data/respository/SearchApi.dart';
import 'package:Aap_job/helper/LocationManager.dart';
import 'package:Aap_job/helper/SharedManager.dart';
import 'package:Aap_job/models/JobCategoryModel.dart';
import 'package:Aap_job/models/JobTitleModel.dart';
import 'package:Aap_job/models/common_functions.dart';
import 'package:Aap_job/screens/SearchScreenResult.dart';
import 'package:flutter/material.dart';
import 'package:Aap_job/data/datasource/remote/dio/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:Aap_job/models/CitiesModel.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';


class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);
  @override
  _SearchScreenState createState() => new _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController editingController = TextEditingController();
  List<String> suggestons = [];

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
            child:
            TypeAheadField<JobTitleModel>(
              hideSuggestionsOnKeyboardHide: false,
              textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                       isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Search by title, role ex. clerk",
                ),
              ),
              suggestionsCallback: SearchApi.getUserSuggestions,
              itemBuilder: (context, JobTitleModel suggestion) {
                final user = suggestion;
                return ListTile(
                  title:
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                    Container(
                    width: MediaQuery.of(context).size.width*0.4,
                  child:
                        Text(user.name,style: LatinFonts.aBeeZee(fontSize: 12,fontWeight:FontWeight.w600),maxLines: 4,),
                    ),
                        Text("- Job Role",style: LatinFonts.lato(fontSize: 12,fontStyle: FontStyle.italic,color: Colors.grey),)
                      ],
                    ),
                );
              },
              noItemsFoundBuilder: (context) => Container(
                height: 100,
                child: Center(
                  child: Text(
                    'No Role Found.',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
              onSuggestionSelected: (JobTitleModel suggestion) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => SearchScreenResult(suggestion: suggestion.name)
                ));
              },
            ),
          ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
          ],
        ),
      ),
    );
  }
}

