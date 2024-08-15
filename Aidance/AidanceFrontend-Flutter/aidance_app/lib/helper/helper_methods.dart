import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String FormatedDate(Timestamp timestamp) {
  DateTime now = timestamp.toDate();

  // Format the date
  String formattedDate = DateFormat('MMMM d, y').format(now);

  // Format the time
  String formattedTime = DateFormat('h:mm a').format(now);

  return formattedDate;
}

String FormatedTime(Timestamp timestamp) {
  DateTime now = timestamp.toDate();

  // Format the date
  String formattedDate = DateFormat('MMMM d, y').format(now);

  // Format the time
  String formattedTime = DateFormat('h:mm a').format(now);

  return formattedTime;
}

String convertDateString(String date) {
  DateTime dateTime = DateTime.parse(date);
  String formattedDate = DateFormat('d MMMM y').format(dateTime);
  return formattedDate;
}

String FormatedDate2(Timestamp timestamp) {
  DateTime now = timestamp.toDate();

  // Format the date
  String formattedDate = DateFormat('MMMM d, yy').format(now);

  // Format the time
  String formattedTime = DateFormat('h:mm a').format(now);

  return formattedDate;
}
