import 'package:flutter/material.dart';
import '../CommonWidget/MainScaffold.dart';

class AnalysisResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  Icon(Icons.report, color: Colors.orange),
                  SizedBox(width: 8.0),
                  Text(
                    '신고유형:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    '횡단보도 불법주정차',
                    style: TextStyle(
                      color: Color(0xFF862633),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {},
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
                        Image.asset(
                          'assets/images/main.png',
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 8.0,
                          left: 8.0,
                          child: Text(
                            '촬영일시: 2024/05/31 16:40:02',
                            style: TextStyle(
                              backgroundColor: Colors.white,
                              color: Colors.black,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Text('가이드라인 준수율'),
                    SizedBox(height: 8.0),
                    LinearProgressIndicator(
                      value: 0.68,
                      backgroundColor: Colors.grey[300],
                      color: Colors.blue,
                    ),
                    SizedBox(height: 8.0),
                    Text('68%'),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              _buildChecklistItem('주변 배경이 사진에 잘 담김', true),
              _buildChecklistItem('횡단보도가 사진에 잘 나타남', true),
              _buildChecklistItem('차량번호가 정확하게 나타남', true),
              _buildChecklistItem('1분 간격으로 2번 촬영하였음', false),
              _buildChecklistItem('두 사진이 동일한 각도에서 촬영됨', false),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('재촬영하기'),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('계속하기'),
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
