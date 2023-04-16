import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomButton extends StatelessWidget {
  final Function()? onTap;
  final String buttonText;
  CustomButton({ this.onTap, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
      child: Container(
        height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xFFD4D4D4),
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 7, offset: Offset(0, 1)), // changes position of shadow
            ],
            gradient: (onTap == null) ? null : LinearGradient(colors: [
              Theme.of(context).primaryColor,
              Color(0xFFFFAA47),
              Color(0xFFFFAA47),
            ]),
            borderRadius: BorderRadius.circular(10)),
        child: Text(buttonText),
      ),
    );
  }
}
