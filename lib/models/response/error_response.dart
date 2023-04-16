/// errors : [{"code":"l_name","message":"The last name field is required."},{"code":"password","message":"The password field is required."}]
//
// class ErrorResponse {
//   List<Errors> _errors;
//
//   List<Errors> get errors => _errors;
//
//   ErrorResponse({
//       List<Errors> errors}){
//     _errors = errors;
// }
//
//   ErrorResponse.fromJson(dynamic json) {
//     if (json["errors"] != null) {
//       _errors = [];
//       json["errors"].forEach((v) {
//         _errors.add(Errors.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     var map = <String, dynamic>{};
//     if (_errors != null) {
//       map["errors"] = _errors.map((v) => v.toJson()).toList();
//     }
//     return map;
//   }
//
// }
//

/// code : "l_name"
/// message : "The last name field is required."

// class Errors {
//   String _code;
//   String _message;
//
//   String get code => _code;
//   String get message => _message;
//
//   Errors({
//       String code,
//       String message}){
//     _code = code;
//     _message = message;
// }
//
//   Errors.fromJson(dynamic json) {
//     _code = json["code"];
//     _message = json["message"];
//   }
//
//   Map<String, dynamic> toJson() {
//     var map = <String, dynamic>{};
//     map["code"] = _code;
//     map["message"] = _message;
//     return map;
//   }
//
// }
//

class ErrorResponse {
  final List<Errors> errors;

  ErrorResponse({this.errors = const []});

  ErrorResponse.fromJson(Map<String, dynamic> json)
      : errors = (json['errors'] as List)
      ?.map((error) => Errors.fromJson(error))
      ?.toList() ??
      [];

  Map<String, dynamic> toJson() => {'errors': errors};
}

class Errors {
  final String code;
  final String message;

  Errors({this.code = '', this.message = ''});

  Errors.fromJson(Map<String, dynamic> json)
      : code = json['code'] ?? '',
        message = json['message'] ?? '';

  Map<String, dynamic> toJson() => {'code': code, 'message': message};
}
