
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safety_report_guideline_service/CommonWidget/MainScaffold.dart';

class ReportForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: '신고문 작성',
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('신고유형'),
            Text(
              '횡단보도 불법주정차',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF862633),
              ),
            ),
            SizedBox(height: 16.0),
            _buildLabel('사진'),
            Row(
              children: [
                Image.asset(
                  'assets/images/main.png',
                  width: 100,
                  height: 100,
                ),
                SizedBox(width: 8.0),
                Image.asset(
                  'assets/images/main.png',
                  width: 100,
                  height: 100,
                ),
              ],
            ),
            SizedBox(height: 16.0),
            _buildLabel('발생지역'),
            Text(
              '서울특별시 강북구 삼양로 지하 259',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 16.0),
            _buildLabel('내용'),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            _buildLabel('휴대전화'),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Checkbox(
                  value: false,
                  onChanged: (bool? newValue) {},
                ),
                Text('신고 내용 공유 동의'),
              ],
            ),
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
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
      ),
    );
  }
}
