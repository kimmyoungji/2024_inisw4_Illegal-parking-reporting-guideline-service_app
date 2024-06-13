import 'package:flutter/material.dart';
import '../CameraPage/CameraPage.dart';
import 'package:camera/camera.dart';
import '../CommonWidget/MainScaffold.dart';
class IntroPage extends StatelessWidget {
  final List<CameraDescription> cameras;
  const IntroPage({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MainScaffold(title: '촬영',child: CameraPage(cameras: cameras),)
        ),
      );
    });

    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/main.png'),
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '고려대학교 지능정보SW 아카데미',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF862633),
                    ),
                  ),
                  TextSpan(
                    text: ' 4조',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
