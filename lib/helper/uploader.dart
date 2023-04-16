import 'dart:async';
import 'dart:io';

import 'package:Aap_job/utill/app_constants.dart';
import 'package:files_uploader/files_uploader.dart';
//import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';

class BackgroundUploader {
  BackgroundUploader._();

  static final uploader = FlutterUploader();


  static Future<String> uploadEnqueue(String Urll,File file, String userid, String usertype,String fieldname) async {
    if (Urll == AppConstants.UPDATE_HR_COMPANY_PROFILE)
    {
      final String savedDir = dirname(file.path);
      final String filename = basename(file.path);

      var fileItem = FileItem(
        path: file.path,
        field: fieldname,
      );

      Map<String, String> _fields = Map();
      _fields.addAll(<String, String>{'userid': userid, 'companyname': usertype,});
      final String taskId = await uploader.enqueue(
          MultipartFormDataUpload(
        url: '${AppConstants.BASE_URL}${Urll}',
        method: UploadMethod.POST,
        files: [fileItem],
        data: _fields,
        tag: "Media Uploading",
      ),);
      return taskId;
    }
    else {
      final String savedDir = dirname(file.path);
      final String filename = basename(file.path);

      var fileItem = FileItem(
        path: file.path,
        field: fieldname,
      );

      Map<String, String> _fields = Map();
      _fields.addAll(<String, String>{'userid': userid, 'usertype': usertype,});
      final String taskId = await uploader.enqueue(
          MultipartFormDataUpload(
        url: '${AppConstants.BASE_URL}${Urll}',
        method: UploadMethod.POST,
        files: [fileItem],
        data: _fields,
        tag: "Media Uploading",
      ),);
      return taskId;
    }
  }
}