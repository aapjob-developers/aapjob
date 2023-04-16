import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:Aap_job/data/datasource/remote/dio/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:Aap_job/models/CitiesModel.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:google_language_fonts/google_language_fonts.dart';

import '../models/LivedataModel.dart';


class LiveDataScreen extends StatefulWidget {
  LiveDataScreen({Key? key}) : super(key: key);
  @override
  _LiveDataScreenState createState() => new _LiveDataScreenState();
}

class _LiveDataScreenState extends State<LiveDataScreen> {

  List<LivedataModel> Itemlist = <LivedataModel>[];
  final key = GlobalKey<AnimatedListState>();
  Timer? timer;

  List<String> Companylist =[
    "Aptara International",
    "Innodata India Pvt Ltd",
    "Innodata India Pvt Ltd",
    "Hyper Quality INDIA Pvt Ltd",
    "Royal Sundaram Alliance",
    "Sdg Software India",
    "Coperion Ideal Pvt Ltd",
    "FIRSTOUCH' Solutions",
    "Odyssey Stone",
    "eWeb Promotions",
    "Mavin Solutions",
    "AILBS Pvt Ltd.",
    "Alcanes Furniture",
    "IndiaInternets",
    "Mex Storage Systems",
    "OnGraph Technologies",
    "Ritz Media World",
    "Platinum Green Coworks",
    "Corpseed Ites",
    "Intellect Juris",
    "Appsquadz Software",
    "Cinntra Infotech Solutions Pvt Ltd",
    "Sofarepairwala",
    "RDMI Techventures Pvt Ltd",
    "Axiom Design Studio",
    "Designoweb Technologies",
    "Transspac Immigration Law Firm",
    "Silver Bazel"
  ];

  List<String> Name =[
    "Aarav",
    "Aarna",
    "Abha",
    "Abhay",
    "Abhilash",
    "Abhilasha",
    "Abhinav",
    "Abishek",
    "Adarsh",
    "Vihaan",
    "Vivaan",
    "Ananya",
    "Diya",
    "Advik",
    "Kabir",
    "Anaya",
    "Aarav",
    "Vivaan",
    "Aditya",
    "Vivaan",
    "Vihaan",
    "Arjun",
    "Vivaan",
    "Reyansh",
    "Mohammed",
    "Sai",
    "Arnav",
    "Aayan",
    "Krishna",
    "Ishaan",
    "Shaurya",
    "Atharva",
    "Advik",
    "Pranav",
    "Advaith",
    "Aaryan",
    "Dhruv",
    "Kabir",
    "Ritvik",
    "Aarush",
    "Kian",
    "Darsh",
    "Veer",
    "Saanvi",
    "Anya",
    "Aadhya",
    "Aaradhya",
    "Ananya",
    "Pari",
    "Anika",
    "Navya",
    "Angel",
    "Diya",
    "Myra",
    "Sara",
    "Iraa",
    "Ahana",
    "Anvi",
    "Prisha",
    "Riya",
    "Aarohi",
    "Anaya",
    "Akshara",
    "Eva",
    "Shanaya",
    "Kyra",
    "Siya"
  ];

  List<String> surname=[
    "Bedi",
    "Gandhi",
    "Parekh",
    "Kohli",
    "Ahluwalia",
    "Chandra",
    "Jha",
    "Khanna",
    "Bajwa",
    "Chawla",
    "Lal",
    "Anand",
    "Gill",
    "Chakrabarti",
    "Dubey",
    "Kapoor",
    "Khurana",
    "Modi",
    "Kulkarni",
    "Khatri",
    "Kaur",
    "Dhillon",
    "Kumar",
    "Gupta",
    "Naidu",
    "Das",
    "Jain",
    "Chowdhury",
    "Dalal",
    "Thakur",
    "Gokhale",
    "Apte",
    "Sachdev",
    "Mehta",
    "Ganguly",
    "Bhasin",
    "Mannan",
    "Ahuja",
    "Singh",
    "Bakshi",
    "Basu",
    "Ray",
    "Mani",
    "Datta",
    "Balakrishna",
    "Biswas",
    "Laghari",
    "Malhotra",
    "Dewan",
    "Purohit"
  ];
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  int randomNumber(int min,int max) {
    var random = new Random();
    int result = min + random.nextInt(max - min);
    return result;
  }

