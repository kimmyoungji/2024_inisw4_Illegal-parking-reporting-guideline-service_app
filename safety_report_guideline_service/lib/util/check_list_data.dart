/*chat gpt used*/

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import './enums.dart';

class CheckListData {
  static final CheckListData _instance = CheckListData._internal();
  late ReportType _reportType;
  late List<dynamic> objectCheckListData;
  late List<dynamic> generalCheckListData;
  late Box<dynamic> box;

  // Private constructor
  CheckListData._internal();

  // Factory constructor to return the same instance
  factory CheckListData() {
    return _instance;
  }

  // Method to set the box instance
  Future<void> setBox(Box<dynamic> newBox) async {
    box = newBox;
  }

  Future<CheckListData> initialize(ReportType reportType) async {
    _reportType = reportType;
    var jsonData = await box.get(reportType.toString().split('.')[1]);
    objectCheckListData = jsonData['check_items']['object_checks'].entries.map((entry) {
      List<dynamic> targets = entry.key.split(',').map((key) {
          return str2TargetObj(key);
        }).toList();

      return ObjectCheckItem(
        targetObjects: targets,
        checkItemStr: entry.value,
        value: false
      );
    }).toList();

    generalCheckListData = jsonData['check_items']['general_checks'].entries.map((entry) {
      return GeneralCheckItem(
          key: entry.key,
          checkItemStr: entry.value,
          value: false
      );
    }).toList();

    return _instance;
  }

  Future<List<dynamic>> checkObject(List<TargetObject> labels) async {
    for( ObjectCheckItem checkItem in objectCheckListData ){
      for( TargetObject targetObject in checkItem.targetObjects ){
        if( labels.contains(targetObject) ){
          checkItem.value = true;
          continue;
        }
      }
    }
    return objectCheckListData;
  }

  GeneralCheckItem checkTime(TimeOfDay startTime, TimeOfDay endTime, TimeOfDay photoTime) {
    // Convert the time components to minutes for easier comparison
    int startTimeInMinutes = startTime.hour * 60 + startTime.minute;
    int endTimeInMinutes = endTime.hour * 60 + endTime.minute;
    int photoTimeInMinutes = photoTime.hour * 60 + photoTime.minute;

    // Check if the photo time is within the boundary
    if (photoTimeInMinutes >= startTimeInMinutes && photoTimeInMinutes <= endTimeInMinutes) {
      generalCheckListData[0].value = true;
      return generalCheckListData[0];
    } else {
      return generalCheckListData[0];
    }
  }

  GeneralCheckItem checkLocation(bool flag){
    if(flag){
      generalCheckListData[1].value = true;
      return generalCheckListData[1];
    }else{
      return generalCheckListData[1];
    }
  }
}

class ObjectCheckItem{
  final List<dynamic> targetObjects;
  final String checkItemStr;
  late bool value;

  ObjectCheckItem({required this.targetObjects, required this.checkItemStr, required this.value});

  @override
  String toString() {
    return 'CheckItem(targetObjects: $targetObjects, checkItemStr: $checkItemStr, value: $value)';
  }
}

class GeneralCheckItem{
  late String key;
  late String checkItemStr;
  late bool value;

  GeneralCheckItem({required this.key, required this.checkItemStr, required this.value});

  @override
  String toString() {
    return 'CheckItem(targetObjects: $key, checkItemStr: $checkItemStr, value: $value)';
  }
}


