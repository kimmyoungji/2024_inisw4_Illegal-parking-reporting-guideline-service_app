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
  final File imageFile;
  final List<CameraDescription> cameras;

  AnalysisResult({super.key, required this.imageFile, required this.cameras});

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
    List<bool> check_result_list = _prov.check_result_list;
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
                              builder: (context) => MainScaffold(child: CameraPage(cameras: cameras), title: "촬영")),
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
<<<<<<< Updated upstream
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
=======
>>>>>>> Stashed changes
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
}