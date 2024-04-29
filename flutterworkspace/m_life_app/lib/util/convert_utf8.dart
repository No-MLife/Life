import 'dart:convert';

// dynamic convertUtf8ToObject(dynamic body) {
//   // json 데이터로 변경
//   String responseBody = jsonEncode(body);
//   dynamic convertBody = jsonDecode(utf8.decode(responseBody.codeUnits));
//   return convertBody;
// }

dynamic convertUtf8ToObject(dynamic body) {
  if (body is String) {
    return jsonDecode(body);
  } else {
    return body;
  }
}
