import 'package:intl/intl.dart';

String formatDateTime(int messageDateTime) {
  DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(messageDateTime);
  DateFormat dateFormat = DateFormat('hh:mm a');
  return dateFormat.format(dateTime);
}
