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

  Future<void> initialize(ReportType reportType) async {
    _reportType = reportType;
    var jsonData = await box.get(reportType.toString().split('.')[1]);
    log(jsonData['check_items']['object_checks'].toString());
  }
}

class CheckItem{
  final List<IPObject>
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
enum IPObject {
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