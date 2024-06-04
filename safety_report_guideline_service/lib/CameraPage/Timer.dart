import 'package:flutter/material.dart';

class CircularTimer extends StatefulWidget {
  const CircularTimer({super.key});

  @override
  _CircularTimerState createState() => _CircularTimerState();
}

class _CircularTimerState extends State<CircularTimer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Circular Timer'),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: TimerPainter(
                animation: _controller,
                backgroundColor: Colors.grey,
                color: Colors.blue,
              ),
              child: SizedBox(
                width: 200.0,
                height: 200.0,
                child: Center(
                  child: Text(
                    '${(_controller.duration! * (1.0 - _controller.value)).inSeconds}s',
                    style: const TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class TimerPainter extends CustomPainter {
  TimerPainter({
    required this.animation,
    required this.backgroundColor,
    required this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);

    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * 3.1415926535897932;
    canvas.drawArc(
      Offset.zero & size,
      3.1415926535897932 * 1.5,
      -progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
