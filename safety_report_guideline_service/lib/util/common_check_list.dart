import 'dart:developer';
import 'package:hive/hive.dart';
import './check_list.dart';

class CommonCheckList {
  static final CommonCheckList _instance = CommonCheckList._internal();
  final ReportType _reportType = ReportType.common;
  late List<dynamic> objectCheckList;
  late List<dynamic> generalCheckList;
  late Box<dynamic> box;

  // Private constructor
  CommonCheckList._internal();

  // Factory constructor to return the same instance
  factory CommonCheckList() {
    return _instance;
  }

  // Method to set the box instance
  Future<void> setBox(Box<dynamic> newBox) async {
    box = await newBox;
  }

  Future<CommonCheckList> initialize() async {
    var jsonData = await box.get(_reportType.toString().split('.')[1]);

    objectCheckList = jsonData['check_items']['object_checks'].entries.map((entry) {
      List<dynamic> targets = entry.key.split(',').map((key) {
        return str2TargetObj(key);
      }).toList();

      return ObjectCheckItem(
          targetObjects: targets,
          checkItemStr: entry.value,
          value: false
      );
    }).toList();

    generalCheckList = jsonData['check_items']['general_checks'].entries.map((entry) {
      return GeneralCheckItem(
          key: entry.key,
          checkItemStr: entry.value,
          value: false
      );
    }).toList();

    return _instance;
  }

  List<dynamic> checkObject(List<TargetObject> labels){
    for( ObjectCheckItem checkItem in objectCheckList ){
      for( TargetObject targetObject in checkItem.targetObjects ){
        if( labels.contains(targetObject) ){
          checkItem.value = true;
          continue;
        }
      }
    }
    return objectCheckList as List<dynamic>;
  }

  // List<dynamic> check1min2(){}
  // List<dynamic> checkAngle(){}
  // List<dynamic> checkBackground(){}
}