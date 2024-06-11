import 'dart:async';
import 'package:flutter/material.dart';

class DialTimerScreen extends StatefulWidget {
  @override
  _DialTimerScreenState createState() => _DialTimerScreenState();
}

class _DialTimerScreenState extends State<DialTimerScreen> {
  static const int totalDuration = 60; // 전체 시간 (초)
  int remainingTime = totalDuration;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          timer.cancel(); // 끝내기
          Navigator.of(context).pop();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 70), // 글자를 더 위로 올리기 위해 조절
          Visibility(
            visible: remainingTime > 0,
            child: Text(
              '60초 후에 재촬영 해주세요.',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 40), // 한글과 타이머 사이에 빈 박스 추가
          Visibility(
            visible: remainingTime > 0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  painter: DialPainter(remainingTime / totalDuration),
                  child: Container(
                    width: 200,
                    height: 200,
                  ),
                ),
                Text(
                  '$remainingTime',
                  style: TextStyle(
                    fontSize: 40, // 텍스트 크기 유지
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}

class DialPainter extends CustomPainter {
  final double fraction;

  DialPainter(this.fraction);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 전체 배경 원
    canvas.drawCircle(center, radius, paint);

    // 오른쪽에서부터 칠해지도록 하는 원호
    final rect = Rect.fromCircle(center: center, radius: radius);
    final startAngle = -3.14 / 2; // 위쪽에서 시작
    final sweepAngle = -2 * 3.14 * fraction; // 오른쪽에서부터 반시계 방향으로 칠해지도록 음수로 설정
    paint.color = Colors.blue;

    canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}