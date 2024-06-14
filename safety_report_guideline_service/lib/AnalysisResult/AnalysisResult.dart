import 'dart:async';
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
  final List<CameraDescription> cameras;

  const AnalysisResult({super.key, required this.cameras});

  @override
  State<AnalysisResult> createState() => _AnalysisResultState();
}


/* 분석 페이지 상태 클래스 */
class _AnalysisResultState extends State<AnalysisResult> {
  // object detection 결과 라벨
  late List<TargetObject> _labels;
  // checklistData
  late CheckListData checkListData;

  void _showReportTypeDialog(BuildContext context) {
      showDialog(
        barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부 결정
        context: context,
        builder: (context) {
          return const ReportTypeDial();
        });
  }

  void _showImageDialog(BuildContext context, File imageFile) {
    showDialog(
      context: context,
      barrierDismissible: true, // 바깥을 클릭해도 닫히도록 설정
      builder: (context) {
        return ImageDialog(imageFile: imageFile);
      },
    );
  }

  // 체크 리스트 데이터 받아 오기
  Future<List<dynamic>> getChecklistData(Prov prov, List<TargetObject> labels) async{
    // checklist: 특정 유형 체크 항목 데이터 받아 오기
    CheckListData checkListData = CheckListData();
    await checkListData.initialize(prov.report_type);
    await checkListData.checkObject(labels);
    if(prov.report_type == ReportType.school_zone){
      checkListData.checkTime(const TimeOfDay(hour: 9, minute: 00), const TimeOfDay(hour: 20, minute: 00), TimeOfDay(hour: prov.photo_time.hour, minute: prov.photo_time.minute));
    }
    List<dynamic> objectCheckListData = checkListData.objectCheckListData;
    List<dynamic> generalCheckListData = checkListData.generalCheckListData;

    // common checklist: 공통 체크항목 데이터
    CommonCheckListData commonCheckListData = CommonCheckListData();
    await commonCheckListData.initialize();
    commonCheckListData.checkObject(labels);
    await commonCheckListData.check1min2photo(prov.imagesList.length);
    await commonCheckListData.checkAngleSimilar(prov.imagesList);
    await commonCheckListData.checkBackgroundRatio(prov.check_backgroud);
    List<dynamic> commonObjectCheckListData = commonCheckListData.objectCheckListData;
    List<dynamic> commonGeneralCheckListData = commonCheckListData.generalCheckListData;

    List<dynamic> result = [...objectCheckListData, ...commonObjectCheckListData, ...generalCheckListData, ...commonGeneralCheckListData];
    return result;
  }

  // 모델과 연결될 부분
  Future<List<TargetObject>> getModelAnalyzedResult() async {
    // 임시 하드코딩, 모델과 연결될 부분
    return [ TargetObject.car, TargetObject.side_walk, TargetObject.stop, TargetObject.number_plate ];
  }

  Future<dynamic> _showReportTypeDial(BuildContext context) {
    return showDialog(
        barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부 결정
        context: context,
        builder: (context) {
          return ReportTypeDial();
        });
  }

  @override
  Widget build(BuildContext context) {
    final _prov = Provider.of<Prov>(context);
    // if (reportTypeToKorean(_prov.report_type)=='어린이 보호구역' ){
    //   showCustomDialog(context);
    // }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Consumer<Prov>(
          builder: (context, prov, child) {
            return FutureBuilder<List<dynamic>>(
              future: _loadChecklistData(prov),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available'));
                }

                List<dynamic> checkListData = snapshot.data!;
                int sum = checkListData.fold(0, (value, element) => value + (element.value ? 1 : 0));
                double checkPercent = double.parse((sum / checkListData.length).toStringAsFixed(1));

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.report, color: Colors.orange),
                        const SizedBox(width: 8.0),
                        const Text(
                          '신고 유형:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          reportTypeToKorean(prov.report_type),
                          style: const TextStyle(
                            color: Color(0xFF862633),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Visibility(
                          visible: prov.imagesList.length != 2,
                          child: ElevatedButton(
                            onPressed: () {
                              String before = reportTypeToKorean(prov.report_type);
                              _showReportTypeDialog(context);
                              String after = reportTypeToKorean(prov.report_type);

                            },
                            child: const Text('변경'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Center(
                      child: GestureDetector(
                        onTap: () => _showImageDialog(context, prov.SegList.length == prov.imagesList.length ? prov.SegList.last :prov.imagesList.last),
                        child: Image.file(
                          prov.imagesList.last,
                          width: 300,
                          height: 300,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Text('가이드 라인 준수율'),
                    const SizedBox(height: 8.0),
                    LinearProgressIndicator(
                      value: checkPercent,
                      backgroundColor: Colors.grey[300],
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 8.0),
                    Text('${(checkPercent * 100).toStringAsFixed(1)}%'),
                    const SizedBox(height: 16.0),
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
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              prov.pop_img();
                              print(prov.imagesList);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainScaffold(
                                        title: "촬영",
                                        child: CameraPage(cameras: widget.cameras))),
                              );
                            },
                            child: const Text('재촬영하기'),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (prov.imagesList.length == 2) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MainScaffold(
                                        title: '신고문 작성',
                                        child: CompletePage(),
                                      )),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MainScaffold(
                                          title: "촬영",
                                          child: CameraPage(cameras: widget.cameras))),
                                );
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const Dialog(
                                      backgroundColor: Colors.transparent,
                                      child: DialTimerScreen(),
                                    );
                                  },
                                );
                              }
                            },
                            child: const Text('계속하기'),
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

  Future<List<dynamic>> _loadChecklistData(Prov prov) async {
    // Load Data
    _labels = await getModelAnalyzedResult();
    List<dynamic> checkListData = await getChecklistData(prov, _labels);
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
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            text,
            softWrap: true,
            overflow: TextOverflow.visible,
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
      ],
    );
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.lightBlue[50], // 다이얼로그 배경색 변경
          title: Text(
            '어린이 보호구역 신고',
            textAlign: TextAlign.center, // 제목 중앙 정렬
            style: TextStyle(
              fontWeight: FontWeight.bold, // 제목 글씨 굵게
            ),
          ),
          content: Text(
            '어린이 보호구역 불법 주정차는\n정문 주차 차량만 신고 대상입니다.\n정문에서 촬영된 사진인가요?',
            textAlign: TextAlign.center, // 내용 중앙 정렬
            style: TextStyle(
              fontWeight: FontWeight.bold, // 내용 글씨 굵게
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceAround, // 버튼을 고르게 배치
          actions: <Widget>[
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
                print('Yes clicked');
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.black), // 버튼의 테두리 색상
                backgroundColor: Colors.black, // 버튼의 배경 색상
                foregroundColor: Colors.white, // 글씨 색상
              ),
              child: Text(
                '예',
                style: TextStyle(
                  fontWeight: FontWeight.bold, // 버튼 글씨 굵게
                ),
              ),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
                print('No clicked');
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.black), // 버튼의 테두리 색상
                backgroundColor: Colors.black, // 버튼의 배경 색상
                foregroundColor: Colors.white, // 글씨 색상
              ),
              child: Text(
                '아니요',
                style: TextStyle(
                  fontWeight: FontWeight.bold, // 버튼 글씨 굵게
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  
}