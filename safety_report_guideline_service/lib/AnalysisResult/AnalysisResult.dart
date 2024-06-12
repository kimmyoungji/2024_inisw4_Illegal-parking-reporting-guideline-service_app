import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safety_report_guideline_service/CameraPage/CameraPage.dart';
import 'package:safety_report_guideline_service/CameraPage/Timer.dart';
import 'package:safety_report_guideline_service/CompletedForm/CompletedForm.dart';
import 'package:safety_report_guideline_service/util/common_check_list_data.dart';
import '../CommonWidget/MainScaffold.dart';
import '../ManageProvider.dart';
import '../ReportTypeDialog/ReportTypeDialog.dart';
import '../util/check_list_data.dart';

class AnalysisResult extends StatefulWidget {
  final File imageFile;
  final List<CameraDescription> cameras;

  AnalysisResult({super.key, required this.imageFile, required this.cameras});

  @override
  State<AnalysisResult> createState() => _AnalysisResultState();
}

class _AnalysisResultState extends State<AnalysisResult> {
  late Prov _prov;
  late List<TargetObject> _labels;

  Future<dynamic> _showdial(BuildContext context) {
    return showDialog(
        barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부 결정
        context: context,
        builder: (context) {
          return Dial();
        });
  }

  void _showImageDialog(BuildContext context, File imageFile) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      pageBuilder: (context, _, __) {
        return Center(
          child: Stack(
            children: [
              Image.file(imageFile),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 체크리스트 데이터 받아오기
  List<dynamic> getChecklistData(String report_type, List<TargetObject> labels ){
    // checklist: 특정유형 체크항목 데이터 받아오기
    CheckListData checkListData = CheckListData();
    checkListData.initialize(str2ReportType(report_type));
    checkListData.checkObject(labels);
    List<dynamic> objectCheckListData = checkListData.objectCheckListData;
    List<dynamic> generalCheckListData = checkListData.generalCheckListData;

    // common checklist: 공통 체크항목 데이터
    CommonCheckListData commonCheckListData = CommonCheckListData();
    commonCheckListData.initialize();
    commonCheckListData.checkObject(labels);
    List<dynamic> commonObjectCheckListData = commonCheckListData.objectCheckListData;
    List<dynamic> commonGeneralCheckListData = commonCheckListData.generalCheckListData;

    List<dynamic> result =  [...objectCheckListData, ...generalCheckListData, ...commonObjectCheckListData, ...commonGeneralCheckListData];
    log(result.toString());
    return result;
  }

  // 모델과 연결될 부분
  List<TargetObject> getModelAnalyzedResult() {
    // 임시 하드코딩, 모델과 연결될 부분
    return [ TargetObject.car, TargetObject.side_walk, TargetObject.stop, TargetObject.number_plate ];
  }

  @override
  Widget build(BuildContext context) {
    // Provider
    _prov = Provider.of<Prov>(context);
    List<bool> check_result_list = _prov.check_result_list;

    // Load Data
    _labels = getModelAnalyzedResult();
    List<dynamic> checkListData = getChecklistData(_prov.report_type, _labels);

    // calculate data // 작업 예정 - 띵거
    int sum = check_result_list.fold(0, (prev, element) => element ? prev + 1 : prev);
    double check_percent = sum / 5;

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.report, color: Colors.orange),
                SizedBox(width: 8.0),
                Text(
                  '신고 유형:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8.0),
                Text(
                  _prov.report_type.toString(),
                  style: TextStyle(
                    color: Color(0xFF862633),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Visibility(
                  visible: _prov.imagesList.length ==2 ? false : true,
                  child: ElevatedButton(
                    onPressed: () {
                      _showdial(context);
                    },
                    child: Text('변경'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Center(
              child: GestureDetector(
                onTap: () => _showImageDialog(context, widget.imageFile),
                child: Image.file(
                  widget.imageFile,
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text('가이드 라인 준수율'),
            SizedBox(height: 8.0),
            LinearProgressIndicator(
              value: check_percent,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
            ),
            SizedBox(height: 8.0),
            Text('${check_percent * 100}%'),
            SizedBox(height: 16.0),
            Column(
                children: List.generate(checkListData.length, (index){
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildChecklistItem(checkListData[index].checkItemStr , checkListData[index].value),
                    ],
                  );
                })
            ),
            // _buildChecklistItem('주변 배경이 사진에 잘 담김', check_list[0]),
            // _buildChecklistItem('${_prov.report_type.toString()}가 사진에 잘 나타남', check_list[1]),
            // _buildChecklistItem('차량 번호가 정확하게 나타남', check_list[2]),
            // _buildChecklistItem('1분 간격으로 2번 촬영하였음', check_list[3]),
            // _buildChecklistItem('두 사진이 동일한 각도에서 촬영됨', check_list[4]),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _prov.pop_img();
                      print(_prov.imagesList);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MainScaffold(child: CameraPage(cameras: widget.cameras), title: "촬영")),
                      );
                    },
                    child: Text('재촬영하기'),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_prov.imagesList.length == 2) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainScaffold(
                                child: CompletePage(),
                                title: '신고문 작성',
                              )),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainScaffold(child: CameraPage(cameras: widget.cameras), title: "촬영")),
                        );
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              backgroundColor: Colors.transparent,
                              child: DialTimerScreen(),
                            );
                          },
                        );
                      }
                    },
                    child: Text('계속하기'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistItem(String text, bool isChecked) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          isChecked ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isChecked ? Colors.blue : Colors.grey,
        ),
        SizedBox(width: 8.0),
        Expanded(
          child: Text(
            text,
            softWrap: true,
            overflow: TextOverflow.visible,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ],
    );
  }
}