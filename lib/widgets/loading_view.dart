import 'package:Aap_job/utill/colors.dart';
import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          color: Primary,
        ),
      ),
      color: Colors.white.withOpacity(0.8),
    );
  }
}
