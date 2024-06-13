import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:provider/provider.dart';
import '../ManageProvider.dart';

import 'package:safety_report_guideline_service/util/check_list_data.dart';
import 'package:safety_report_guideline_service/util/common_check_list_data.dart';
import 'package:safety_report_guideline_service/util/hive_util.dart';
import './IntroPage/IntroPage.dart';
import './util/enums.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 사용 가능한 카메라 반환
  final cameras = await availableCameras();

  // flutter frame_work 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // 내장 DB(hive) 초기화
  await HiveUtils.initHive();
  // var tempBox = await HiveUtils.openBox('guideline');
  // await tempBox.deleteAll(tempBox.keys.toList());
  await HiveUtils.initJsonData('guideline','assets/guideline/guideline.json');
  final box = await HiveUtils.openBox('guideline');

  // 특정유형 체크항목 가져오기
  CheckListData checkListData =  CheckListData();
  await checkListData.setBox(box);
  await checkListData.initialize(ReportType.sidewalk);
  // 공통 체크항목 가져오기
  CommonCheckListData commonCheckListData = CommonCheckListData();
  await commonCheckListData.setBox(box);
  await commonCheckListData.initialize();

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