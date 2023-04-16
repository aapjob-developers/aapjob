import 'package:Aap_job/screens/selectPlansScreen.dart';
import 'package:Aap_job/utill/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:intl/intl.dart';
import 'package:Aap_job/utill/colors.dart';
class PlanDetailPopup {
  final String? title;
  final String? detail1;
  final String? detail2;
  final String? detail3;
  final String? detail4;
  final String? detail5;

  final String? message;
  final String? rightButton;
  final VoidCallback? onTapRightButton;
  final String? leftButton;
  //final VoidCallback? onTapLeftButton;

  PlanDetailPopup({
    this.title,
    this.message,
    this.detail1,
    this.detail2,
    this.detail3,
    this.detail4,
    this.detail5,

    this.rightButton,
    this.onTapRightButton,
    this.leftButton,
    //this.onTapLeftButton,
  });

  show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _PlanDetailPopupCall(
            title: title!,
            message: message!,
            detail1: detail1!,
            detail2: detail2!,
            detail3: detail3!,
            detail4: detail4!,
            detail5: detail5!,

            leftButton: leftButton!,
            rightButton: rightButton!,
           // onTapLeftButton: onTapLeftButton,
            onTapRightButton: onTapRightButton);
      },
    );
  }
}

class _PlanDetailPopupCall extends StatefulWidget {
  final String? title;
  final String? detail1;
  final String? detail2;
  final String? detail3;
  final String? detail4;
  final String? detail5;

  final String? message;
  final String? rightButton;
  final VoidCallback? onTapRightButton;
  final String? leftButton;
 // final VoidCallback? onTapLeftButton;

  const _PlanDetailPopupCall(
      {Key? key,
        this.title,
        this.message,
        this.detail1,
        this.detail2,
        this.detail3,
        this.detail4,
        this.detail5,
        this.rightButton,
        this.onTapRightButton,
        this.leftButton,
       // this.onTapLeftButton
   })
      : super(key: key);
  @override
  _PlanDetailPopupCallState createState() => _PlanDetailPopupCallState();
}

class _PlanDetailPopupCallState extends State<_PlanDetailPopupCall> {
  final DateFormat formatter = DateFormat('dd-MMM-yyyy');
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(24),
        ),
      ),
      backgroundColor: Colors.white,
      titlePadding: EdgeInsets.all(0),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.red,
                size: 25,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Center(
            child: Text(widget.title!,
                style: TextStyle(
                  fontFamily: 'TTNorms',
                  fontWeight: FontWeight.bold,
                  wordSpacing: 0,
                  letterSpacing: 0,
                  fontSize: 25,
                  color: Colors.black,
                )),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          //title
          widget.message=='r'?
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Plan Type', style: LatinFonts.aBeeZee(fontSize: 12,fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                Text("Recruiter Plan", style: LatinFonts.aBeeZee(fontSize: 12,), maxLines: 2, overflow: TextOverflow.ellipsis),
              ]
          ):Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Plan Type', style: LatinFonts.aBeeZee(fontSize: 12,fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                Text("Consultancy Plan", style: LatinFonts.aBeeZee(fontSize: 12,), maxLines: 2, overflow: TextOverflow.ellipsis),
              ]
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          // detail1
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Job Posting Allowed ', style: LatinFonts.aBeeZee(fontSize: 12,fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                Text("${widget.detail1} Jobs", style: LatinFonts.aBeeZee(fontSize: 12,), maxLines: 2, overflow: TextOverflow.ellipsis),    ]
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          //detail2
          widget.message=='r'?
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Profiles Per Job ', style: LatinFonts.aBeeZee(fontSize: 12,fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                Text(widget.detail2! , style: LatinFonts.aBeeZee(fontSize: 12,), maxLines: 2, overflow: TextOverflow.ellipsis),    ]
          )
              :
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Per Day Resume Limit', style: LatinFonts.aBeeZee(fontSize: 12,fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                Text(widget.detail2! , style: LatinFonts.aBeeZee(fontSize: 12,), maxLines: 2, overflow: TextOverflow.ellipsis)
              ]
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          //detail4
          widget.message=='r'?
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Plan Category ', style: LatinFonts.aBeeZee(fontSize: 12,fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                Text(widget.detail4! , style: LatinFonts.aBeeZee(fontSize: 12,), maxLines: 2, overflow: TextOverflow.ellipsis),    ]
          )
              :
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Total Resume Limit', style: LatinFonts.aBeeZee(fontSize: 12,fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                Text(widget.detail4 !, style: LatinFonts.aBeeZee(fontSize: 12,), maxLines: 2, overflow: TextOverflow.ellipsis)
              ]
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          // detail3
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Validity ', style: LatinFonts.aBeeZee(fontSize: 12,fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                Text("${widget.detail3!} days", style: LatinFonts.aBeeZee(fontSize: 12,), maxLines: 2, overflow: TextOverflow.ellipsis),    ]
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          // detail3
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Date of Activation ', style: LatinFonts.aBeeZee(fontSize: 12,fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                Text(formatter.format(DateTime.parse(widget.detail5!)) , style: LatinFonts.aBeeZee(fontSize: 12,), maxLines: 2, overflow: TextOverflow.ellipsis),    ]
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        ],
      ),
      actions: [
        if (widget.leftButton != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => SelectPlansScreen()));
                },
                child: Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.amber, width: 2.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                    color: Colors.amber,
                  ),
                  child: Center(
                    child: Text(
                      widget.leftButton!.toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'TTNorms',
                        fontWeight: FontWeight.bold,
                        wordSpacing: 0,
                        letterSpacing: 0,
                        fontSize: 15,
                        color: Primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        Padding(
          padding: EdgeInsets.only(
            bottom: 10.0,
            left: 10,
          ),
          child: Center(
            child: GestureDetector(
              onTap: () {
                widget.onTapRightButton?.call();
                Navigator.pop(context);
              },
              child: Container(
                height: 40,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: Center(
                  child: Text(
                    widget.rightButton!.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'TTNorms',
                      fontWeight: FontWeight.bold,
                      wordSpacing: 0,
                      letterSpacing: 0,
                      fontSize: 15,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}