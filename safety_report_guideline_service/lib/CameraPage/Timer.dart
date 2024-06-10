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
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
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
      ..color = Colors.blue.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 전체 배경 원
    canvas.drawCircle(center, radius, paint);

    // 오른쪽에서부터 칠해지도록 하는 원호
    final rect = Rect.fromCircle(center: center, radius: radius);
    final startAngle = -3.14 / 2; // 위쪽에서 시작
    final sweepAngle = -2 * 3.14 * fraction; // 오른쪽에서부터 반시계 방향으로 칠해지도록 음수로 설정
    paint.color = Colors.white;

    canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}