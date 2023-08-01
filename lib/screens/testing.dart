
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class testing extends StatefulWidget {
  const testing({Key? key}) : super(key: key);

  @override
  _testingState createState() => _testingState();
}

class _testingState extends State<testing>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  SharedPreferences? sharedPreferences;


  @override
  void initState() {
    super.initState();
    initializePreference().whenComplete((){
      setState(() {
        //LocationManager.shared.getCurrentLocation();
        _controller = AnimationController(
          duration: Duration(seconds: (5)),
          vsync: this,
        );
      });
    });
  }

  Future<void> initializePreference() async{
    this.sharedPreferences = await SharedPreferences.getInstance();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Container(
        child: Text("I am in"),),
      );
  }
}