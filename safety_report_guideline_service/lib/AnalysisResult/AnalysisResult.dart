import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:safety_report_guideline_service/CameraPage/CameraPage.dart';
import 'package:safety_report_guideline_service/CameraPage/Timer.dart';
import '../CommonWidget/MainScaffold.dart';

class AnalysisResult extends StatefulWidget {
  final File imageFile;
  final List<CameraDescription> cameras;

  const AnalysisResult({super.key, required this.imageFile, required this.cameras});

  @override
  _AnalysisResultState createState() => _AnalysisResultState();
}

class _AnalysisResultState extends State<AnalysisResult> {
  File? timestampedImage;

  @override
  void initState() {
    super.initState();
    _addTimestamp(widget.imageFile).then((file) {
      setState(() {
        timestampedImage = file;
      });
    });
  }

  Future<File> _addTimestamp(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;

    // 한국 시간으로 변환하여 현재 시간 가져오기
    final kstTime = DateTime.now().toUtc().add(Duration(hours: 9));
    String timestamp = DateFormat('yyyy/MM/dd HH:mm:ss').format(kstTime);

    int fontSize = 48;
    int padding = 10;
    int textWidth = (fontSize * timestamp.length / 2).toInt();
    int textHeight = fontSize + padding * 2;

    // 타임스탬프 텍스트 및 배경 그리기
    img.fillRect(image, 0, 0, textWidth, textHeight, img.getColor(255, 255, 255));
    img.drawString(image, img.arial_48, padding, padding, timestamp, color: img.getColor(0, 0, 0));

    final tempDir = await getTemporaryDirectory();
    // 타임스탬프가 추가된 이미지를 새로운 파일로 저장
    final newFile = File('${tempDir.path}/timestamped_image.png');
    await newFile.writeAsBytes(Uint8List.fromList(img.encodePng(image)));

    return newFile;
  }

  Future<dynamic> _showDial(BuildContext context) {
    return showDialog(
      barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부 결정
      context: context,
      builder: (context) {
        List<String> buttonLabels = ['소화전', '교차로 모퉁이', '버스 정류소', '횡단보도', '어린이 보호구역', '인도'];

        return AlertDialog(
          backgroundColor: Colors.white,
          alignment: Alignment.center,
          title: const Text(
            "불법주정차 신고 유형",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ), // 다이얼 로그 제목
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(buttonLabels.length, (index) {
              return Column(
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: const Size(300, 50),
                    ),
                    onPressed: () {
                      print('${buttonLabels[index]} 버튼 클릭됨');
                    },
                    child: Text(
                      buttonLabels[index],
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            }),
          ), // 다이얼 로그 본문 내용
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: _addTimestamp(widget.imageFile), // 페이지 빌드 시마다 타임스탬프 추가
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          timestampedImage = snapshot.data!;
          return MainScaffold(
            title: '분석 결과',
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
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
                        const Text(
                          '횡단보도 불법주정차',
                          style: TextStyle(
                            color: Color(0xFF862633),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            _showDial(context);
                          },
                          child: const Text('변경'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Center(
                      child: Column(
                        children: [
                          Image.file(
                            timestampedImage!,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 16.0),
                          const Text('가이드 라인 준수율'),
                          const SizedBox(height: 8.0),
                          LinearProgressIndicator(
                            value: 0.68,
                            backgroundColor: Colors.grey[300],
                            color: Colors.blue,
                          ),
                          const SizedBox(height: 8.0),
                          const Text('68%'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    _buildChecklistItem('주변 배경이 사진에 잘 담김', true),
                    _buildChecklistItem('횡단보도가 사진에 잘 나타남', true),
                    _buildChecklistItem('차량 번호가 정확하게 나타남', true),
                    _buildChecklistItem('1분 간격으로 2번 촬영하였음', false),
                    _buildChecklistItem('두 사진이 동일한 각도에서 촬영됨', false),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CameraPage(cameras: widget.cameras),
                                ),
                              );
                            },
                            child: const Text('재촬영하기'),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CameraTimerPage(),
                                ),
                              );
                            },
                            child: const Text('계속하기'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildChecklistItem(String text, bool isChecked) {
    return Row(
      children: [
        Icon(
          isChecked ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isChecked ? Colors.blue : Colors.grey,
        ),
        const SizedBox(width: 8.0),
        Text(text),
      ],
    );
  }
}