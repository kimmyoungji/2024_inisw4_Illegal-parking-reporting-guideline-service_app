import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeCheckItem {
  bool value;

  TimeCheckItem(this.value);
}

TimeCheckItem checkTime(String timezone, TimeOfDay startTime, TimeOfDay endTime, TimeOfDay photoTime) {
  // Convert the time components to minutes for easier comparison
  int startTimeInMinutes = startTime.hour * 60 + startTime.minute;
  int endTimeInMinutes = endTime.hour * 60 + endTime.minute;
  int photoTimeInMinutes = photoTime.hour * 60 + photoTime.minute;

  // Check if the photo time is within the boundary
  if (photoTimeInMinutes >= startTimeInMinutes && photoTimeInMinutes <= endTimeInMinutes) {
    return TimeCheckItem(true);
  } else {
    return TimeCheckItem(false);
  }
}

// void main() {
//   // Example usage
//   String timezone = 'UTC+05:00';
//   TimeOfDay startTime = TimeOfDay(hour: 9, minute: 0);
//   TimeOfDay endTime = TimeOfDay(hour: 17, minute: 0);
//   TimeOfDay photoTime = TimeOfDay(hour: 12, minute: 30); // Example photo time
//
//   TimeCheckItem result = checkTime(timezone, startTime, endTime, photoTime);
//   print('Is photo time within boundary? ${result.value}');
// }