  addnewitem () async
  {
   // Itemlist.add();
    key.currentState!.insertItem(0,
        duration: const Duration(milliseconds: 500));
    Itemlist = []
      ..add(new LivedataModel(ComapnyName: Companylist[randomNumber(0,26)],name: Name[randomNumber(0,65)]+" "+surname[randomNumber(0,48)],email: Name[randomNumber(0,65)].substring(0,3)+"....@gmail.com",phone: "+91XXXXXX"+randomNumber(1000,9999).toString()))
      ..addAll(Itemlist);

  }

  Future<void> addinitialitems() async
  {
    for(var i=0;i<10;i++)
      {
        Itemlist.add(new LivedataModel(ComapnyName: Companylist[randomNumber(0,26)],name: Name[randomNumber(0,65)]+" "+surname[randomNumber(0,48)],email: Name[randomNumber(0,65)].substring(0,3)+"....@gmail.com",phone: "+91XXXXXX"+randomNumber(1000,9999).toString()));
      }
  }

  @override
  void initState() {
    initializePreference().whenComplete((){
      timer = Timer.periodic(Duration(seconds: 5), (Timer t) => addnewitem());
    });
    super.initState();
  }

  Future<void> initializePreference() async{
    await addinitialitems();
  }

  Widget slideIt(BuildContext context, int index, animation) {
    final deviceSize = MediaQuery
        .of(context)
        .size;
    LivedataModel item = Itemlist[index];
    TextStyle? textStyle = Theme.of(context).textTheme.headline4;
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset(0, 0),
      ).animate(animation),
      child:
      Container(
        width: MediaQuery.of(context).size.width*0.9,
        decoration: new BoxDecoration(boxShadow: [new BoxShadow(
          color: Color.fromRGBO(00, 132, 122, 1.0),
          blurRadius: 5.0,
        ),],
            color: Color.fromRGBO(00, 132, 122, 1.0),
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        child:
        new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container( width: deviceSize.width*0.9,
                padding: EdgeInsets.all(8),
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Container(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child:
                              //  Text('${duplicateJobsModel[index].jobRole}',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.white),),
                              Text('Recruiting for ${Itemlist[index].ComapnyName}',style: LatinFonts.aBeeZee(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white),),
                            ),
                          ]
                      ),
                      new Container(
                        padding: EdgeInsets.all(3),
                        child:
                        //  Text('${duplicateJobsModel[index].companyName}',style: LatinFonts.aBeeZee(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white),),
                        Text('HR : ${Itemlist[index].name}',style: LatinFonts.aBeeZee(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white),),
                      ),
                      new Container(
                        padding: EdgeInsets.all(3),
                        child:
                        //  Text('${duplicateJobsModel[index].companyName}',style: LatinFonts.aBeeZee(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white),),
                        Text('${Itemlist[index].email}',style: LatinFonts.aBeeZee(fontSize: 8, fontWeight: FontWeight.bold,color: Colors.white),),
                      ),
                      new Container(
                        padding: EdgeInsets.all(3),
                        child:
                        //  Text('${duplicateJobsModel[index].companyName}',style: LatinFonts.aBeeZee(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white),),
                        Text('${Itemlist[index].phone}',style: LatinFonts.aBeeZee(fontSize: 8, fontWeight: FontWeight.bold,color: Colors.white),),
                      ),
                      new Container(
                        padding: EdgeInsets.all(3),
                        child:
                        //  Text('${duplicateJobsModel[index].companyName}',style: LatinFonts.aBeeZee(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white),),
                        Text('Candidates are enabled by AAP Job',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.white),),
                      ),
                    ]
                ),
              ),
            ]
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery
        .of(context)
        .size;
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Primary,
        title: new Text("Live Data"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: AnimatedList(
               /// shrinkWrap: true,
                key: key,
                initialItemCount: Itemlist.length,
                itemBuilder: (context, index,animation) {
                  return slideIt(context, index, animation);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

