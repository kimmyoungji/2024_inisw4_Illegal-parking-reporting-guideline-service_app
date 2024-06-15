import 'package:safety_report_guideline_service/util/enums.dart';

ReportType decideReportType(List<dynamic> labels){
  List<TargetObject> targetObjectList = [];
  for(var i = 0 ; i < labels.length ; i++) {
    targetObjectList.add(str2TargetObj(labels[i]));
  }

  if( targetObjectList.contains(TargetObject.school_zone) ){
    return ReportType.school_zone;
  }else if( targetObjectList.contains(TargetObject.fire_hydrant) ){
    return ReportType.fire_hydrant;
  }else if( targetObjectList.contains(TargetObject.side_walk) ){
    return ReportType.sidewalk;
  }else if( targetObjectList.contains(TargetObject.object_412) ){
    return ReportType.crosswalk;
  }else if( targetObjectList.contains(TargetObject.stop) ){
    return ReportType.bus_stop;
  }else if( targetObjectList.contains(TargetObject.traffic_lane_yellow_solid) ){
    return ReportType.intersection_corner;
  }else {
    return ReportType.intersection_corner;
  }
}