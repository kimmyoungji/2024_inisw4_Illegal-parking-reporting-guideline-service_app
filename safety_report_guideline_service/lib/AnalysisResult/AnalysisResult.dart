import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:safety_report_guideline_service/CameraPage/CameraPage.dart';
import 'package:safety_report_guideline_service/CameraPage/Timer.dart';
import '../CommonWidget/MainScaffold.dart';
import '../CompletedForm/CompletedForm.dart';
import '../ManageProvider.dart';
import '../ReportTypeDialog/ReportTypeDialog.dart';

class AnalysisResult extends StatelessWidget {
  final File imageFile;
  final List<CameraDescription> cameras;

  AnalysisResult({super.key, required this.imageFile, required this.cameras});

  late Prov _prov;

  @override
  Widget build(BuildContext context) {
    _prov = Provider.of<Prov>(context);
    List<bool> check_list = [
      _prov.check_backgroud, //주변 배경
      _prov.check_object,  //탐지
      _prov.check_car_num, //차량번호
      _prov.check_1minute, //1분 후
      _prov.check_same_angle //같은 앵글
    ];
    int sum = check_list.fold(0, (prev, element) => element ? prev + 1 : prev);
    double check_percent = sum/5;

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
                  ElevatedButton(
                    onPressed: () {
                      _showdial(context);
                    },
                    child: Text('변경'),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Image.file(
                          imageFile,
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      ],
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
                    Text('${check_percent*100}%'),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              _buildChecklistItem('주변 배경이 사진에 잘 담김', check_list[0]),
              _buildChecklistItem('${_prov.report_type.toString()}가 사진에 잘 나타남', check_list[1]),
              _buildChecklistItem('차량 번호가 정확하게 나타남', check_list[2]),
              _buildChecklistItem('1분 간격으로 2번 촬영하였음', check_list[3]),
              _buildChecklistItem('두 사진이 동일한 각도에서 촬영됨', check_list[4]),
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
                              builder: (context) => MainScaffold(child: CameraPage(cameras: cameras), title: "촬영")
                          ),
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

Future<dynamic> _showdial(BuildContext context) {
  return showDialog(
      barrierDismissible: true, //바깥 영역 터치시 닫을지 여부 결정
      context: context,
      builder: (context) {
        return Dial();
      }
  );
}


