import 'package:Aap_job/utill/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NoInternetOrDataScreen extends StatelessWidget {
  final bool isNoInternet;
  final Widget child;
  NoInternetOrDataScreen({required this.isNoInternet, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.025),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(isNoInternet ? 'assets/lottie/opps_internet.png' : 'assets/images/no_data.png', width: 150, height: 150),
            Text(isNoInternet ? 'OPPS': 'sorry', style: LatinFonts.aBeeZee(
              fontSize: 30,
              color: isNoInternet ? Colors.black : Colors.blue,
            )),
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            Text(
              isNoInternet ? 'No internet connection' : 'No data found',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            isNoInternet ? Container(
              height: 45,
              margin: EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.amber),
              child: TextButton(
                onPressed: () async {
                  if(await Connectivity().checkConnectivity() != ConnectivityResult.none) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => child));
                  }
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text('RETRY', style: LatinFonts.aBeeZee(color: Colors.black, fontSize: Dimensions.FONT_SIZE_LARGE)),
                ),
              ),
            ) : SizedBox.shrink(),

          ],
        ),
      ),
    );
  }
}
