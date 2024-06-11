import 'package:flutter/material.dart';
import 'dart:async';  // Timer를 사용하기 위해 필요

class OutroPage extends StatefulWidget {
  @override
  _OutroPageState createState() => _OutroPageState();
}

class _OutroPageState extends State<OutroPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String _imagePath = "assets/images/main.png";  // 초기 이미지 경로 설정
  bool _showText = false;  // 텍스트 표시 여부를 제어하는 변수
  Timer? _imageTimer;  // 두 번째 이미지를 표시하기 위한 타이머

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    // 애니메이션 완료 후 텍스트 표시
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showText = true;  // 텍스트 표시
        });

        // 텍스트 표시 후 1초 후에 두 번째 이미지로 변경
        _imageTimer = Timer(Duration(seconds: 1), () {
          setState(() {
            _imagePath = "assets/images/check.png";  // 두 번째 이미지 경로로 업데이트
            _showText = false;  // 텍스트 숨기기
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(_imagePath),
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '신고가 완료되었습니다.',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {

              },
              child: Text('초기 화면'),
            ),
          ],
        ),
      ),
    );

  }

  @override
  void dispose() {
    _controller.dispose();
    _imageTimer?.cancel();  // 타이머가 설정되어 있으면 해제
    super.dispose();
  }
}
