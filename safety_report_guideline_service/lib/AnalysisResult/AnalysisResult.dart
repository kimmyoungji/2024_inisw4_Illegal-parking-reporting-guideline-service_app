import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safety_report_guideline_service/CameraPage/CameraPage.dart';
import 'package:safety_report_guideline_service/CameraPage/Timer.dart';
import 'package:safety_report_guideline_service/CompletedForm/CompletedForm.dart';
import 'package:safety_report_guideline_service/ImageDialog/ImageDialog.dart';
import 'package:safety_report_guideline_service/util/common_check_list_data.dart';
import '../CommonWidget/MainScaffold.dart';
import '../ManageProvider.dart';
import '../ReportTypeDialog/ReportTypeDialog.dart';
import '../util/check_list_data.dart';
import '../util/enums.dart';


/* 분석 페이지 클래스 */
class AnalysisResult extends StatefulWidget {
  final File imageFile;
  final List<CameraDescription> cameras;

  AnalysisResult({super.key, required this.imageFile, required this.cameras});

  @override
  State<AnalysisResult> createState() => _AnalysisResultState();
}


/* 분석 페이지 상태 클래스 */
class _AnalysisResultState extends State<AnalysisResult> {
  // 전역 변수 집합
  late Prov _prov;
  // object detection 결과 라벨
  late List<TargetObject> _labels;
  // checklistData
  late CheckListData checkListData;

  void _showReportTypedial(BuildContext context) {
      showDialog(
        barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부 결정
        context: context,
        builder: (context) {
          return ReportTypeDial();
        });
  }

  void _showImageDialog(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      barrierDismissible: true, // 바깥을 클릭해도 닫히도록 설정
      builder: (context) {
        return ImageDialog(imageFile: widget.imageFile);
      },
    );
  }

  // 체크 리스트 데이터 받아 오기
  Future<List<dynamic>> getChecklistData(ReportType report_type, List<TargetObject> labels ) async{
    // checklist: 특정 유형 체크 항목 데이터 받아 오기
    CheckListData checkListData = await CheckListData();
    await checkListData.initialize(report_type);
    await checkListData.checkObject(labels);
    List<dynamic> objectCheckListData = checkListData.objectCheckListData;
    List<dynamic> generalCheckListData = checkListData.generalCheckListData;

    // common checklist: 공통 체크항목 데이터
    CommonCheckListData commonCheckListData = await CommonCheckListData();
    await commonCheckListData.initialize();
    await commonCheckListData.checkObject(labels);
    List<dynamic> commonObjectCheckListData = commonCheckListData.objectCheckListData;
    List<dynamic> commonGeneralCheckListData = commonCheckListData.generalCheckListData;

    List<dynamic> result = [...objectCheckListData, ...commonObjectCheckListData, ...generalCheckListData, ...commonGeneralCheckListData];
    return result;
  }

  // 모델과 연결될 부분
  Future<List<TargetObject>> getModelAnalyzedResult() async {
    // 임시 하드코딩, 모델과 연결될 부분
    return await [ TargetObject.car, TargetObject.side_walk, TargetObject.stop, TargetObject.number_plate ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Consumer<Prov>(
          builder: (context, _prov, child) {
            return FutureBuilder<List<dynamic>>(
              future: _loadChecklistData(_prov),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data available'));
                }

                List<dynamic> checkListData = snapshot.data!;
                int sum = checkListData.fold(0, (value, element) => value + (element.value ? 1 : 0));
                double check_percent = double.parse((sum / checkListData.length).toStringAsFixed(1));

                return Column(
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
                          reportTypeToKorean(_prov.report_type),
                          style: TextStyle(
                            color: Color(0xFF862633),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Visibility(
                          visible: _prov.imagesList.length != 2,
                          child: ElevatedButton(
                            onPressed: () {
                              _showReportTypedial(context);
                            },
                            child: Text('변경'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Center(
                      child: GestureDetector(
                        onTap: () => _showImageDialog(context, widget.imageFile.path),
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
                    Text('${(check_percent * 100).toStringAsFixed(1)}%'),
                    SizedBox(height: 16.0),
                    Column(
                      children: List.generate(checkListData.length, (index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildChecklistItem(checkListData[index].checkItemStr, checkListData[index].value),
                          ],
                        );
                      }),
                    ),
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
                                    builder: (context) => MainScaffold(
                                        child: CameraPage(cameras: widget.cameras),
                                        title: "촬영")),
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
                                      builder: (context) => MainScaffold(
                                          child: CameraPage(cameras: widget.cameras),
                                          title: "촬영")),
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
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<List<dynamic>> _loadChecklistData(Prov _prov) async {
    // Load Data
    _labels = await getModelAnalyzedResult();
    List<dynamic> checkListData = await getChecklistData(_prov.report_type, _labels);
    return checkListData;
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