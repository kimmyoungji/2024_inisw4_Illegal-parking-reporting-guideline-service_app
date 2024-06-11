import 'dart:developer';
import 'package:hive/hive.dart';

class CheckList {
  static final CheckList _instance = CheckList._internal();
  late ReportType _reportType;
  late List<dynamic> objectCheckList;
  late List<dynamic> generalCheckList;
  late Box<dynamic> box;

  // Private constructor
  CheckList._internal();

  // Factory constructor to return the same instance
  factory CheckList() {
    return _instance;
  }

  // Method to set the box instance
  Future<void> setBox(Box<dynamic> newBox) async {
    box = await newBox;
  }

  Future<CheckList> initialize(ReportType reportType) async {
    _reportType = reportType;
    var jsonData = await box.get(reportType.toString().split('.')[1]);
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

// List<dynamic> checkTime(){}
// List<dynamic> checkLocation(){}
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

enum ReportType {
  common,
  fire_hydrant,
  intersection_corner,
  bus_stop,
  crosswalk,
  school_zone,
  sidewalk,
}

// IP = Illeagle Parking
enum TargetObject {
  fire_hydrant,
  car,
  truck,
  stop,
  motorcycle,
  object_402,  // 402: 속도제한 어린이 보호 구역
  object_403,  // 403: 어린이 보호 구역
  object_426,  // 426: 자전거 전용 도로
  object_412,  // 412: 횡단보도
  object_432,  // 432: 정차금지지대
  object_389,  // 389: 주차금지(노면)
  object_391,  // 391: 정차주차금지516-2 := 황색복선
  traffic_lane_yellow_solid,
  school_zone,
  no_parking,
  number_plate,
  side_walk,
  road,
}

TargetObject str2TargetObj(String key) {
  switch (key) {
    case "fire_hydrant":
      return TargetObject.fire_hydrant;
    case "car":
      return TargetObject.car;
    case "truck":
      return TargetObject.truck;
    case "stop":
      return TargetObject.stop;
    case "motorcycle":
      return TargetObject.motorcycle;
    case "object_402":
      return TargetObject.object_402;
    case "object_403":
      return TargetObject.object_403;
    case "object_426":
      return TargetObject.object_426;
    case "object_412":
      return TargetObject.object_412;
    case "object_432":
      return TargetObject.object_432;
    case "object_389":
      return TargetObject.object_389;
    case "object_391":
      return TargetObject.object_391;
    case "traffic_lane_yellow_solid":
      return TargetObject.traffic_lane_yellow_solid;
    case "school_zone":
      return TargetObject.school_zone;
    case "no_parking":
      return TargetObject.no_parking;
    case "number_plate":
      return TargetObject.number_plate;
    case "side_walk":
      return TargetObject.side_walk;
    case "road":
      return TargetObject.road;
    default:
      throw Exception("Unknown target object: $key");
  }
}