import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Aap_job/models/response/api_response.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:Aap_job/providers/profile_provider.dart';
//import 'package:Aap_job/screens/loginscreen.dart';

class ApiChecker {
  static void checkApi(BuildContext context, ApiResponse apiResponse) {
    if(apiResponse.error is! String && apiResponse.error.errors[0].message == 'Unauthorized.') {
      Provider.of<AuthProvider>(context,listen: false).clearSharedData();
     // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
    }else {
      String _errorMessage;
      if (apiResponse.error is String) {
        _errorMessage = apiResponse.error.toString();
      } else {
        _errorMessage = apiResponse.error.errors[0].message;
      }
      print(_errorMessage);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_errorMessage, style: TextStyle(color: Colors.white)), backgroundColor: Colors.red));
    }
  }
}