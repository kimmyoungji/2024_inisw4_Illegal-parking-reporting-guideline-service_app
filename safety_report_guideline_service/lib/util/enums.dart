/*chat gpt used*/

enum ReportType {
  common,
  fire_hydrant,
  intersection_corner,
  bus_stop,
  crosswalk,
  school_zone,
  sidewalk,
}

String reportTypeToKorean(ReportType type) {
  switch (type) {
    case ReportType.common:
      return '공통';
    case ReportType.fire_hydrant:
      return '소화전';
    case ReportType.intersection_corner:
      return '교차로 모퉁이';
    case ReportType.bus_stop:
      return '버스정류소';
    case ReportType.crosswalk:
      return '횡단보도';
    case ReportType.school_zone:
      return '어린이 보호구역';
    case ReportType.sidewalk:
      return '인도';
    default:
      return '$type은 유효한 신고유형이 아닙니다.'; // 만약 새로운 enum 값이 추가되면 공백 문자열을 반환합니다.
  }
}

ReportType koreanToReportType(String korean) {
  switch (korean) {
    case '공통':
      return ReportType.common;
    case '소화전':
      return ReportType.fire_hydrant;
    case '교차로 모퉁이':
      return ReportType.intersection_corner;
    case '버스정류소':
      return ReportType.bus_stop;
    case '횡단보도':
      return ReportType.crosswalk;
    case '어린이 보호구역':
      return ReportType.school_zone;
    case '인도':
      return ReportType.sidewalk;
    default:
      throw ArgumentError('$korean은 유효한 신고유형이 아닙니다.'); // If the input string is invalid, an exception is thrown.
  }
}

ReportType str2ReportType(String key) {
  switch (key) {
    case "common":
      return ReportType.common;
    case "fire_hydrant":
      return ReportType.fire_hydrant;
    case "intersection_corner":
      return ReportType.intersection_corner;
    case "bus_stop":
      return ReportType.bus_stop;
    case "crosswalk":
      return ReportType.crosswalk;
    case "school_zone":
      return ReportType.school_zone;
    case "sidewalk":
      return ReportType.sidewalk;
    default:
      throw Exception("Unknown report type: $key");
  }
}

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
