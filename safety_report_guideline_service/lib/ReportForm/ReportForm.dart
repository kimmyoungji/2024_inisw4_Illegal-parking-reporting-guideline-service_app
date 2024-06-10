import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Report Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ReportForm(),
    );
  }
}

class ReportForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('신고문 작성'),
        leading: Icon(Icons.menu),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabelWithIcon('신고유형', 'assets/images/Group 53.png'),
            Text(
              '횡단보도 불법주정차',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF862633),
              ),
            ),
            SizedBox(height: 16.0),
            _buildLabelWithIcon('사진', 'assets/images/Group 53.png'),
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
            _buildLabelWithIcon('발생지역', 'assets/images/Group 53.png'),
            Text(
              '서울특별시 강북구 삼양로 지하 259',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 16.0),
            _buildLabelWithIcon('내용', 'assets/images/Group 53.png'),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            _buildLabelWithIcon('휴대전화', 'assets/images/Group 53.png'),
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

  Widget _buildLabelWithIcon(String text, String iconPath) {
    return Row(
      children: [
        Image.asset(iconPath, width: 20.0, height: 20.0),
        SizedBox(width: 8.0),
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }
}
