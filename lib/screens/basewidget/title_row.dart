
import 'package:flutter/material.dart';
import 'package:Aap_job/utill/colors.dart';
import 'package:Aap_job/utill/dimensions.dart';

class TitleRow extends StatelessWidget {
  final String title;
  final Function()? onTap;
  final Duration eventDuration;
  final bool isDetailsPage;
  TitleRow({required this.title,required this.onTap,required this.eventDuration,required this.isDetailsPage});

  @override
  Widget build(BuildContext context) {
    int days=0, hours=0, minutes=0, seconds=0;
    if (eventDuration != null) {
      days = eventDuration.inDays;
      hours = eventDuration.inHours - days * 24;
      minutes = eventDuration.inMinutes - (24 * days * 60) - (hours * 60);
      seconds = eventDuration.inSeconds - (24 * days * 60 * 60) - (hours * 60 * 60) - (minutes * 60);
    }

    return Row(children: [
      Text(title),
      eventDuration == null
          ? Expanded(child: SizedBox.shrink())
          : Expanded(
              child: Row(children: [
              SizedBox(width: 5),
              TimerBox(time: days),
              Text(':', style: TextStyle(color: Theme.of(context).primaryColor)),
              TimerBox(time: hours),
              Text(':', style: TextStyle(color: Theme.of(context).primaryColor)),
              TimerBox(time: minutes),
              Text(':', style: TextStyle(color: Theme.of(context).primaryColor)),
              TimerBox(time: seconds, isBorder: true),
            ])),
      onTap != null
          ? InkWell(
              onTap: onTap,
              child: Row(children: [
                isDetailsPage == null
                    ? Text('VIEW_ALL',style:new TextStyle(color: Primary,fontSize: Dimensions.FONT_SIZE_SMALL,))
                    : SizedBox.shrink(),
                Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: isDetailsPage == null ? Primary : Theme.of(context).hintColor,
                    size: Dimensions.FONT_SIZE_SMALL,
                  ),
                ),
              ]),
            )
          : SizedBox.shrink(),
    ]);
  }
}

class TimerBox extends StatelessWidget {
  final int time;
  final bool isBorder;

  TimerBox({required this.time, this.isBorder = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 1),
      padding: EdgeInsets.all(isBorder ? 0 : 2),
      decoration: BoxDecoration(
        color: isBorder ? null : Primary,
        border: isBorder ? Border.all(width: 2, color: Primary) : null,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Center(
        child: Text(time < 10 ? '0$time' : time.toString(),
          style: new TextStyle(
            color: isBorder ? Primary : Theme.of(context).secondaryHeaderColor,
            fontSize: Dimensions.FONT_SIZE_SMALL,
          ),
        ),
      ),
    );
  }
}
