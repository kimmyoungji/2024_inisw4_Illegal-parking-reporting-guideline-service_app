import 'package:hive/hive.dart';
import './check_list_data.dart';

class CommonCheckListData {
  static final CommonCheckListData _instance = CommonCheckListData._internal();
  final ReportType _reportType = ReportType.common;
  late List<dynamic> objectCheckListData;
  late List<dynamic> generalCheckListData;
  late Box<dynamic> box;

  // Private constructor
  CommonCheckListData._internal();

  // Factory constructor to return the same instance
  factory CommonCheckListData() {
    return _instance;
  }

  // Method to set the box instance
  Future<void> setBox(Box<dynamic> newBox) async {
    box = newBox;
  }

  Future<CommonCheckListData> initialize() async {
    var jsonData = await box.get(_reportType.toString().split('.')[1]);

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

  List<dynamic> checkObject(List<TargetObject> labels){
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

  // List<dynamic> check1min2(){}
  // List<dynamic> checkAngle(){}
  // List<dynamic> checkBackground(){}
}