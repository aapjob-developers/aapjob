import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:Aap_job/view/basewidget/button/custom_button.dart';


class MyDialog extends StatelessWidget {
  final bool isFailed;
  final double rotateAngle;
  final IconData icon;
  final String title;
  final String description;
  MyDialog({this.isFailed = false, this.rotateAngle = 0, required this.icon, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Stack(clipBehavior: Clip.none, children: [

          Positioned(
            left: 0, right: 0, top: -55,
            child: Container(
              height: 80,
              width: 80,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: isFailed ? Colors.red : Theme.of(context).primaryColor, shape: BoxShape.circle),
              child: Transform.rotate(angle: rotateAngle, child: Icon(icon, size: 40, color: Colors.white)),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: 40),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(title),
              SizedBox(height: 10),
              Text(description, textAlign: TextAlign.center),
              SizedBox(height:20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CustomButton(buttonText:'ok', onTap: () => Navigator.pop(context)),
              ),
            ]),
          ),

        ]),
      ),
    );
  }
}
