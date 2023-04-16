import 'package:Aap_job/data/datasource/remote/dio/dio_client.dart';
import 'package:Aap_job/data/datasource/remote/exception/api_error_handler.dart';
import 'package:Aap_job/models/response/api_response.dart';
import 'package:Aap_job/utill/app_constants.dart';


class JobsRepo {
  final DioClient dioClient;
  JobsRepo({required this.dioClient});


  Future<ApiResponse> getHomeJobsList(String Categoryid) async {
    try {
      final response = await dioClient.get(AppConstants.HOME_CATEGORY_JOBS_URI+Categoryid);
      print(response);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getJobsList() async {
    try {
      final response = await dioClient.get(AppConstants.CATEGORY_JOBS_URI);
      print(response);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getJobsById(String userid) async {
    try {
      final response = await dioClient.get(AppConstants.CATEGORIES_URI+"?userid="+userid);
      print(response);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


}