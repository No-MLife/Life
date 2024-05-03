import 'package:intl/intl.dart';

class CMResDto {
  final dynamic data;

  CMResDto({
    this.data,
  });

  // 통신을 위해서 Json 처럼 생긴 문자열
  CMResDto.fromJson(Map<String, dynamic> json) : data = json["data"];
}
