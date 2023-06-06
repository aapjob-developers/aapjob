import 'package:Aap_job/utill/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:lottie/lottie.dart';

showLocationDialog({
  required BuildContext context,
  required String message,
}) async {
  return await showGeneralDialog(
    context: context,
    barrierDismissible: false,
    pageBuilder: (BuildContext buildContext,
        Animation animation,
        Animation secondaryAnimation) {
      return Scaffold(
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(20),
            color: Colors.white.withOpacity(0.8),
         child: Column(
            // mainAxisSize: MainAxisSize.max,
            children: [
                  Lottie.asset(
                    message,
                    height: MediaQuery.of(context).size.width,
                    animate: true,),
                  const SizedBox(height: 20),
                  new Padding(
                    child:
                    Text.rich(
                        TextSpan(
                            text: 'Please ',
                            style: LatinFonts.aBeeZee(color:Colors.red,fontSize: 14, fontWeight: FontWeight.bold,),
                            children: <InlineSpan>[
                              TextSpan(
                                text: 'Wait',
                                style: LatinFonts.aBeeZee(color:Colors.green,fontSize: 14, fontWeight: FontWeight.bold),
                              )
                            ]
                        )
                    ),
                    // Text('Job Title',style: LatinFonts.aBeeZee(fontSize: 14, fontWeight: FontWeight.bold),),
                    padding: const EdgeInsets.all(10.0),
                  ),
            ],
          ),
        ),
        ),
      );
    },
  );
}