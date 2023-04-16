import 'dart:convert';
import 'package:Aap_job/models/JobTitleModel.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:http/http.dart' as http;

class SearchApi {
  static Future<List<JobTitleModel>> getUserSuggestions(String query) async {
    final url = Uri.parse(AppConstants.BASE_URL+ AppConstants.JOB_TITLE_URI);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List users = json.decode(response.body);
      return users.map((json) => JobTitleModel.fromJson(json)).where((user) {
        final nameLower = user.name.toLowerCase();
        final queryLower = query.toLowerCase();
        return nameLower.contains(queryLower);
      }).toList();
    } else {
      throw Exception();
    }
  }
}