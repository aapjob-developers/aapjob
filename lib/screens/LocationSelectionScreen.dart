import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:Aap_job/data/datasource/remote/dio/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:Aap_job/models/LocationModel.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:google_language_fonts/google_language_fonts.dart';


class LocationSelectionScreen extends StatefulWidget {
  LocationSelectionScreen({Key? key,required this.duplicate, required this.hasdata}) : super(key: key);
  List<LocationModel> duplicate ;
  bool hasdata;
  @override
  _LocationSelectionScreenState createState() => new _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  // final Dio _dio = Dio();
  // final _baseUrl = AppConstants.BASE_URL;
  // var apidata;
  bool _hasData=false;

  List<LocationModel> duplicateItems = <LocationModel>[];
  var items = <LocationModel>[];

  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    duplicateItems=widget.duplicate;
    _hasData=widget.hasdata;
    items.addAll(duplicateItems);
    super.initState();
  }

  void filterSearchResults(String query) {
    List<LocationModel> dummySearchList = <LocationModel>[];
    dummySearchList.addAll(duplicateItems);
    if(query.isNotEmpty) {
      List<LocationModel> dummyListData = <LocationModel>[];
      dummySearchList.forEach((item) {
        if(item.name.toUpperCase().contains(query.toUpperCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Primary,
        title: new Text("Select Location"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            _hasData?
            Expanded(
              child:
              ListView.separated(
                shrinkWrap: true,
                itemCount: items.length,
                separatorBuilder: (context, index){
                  return Divider(height: 1,);
                },
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: (){
                      Navigator.pop(context,items[index]);
                    },
                    title: Text('${items[index].name}',style: LatinFonts.aBeeZee(fontSize: 14,fontWeight: FontWeight.bold),),
                  );
                },
              ),
            ):
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
