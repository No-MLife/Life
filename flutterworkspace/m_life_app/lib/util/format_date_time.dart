import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime).isNegative
      ? dateTime.difference(now)
      : now.difference(dateTime);

  if (difference.inDays > 0) {
    if (difference.inDays >= 7) {
      return DateFormat('yyyy-MM-dd').format(dateTime);
    } else {
      return '${difference.inDays}일 전';
    }
  } else if (difference.inHours > 0) {
    return '${difference.inHours}시간 전';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes}분 전';
  } else {
    return '방금 전';
  }
}
