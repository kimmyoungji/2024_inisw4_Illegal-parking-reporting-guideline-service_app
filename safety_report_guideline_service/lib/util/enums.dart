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
  Road_No_Parking, //389
  Road_Speed_Limit_in_School_Zone, //402
  Road_School_Zone, //403
  Crosswalk,
  Road_No_Stopping_or_Parking, //391
  Road_No_Stopping_Zone, //432
  stop,
  traffic_lane_yellow_solid,
  school_zone,
  no_parking,
  fire_hydrant,
  car,
  road,
  sidewalk,
  license_number
}

TargetObject str2TargetObj(String value) {
  switch (value) {
    case 'Road_No_Parking':
      return TargetObject.Road_No_Parking;
    case 'Road_Speed_Limit_in_School_Zone':
      return TargetObject.Road_Speed_Limit_in_School_Zone;
    case 'Road_School_Zone':
      return TargetObject.Road_School_Zone;
    case 'Crosswalk':
      return TargetObject.Crosswalk;
    case 'Road_No_Stopping_or_Parking':
      return TargetObject.Road_No_Stopping_or_Parking;
    case 'Road_No_Stopping_Zone':
      return TargetObject.Road_No_Stopping_Zone;
    case 'stop':
      return TargetObject.stop;
    case 'traffic_lane_yellow_solid':
      return TargetObject.traffic_lane_yellow_solid;
    case 'school_zone':
      return TargetObject.school_zone;
    case 'no_parking':
      return TargetObject.no_parking;
    case 'fire_hydrant':
      return TargetObject.fire_hydrant;
    case 'car':
      return TargetObject.car;
    case 'truck':
      return TargetObject.car;
    case 'bus':
      return TargetObject.car;
    case 'motorcycle':
      return TargetObject.car;
    case 'road':
      return TargetObject.road;
    case 'sidewalk':
      return TargetObject.sidewalk;
    case 'license_number':
      return TargetObject.license_number;
    default:
      return TargetObject.car;
  }
}
