import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ImageDialog extends StatefulWidget {
  const ImageDialog({super.key});

  @override
  State<ImageDialog> createState() => _ImageDialogState();
}

class _ImageDialogState extends State<ImageDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Image.asset(
                'assets/images/image 4.png',
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 8,
                left: 0,
                right: 0,
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.black54,
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '촬영일시: ${DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now())}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Report Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ReportForm(),
    );
  }
}

class ReportForm extends StatelessWidget {
  const ReportForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('신고문 작성'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // 메뉴 버튼 누를 때 처리
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const ImageDialog();
                  },
                );
              },
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/image 4.png',
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      color: Colors.black54,
                      padding: const EdgeInsets.all(4.0),
                      child: const Text(
                        '촬영물',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildLabelWithIcon('신고유형', 'assets/Group_53.png'),
            const SizedBox(height: 8),
            const Text('횡단보도 불법주정차', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            _buildLabelWithIcon('발생지역', 'assets/Group_53.png'),
            const SizedBox(height: 8),
            const Text('서울특별시 강북구 삼양로 지하 259', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            _buildLabelWithIcon('휴대전화', 'assets/Group_53.png'),
            const SizedBox(height: 8),
            const Text('010-9411-7238', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            _buildLabelWithIcon('내용', 'assets/Group_53.png'),
            const SizedBox(height: 8),
            const Text(
              '횡단보도 불법주정차 신고합니다. 같은 위치에 자주 불법 주정차를 하는 차량입니다.',
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // 재촬영하기 버튼 누를 때 처리
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF295FE5), // 버튼 배경색
                      foregroundColor: Colors.white, // 버튼 텍스트 색상
                    ),
                    child: const Text('재촬영하기'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // 신고하기 버튼 누를 때 처리
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF295FE5), // 버튼 배경색
                      foregroundColor: Colors.white, // 버튼 텍스트 색상
                    ),
                    child: const Text('신고하기'),
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
        const SizedBox(width: 8.0),
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }
}
