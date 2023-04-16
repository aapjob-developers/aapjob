import 'package:Aap_job/localization/language_constrants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CommonFunctions {

  static void showErrorDialog(String message, BuildContext context) {
    // An_Error_Occurred!
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(getTranslated('An_Error_Occurred', context)!+" 😭",style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text(getTranslated('Okay', context)!,style: TextStyle(color: Colors.red),),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  static void showInfoDialog(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(getTranslated('INFO', context)!+" 🙂",style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),),
        content: Text(message,style: TextStyle(color: Colors.blue),),
        actions: <Widget>[
          TextButton(
            child: Text(getTranslated('Okay', context)!),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  static void showSuccessToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
