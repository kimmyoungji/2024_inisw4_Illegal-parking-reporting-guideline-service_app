import 'dart:io';

import 'package:flutter/material.dart';
// late TestProv _TestProv;
// 위젯 안에
// _TestProv = Provider.of<TestProv>(context);
// _TestProv.change_report_type(buttonLabels[index]);
// result = _TestProv.report_type.toString();


class Prov extends ChangeNotifier {
  // 진행 상태: 0(촬영 0번), 1(촬영 1번), 2(촬영 2번)  3(신고 완)
  final int _report_state = 0;

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

  final List<bool> _check_result_list= [false, false, false, true];
  List<bool> get check_result_list => _check_result_list;

  final bool _check_backgroud= false;
  bool get check_backgroud => _check_backgroud;

  final bool _check_object= true;
  bool get check_object => _check_object;

  final bool _check_car_num= false;
  bool get check_car_num => _check_car_num;

  final bool _check_1minute = true;
  bool get check_1minute => _check_1minute;

  final bool _check_same_angle = false;
  bool get check_same_angle => _check_same_angle;

  // 신고 유형: _report_type
  String _report_type = 'fire_hydrant'; // 나중에 바꿔
  String get report_type => _report_type; // 나중에 바꿀 거

  change_report_type(String rt) {
    _report_type = rt;
    notifyListeners();
    print('$_report_type으로 변경됨');
  }

  // 차량번호: _car_num
  String _car_num = '51가3593';

  String get car_num => _car_num;

  change_car_num(String cn) {
    _car_num = cn;
    notifyListeners();
    print('$car_num으로 변경됨');
  }

  // 휴대전화: _phone_num
  String _phone_num = '010-9411-7238';

  String get phone_num => _phone_num;

  change_phone_num(String pn) {
    _phone_num = pn;
    notifyListeners();
    print('$_phone_num으로 변경됨');
  }


}

// Image img1 = Image(image: image);
// Image(image: image);
// // 내용: _report_content
// String _report_content = '${_report_type}신고합니다. 차량 번호 ${_car_num}입니다.';
// String get report_content = _report_content;
// 찍힌 이미지: _picture
