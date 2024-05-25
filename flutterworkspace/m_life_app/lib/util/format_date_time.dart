import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime) {
  // final now = DateTime.now().add(Duration(hours: 9));
  dateTime = dateTime.add(Duration(minutes: -9, seconds: -22)); // 나중에 수정해야함
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  // print("now is : ${now}");
  // print("dateTime is : ${dateTime}");
  // print("difference is : ${difference}");

  if (difference.inDays > 0) {
    return DateFormat('yyyy-MM-dd', 'ko_KR').format(dateTime);
  } else if (difference.inHours > 0) {
    return '${difference.inHours}시간 전';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes}분 전';
  } else {
    return '방금 전';
  }
}
