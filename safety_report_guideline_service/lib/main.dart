import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

<<<<<<< Updated upstream
=======
import './IntroOutroPage/IntroPage.dart';
>>>>>>> Stashed changes
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:provider/provider.dart';
import '../ManageProvider.dart';
import './CommonWidget/MainScaffold.dart';
import './AnalysisResult/AnalysisResult.dart';
import './CommonWidget/MainScaffold.dart';
import './CameraPage/Timer.dart';
import './CameraPage/CameraPage.dart';

import 'package:safety_report_guideline_service/util/check_list.dart';
import 'package:safety_report_guideline_service/util/common_check_list.dart';
import 'package:safety_report_guideline_service/util/hive_util.dart';
import './util/check_list.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 사용 가능한 카메라 반환
  final cameras = await availableCameras();

  // 플러터 프레임워크 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // hive 초기화
  await HiveUtils.initHive();
  // var tempBox = await HiveUtils.openBox('guideline');
  // await tempBox.deleteAll(tempBox.keys.toList());
  await HiveUtils.initJsonData('guideline','assets/guideline/guideline.json');
  final box = await HiveUtils.openBox('guideline');

  CheckList checkList =  CheckList();
  await checkList.setBox(box);
  await checkList.initialize(ReportType.common);
  List<dynamic> result = checkList.checkObject([TargetObject.number_plate, TargetObject.motorcycle]);
  for( var r in result ){
    log(r.toString());
  }
  CommonCheckList commonCheckList = CommonCheckList();
  await commonCheckList.setBox(box);
  await commonCheckList.initialize();
  List<dynamic> result2 = commonCheckList.checkObject([TargetObject.car, TargetObject.motorcycle, TargetObject.number_plate]);
  for( var r in result2 ){
    log(r.toString());
  }


  // 카메라 전달하기
  runApp(
      ChangeNotifierProvider(
          create: (_) => Prov(),
          child : MyApp(cameras: cameras)
      )
  );
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
      //DialTimerScreen(),
      //IntroPage(cameras: cameras),
      // home: CameraPage(cameras: cameras),
      // home: CameraTimerPage(),
      // home: AnalysisResult(),
      // home: ReportForm(),
      // home: CompletedForm(),
    );

  }
}