import 'dart:developer';
import 'package:hive/hive.dart';

class Guidelines {
  static final Guidelines _instance = Guidelines._internal();
  late CheckItems checkItems;

  // Private constructor
  Guidelines._internal();

  // Factory constructor to return the same instance
  factory Guidelines() {
    return _instance;
  }

  Future<void> initialize(ReportType reportType, Box<dynamic> box) async {
    var jsonData = await box.get(reportType.toString().split('.')[1]);
    log('${jsonData}');
    this.checkItems = CheckItems(objectDetection: jsonData['check_items']['object_detection'], generalChecks: jsonData['check_items']['general_checks']);
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

enum Objects {
  fire_hydrant,
  car,
  truck,
  stop,
  motorcycle,
  object_402,
  object_403,
  object_426,
  object_412,
  object_432,
  object_389,
  object_391,
  traffic_lane_yellow_solid,
  school_zone,
  no_parking
}

// CheckItems class
class CheckItems {
  final List<dynamic> objectDetection;
  final List<dynamic> generalChecks;

  CheckItems({required this.objectDetection, required this.generalChecks});

  factory CheckItems.fromJson(Map<String, dynamic> json) {
    return CheckItems(
      objectDetection: List<String>.from(json['object_detection']),
      generalChecks: List<String>.from(json['general_checks']),
    );
  }
}




