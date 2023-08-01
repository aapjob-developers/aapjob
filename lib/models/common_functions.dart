import 'package:Aap_job/localization/language_constrants.dart';
import 'package:Aap_job/utill/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

class CommonFunctions {

  static void showErrorDialog(String message, BuildContext context) {
    // An_Error_Occurred!
    showDialog(
      context: context,
      builder: (ctx) =>
          Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              new Image.asset(
                'assets/images/appicon.png',
                fit: BoxFit.contain,
                height: 50,
                width: 50,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: 20),
                child: Text(message, textAlign: TextAlign.center),
              ),
              Divider(height: 0, color: Colors.grey),
              Row(children: [
                Expanded(child: InkWell(
                  onTap: () {
                  },
                  child: Container(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
                    child:Container(),
                  ),
                )),
                Expanded(child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.only(bottomRight: Radius.circular(10))),
                    child: Text(getTranslated('Okay', context)!,style: TextStyle(color: Colors.white),),
                  ),
                )),

              ]),
            ]),
          ),

      //     AlertDialog(
      //   title: Text(getTranslated('An_Error_Occurred', context)!+" 😭",style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
      //   content: Text(message),
      //   actions: <Widget>[
      //     TextButton(
      //       child: Text(getTranslated('Okay', context)!,style: TextStyle(color: Colors.red),),
      //       onPressed: () {
      //         Navigator.of(ctx).pop();
      //       },
      //     )
      //   ],
      // ),
    );
  }

  static void showInfoDialog(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) =>
      //     AlertDialog(
      //   title: Text(getTranslated('INFO', context)!+" 🙂",style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),),
      //   content: Text(message,style: TextStyle(color: Colors.blue),),
      //   actions: <Widget>[
      //     TextButton(
      //       child: Text(getTranslated('Okay', context)!),
      //       onPressed: () {
      //         Navigator.of(ctx).pop();
      //       },
      //     )
      //   ],
      // ),
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          new Image.asset(
            'assets/images/appicon.png',
            fit: BoxFit.contain,
            height: 50,
            width: 50,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: 20),
            child: Text(message, textAlign: TextAlign.center),
          ),
          Divider(height: 0, color: Colors.grey),
          Row(children: [
            Expanded(child: InkWell(
              onTap: () {
              },
              child: Container(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                alignment: Alignment.center,
                decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
                child:Container(),
              ),
            )),
            Expanded(child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.only(bottomRight: Radius.circular(10))),
                child: Text(getTranslated('Okay', context)!,style: TextStyle(color: Colors.white),),
              ),
            )),

          ]),
        ]),
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
