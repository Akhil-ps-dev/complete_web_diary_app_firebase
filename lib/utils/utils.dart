import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  return DateFormat.yMMMd().format(date);
}
