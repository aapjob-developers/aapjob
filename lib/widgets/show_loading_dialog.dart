import 'package:Aap_job/utill/colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

showLoadingDialog({
  required BuildContext context,
  required String message,
}) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Lottie.asset(
                  'assets/lottie/gps.json',
                  height: MediaQuery.of(context).size.width*0.1,
                  //width: MediaQuery.of(context).size.width*0.45,
                  animate: true,),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.green,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}