import 'package:Aap_job/utill/colors.dart';
import 'package:flutter/material.dart';

class YellowCard extends StatelessWidget {
  const YellowCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 30,
      ),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: yellowCardBgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        'Message and calls are end-to-end encrypted. No one outside of this chat, not even Aapjob, can read or listen to them. In Case of suspicious messages, scams, Charging money, Contact customer care',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 13,
          color: yellowCardTextColor,
        ),
      ),
    );
  }
}
