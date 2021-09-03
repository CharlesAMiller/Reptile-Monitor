import 'package:intl/intl.dart';

DateTime timeFromTimeString(String time)
{
  return DateTime.fromMillisecondsSinceEpoch(int.parse(time));
}

String formatTimeHourMinute(DateTime time)
{
  var formatter = new DateFormat('jm');
  return formatter.format(time);
}
