/*chat gpt used*/

import 'dart:developer';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:safety_report_guideline_service/util/image_comparing.dart';
import './check_list_data.dart';
import './enums.dart';

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

  Future<GeneralCheckItem> check1min2photo(int pictureCount) async{
    log('이미지갯수 $pictureCount');
    if(pictureCount >= 2 ){
      generalCheckListData[0].value = true;
      return await generalCheckListData[0];
    }else{
      return await generalCheckListData[0];
    }
  }

  Future<GeneralCheckItem> checkAngleSimilar(List<File> imagesList) async {
    if(imagesList.length < 2){
      return await generalCheckListData[1];
    }
    log('${imagesList[0].path}, ${imagesList[1].path} 나와라 나와라 나와라');
    double similarity = await compareImages(imagesList[0].path, imagesList[1].path);
    if(similarity > 0.9 ){
      generalCheckListData[1].value = true;
      return await generalCheckListData[1];
    }else{
      return await generalCheckListData[1];
    }
  }

  Future<GeneralCheckItem> checkBackgroundRatio(double value) async {
    if(value > 0.3 && value < 0.5 ){
      generalCheckListData[2].value = true;
      return await generalCheckListData[2];
    }else{
      return await generalCheckListData[2];
    }
  }
}