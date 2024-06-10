import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:safety_report_guideline_service/util/guideline.dart';
import 'package:safety_report_guideline_service/util/hive_util.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 사용 가능한 카메라 반환
  final cameras = await availableCameras();

  // 플러터 프레임워크 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // hive 초기화
  await HiveUtils.initHive();
  await HiveUtils.initJsonData('assets/guideline/guideline.json');
  final box = await HiveUtils.openBox('guideline');
  Guidelines guidelines =  Guidelines();
  await guidelines.initialize(ReportType.fire_hydrant, box);

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

      // home: IntroPage(cameras: cameras),
      // home: CameraPage(cameras: cameras),
      // home: CameraTimerPage(),
      // home: AnalysisResult(),
      // home: ReportForm(),
      // home: CompletedForm(),
    );

  }
}
