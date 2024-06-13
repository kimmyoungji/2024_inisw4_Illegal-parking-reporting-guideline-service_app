import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safety_report_guideline_service/CameraPage/CameraPage.dart';
import 'package:safety_report_guideline_service/CameraPage/Timer.dart';
import 'package:safety_report_guideline_service/CompletedForm/CompletedForm.dart';
import '../CommonWidget/MainScaffold.dart';
import '../ManageProvider.dart';
import '../ReportTypeDialog/ReportTypeDialog.dart';

class AnalysisResult extends StatelessWidget {
  final List<CameraDescription> cameras;

  AnalysisResult({super.key, required this.cameras});

  late Prov _prov;

  Future<dynamic> _showdial(BuildContext context) {
    return showDialog(
        barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부 결정
        context: context,
        builder: (context) {
          return Dial();
        });
  }

  void _showImageDialog(BuildContext context, String imagePath) {
    final provider = Provider.of<Prov>(context, listen: false);
    File? imageFile = provider.imagesList.last;
    showDialog(
      context: context,
      barrierDismissible: true, // 바깥을 클릭해도 닫히도록 설정
      builder: (context) {
        return Dialog(
          child:  Stack(
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

  @override
  Widget build(BuildContext context) {
    _prov = Provider.of<Prov>(context);
    File imageFile = _prov.imagesList.last;
    List<bool> check_result_list = _prov.check_result_list;
    int sum = check_result_list.fold(0, (prev, element) => element ? prev + 1 : prev);
    double check_percent = sum / 5;

    if (_prov.report_type =='어린이 보호구역'){
      showCustomDialog;
    }
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
                onTap: () => _showImageDialog(context, imageFile.path),
                child: Image.file(
                  imageFile,
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
                children: List.generate(check_result_list.length, (index){
                  return Column(
                    children: [
                      _buildChecklistItem('공룡abc', check_result_list[index]),
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
                            builder: (context) => MainScaffold(child: CameraPage(cameras: cameras), title: "촬영")),
                      );
                    },
                    child: Text('재촬영하기'),
                  ),
                ),
                SizedBox(width: 16.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_prov.imagesList.length ==2) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainScaffold(child:
                                CompletePage(), title: '신고문 작성',)),
                          );
                        }
                        else{
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainScaffold(child: CameraPage(cameras: cameras), title: "촬영")
                            ),
                          );
                          showDialog(
                            barrierDismissible: true, // 나중에 false
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
      children: [
        Icon(
          isChecked ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isChecked ? Colors.blue : Colors.grey,
        ),
        SizedBox(width: 8.0),
        Text(text),
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