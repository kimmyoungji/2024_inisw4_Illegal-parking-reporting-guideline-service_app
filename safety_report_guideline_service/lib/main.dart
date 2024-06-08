import 'package:safety_report_guideline_service/CompletedForm/CompletedForm.dart';
import 'package:safety_report_guideline_service/ReportForm/ReportForm.dart';

import './IntroPage/IntroPage.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import './CommonWidget/MainScaffold.dart';
import './AnalysisResult/AnalysisResult.dart';
import './CommonWidget/MainScaffold.dart';
import './CameraPage/Timer.dart';
import './CameraPage/CameraPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 사용 가능한 카메라 반환
  final cameras = await availableCameras();
  // 카메라 전달하기
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  // 위젯이 카메라를 받을 변수
  final List<CameraDescription> cameras;
  const MyApp({super.key, required this.cameras});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),

      home: IntroPage(cameras: cameras),
      // home: CameraPage(cameras: cameras),
      // home: CameraTimerPage(),
      // home: AnalysisResult(),
      // home: ReportForm(),
      // home: CompletedForm(),

    );

  }
}
