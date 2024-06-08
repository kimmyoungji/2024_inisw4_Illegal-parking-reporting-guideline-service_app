import 'package:flutter/material.dart';
import 'dart:async';

class CameraTimerPage extends StatefulWidget {
  @override
  _CameraTimerPageState createState() => _CameraTimerPageState();
}

class _CameraTimerPageState extends State<CameraTimerPage> {
  int _timer = 60;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timer > 0) {
        setState(() {
          _timer--;
        });
      } else {
        timer.cancel();
        // 여기에 카메라 촬영 코드를 추가합니다.
        _takePicture();
      }
    });
  }

  void _takePicture() {
    // 카메라 촬영 로직을 여기에 추가합니다.
    print('Picture taken!');
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Timer'),
        leading: Icon(Icons.menu),
      ),
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Image.asset(
              'assets/images/main.png',
              fit: BoxFit.cover,
            ),
          ),
          // 타이머 표시
          Center(
            child: CircularProgressIndicatorWithText(
              value: _timer / 10,
              text: '$_timer',
            ),
          ),
          // 하단의 원형 버튼
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.camera, size: 50.0),
                    onPressed: () {
                      setState(() {
                        _timer = 10;
                        _startCountdown();
                      });
                    },
                  ),
                  SizedBox(width: 20.0),
                  IconButton(
                    icon: Icon(Icons.refresh, size: 50.0),
                    onPressed: () {
                      setState(() {
                        _timer = 10;
                        _startCountdown();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CircularProgressIndicatorWithText extends StatelessWidget {
  final double value;
  final String text;

  const CircularProgressIndicatorWithText({
    Key? key,
    required this.value,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(
            value: value,
            strokeWidth: 8.0,
            backgroundColor: Colors.grey[300],
            color: Colors.blue,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
