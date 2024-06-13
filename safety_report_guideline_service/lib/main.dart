
import 'dart:developer';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import './IntroOutroPage/IntroPage.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../ManageProvider.dart';
import 'package:safety_report_guideline_service/util/check_list_data.dart';
import 'package:safety_report_guideline_service/util/common_check_list_data.dart';
import 'package:safety_report_guideline_service/util/hive_util.dart';
import './IntroPage/IntroPage.dart';
import './util/enums.dart';


Future<void> main() async {
  Future<void> _uploadImage(String str_uri) async {
    print("upload 수행 시작");
    File _image = await File('/storage/emulated/0/Download/1718266239380.png');


    final uri = Uri.parse(str_uri);
    var request = http.MultipartRequest('POST', uri);
    // Read the image as bytes
    List<int> imageBytes = await _image.readAsBytes();

    // Add the file to the request
    request.files.add(
      http.MultipartFile.fromBytes(
        'image', // name of the field that the server expects
        imageBytes,
        filename: "image.png", // you can provide a filename if needed
      ),
    );

    // Send the request and get the response
    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image uploaded successfully');
    } else {
      print('Image upload failed with status: ${response.statusCode}');
    }
    print("upload 끝");
  }

  List<String> API_LIST = [
    "https://api-inference.huggingface.co/models/facebook/mask2former-swin-large-cityscapes-panoptic",
    "https://api-inference.huggingface.co/models/MG31/license_aug_380_200_",
    "https://api-inference.huggingface.co/models/stoneseok/finetuning_1",

  ];
  for (String apiUrl in API_LIST) {
    _uploadImage(apiUrl);
  }

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
      // home: CameraPage(cameras: cameras),
      // home: CameraTimerPage(),
      // home: AnalysisResult(),
      // home: ReportForm(),
      // home: CompletedForm(),
    );

  }
}