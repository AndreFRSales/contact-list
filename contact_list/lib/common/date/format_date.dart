import 'package:intl/intl.dart';

class FormatDate {
  final _formatter = DateFormat('d/M/y');

  String format(DateTime? date) {
    if (date == null) return "";
    return _formatter.format(date);
  }
}
