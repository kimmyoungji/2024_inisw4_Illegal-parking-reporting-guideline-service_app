import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:safety_report_guideline_service/util/decide_reporttype.dart';

import 'package:safety_report_guideline_service/util/enums.dart';

class Prov extends ChangeNotifier {

  /* 진행 상태: 0(촬영 0번), 1(촬영 1번), 2(촬영 2번)  3(신고 완) */
  final int _report_state = 0;


  /* 신고 유형: _report_type */
  ReportType _report_type = ReportType.school_zone;
  ReportType get report_type => _report_type;
  change_report_type(String rt) {
    _report_type = koreanToReportType(rt);
    notifyListeners();
    print('$_report_type으로 변경됨');
  }
  void guess_report_type(List<dynamic> od_result ) {
    _report_type = decideReportType(od_result);
    log('$_report_type으로 변경됨');
    print('$_report_type으로 변경됨');
  }

  /* od_result */
  late List<TargetObject> _od_result = [];
  List<TargetObject> get od_result => _od_result;
  set od_result(List<dynamic> new_od_result) {
    List<TargetObject> targetObjdects = [];
    for(var i = 0; i < new_od_result.length ; i++){
      targetObjdects.add(str2TargetObj(new_od_result[i]));
    }
    _od_result = targetObjdects;
    log('$_od_result으로 변경됨');
  }


  /* image list */
  late List<File> _imagesList = [];
  List<File> get imagesList => _imagesList;
  add_img(final file){
    _imagesList.add(file);
  }
  pop_img(){
    if (_imagesList.isNotEmpty) {
      _imagesList.removeLast();
    }
  }

  /* seg image list */
  late List<File> _SegList = [];
  List<File> get SegList => _SegList;
  add_seg_img(final file){
    _SegList.add(file);
  }
  pop_seg_img(){
    if (_SegList.isNotEmpty) {
      _SegList.removeLast();
    }
  }


  /* 배경-자동차 비율 */
  double _check_backgroud= 0.4;
  double get check_backgroud => _check_backgroud;
  set car_ratio(double car_ratio){
    _check_backgroud = car_ratio;
    notifyListeners();
  }

  /* 촬영시간 */
  DateTime _photo_time = DateTime.now();
  DateTime get photo_time => _photo_time;
  set photo_time(DateTime newTime) {
    _photo_time = newTime;
  }

  
  /* 차량번호: _car_num */
  String _car_num = '51가3593';
  String get car_num => _car_num;
  change_car_num(String cn) {
    _car_num = cn;
    notifyListeners();
    print('$car_num으로 변경됨');
  }
 
  /* 초기화 */
  void reset(){
    _imagesList = [];
    _report_type = ReportType.school_zone;
  }
}

