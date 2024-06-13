/*chat gpt used*/

import 'package:flutter/material.dart';

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
