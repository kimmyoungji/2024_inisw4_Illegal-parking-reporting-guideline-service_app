import 'dart:io';
import 'package:flutter/material.dart';
import 'package:safety_report_guideline_service/util/enums.dart';

class Prov extends ChangeNotifier {
  /* 진행 상태: 0(촬영 0번), 1(촬영 1번), 2(촬영 2번)  3(신고 완) */
  final int _report_state = 0;


  /* 신고 유형: _report_type */
  ReportType _report_type = ReportType.sidewalk;
  ReportType get report_type => _report_type;
  change_report_type(String rt) {
    _report_type = koreanToReportType(rt);
    notifyListeners();
    print('$_report_type으로 변경됨');
  }


  /* image list */
  final List<File> _imagesList = [];
  List<File> get imagesList => _imagesList;
  add_img(final file){
    _imagesList.add(file);
    if (_report_state == 0){
    }
  }
  pop_img(){
    if (_imagesList.isNotEmpty) {
      _imagesList.removeLast();
    }
  }


  /* 배경-자동차 비율 */
  final double _check_backgroud= 0.4;
  double get check_backgroud => _check_backgroud;


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
}

// Image img1 = Image(image: image);
// Image(image: image);
// // 내용: _report_content
// String _report_content = '${_report_type}신고합니다. 차량 번호 ${_car_num}입니다.';
// String get report_content = _report_content;
// 찍힌 이미지: _picture
