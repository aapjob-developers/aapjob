import 'package:Aap_job/data/datasource/remote/dio/dio_client.dart';
import 'package:Aap_job/data/datasource/remote/exception/api_error_handler.dart';
import 'package:Aap_job/models/response/api_response.dart';
import 'package:Aap_job/utill/app_constants.dart';


class AdsRepo {
  final DioClient dioClient;
  AdsRepo({required this.dioClient});

  Future<ApiResponse> getAds() async {
    try {
      final response = await dioClient.get(AppConstants.ADS_URI, queryParameters: {});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}