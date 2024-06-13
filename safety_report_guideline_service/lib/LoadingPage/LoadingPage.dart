import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';

import 'package:provider/provider.dart';

import '../AnalysisResult/AnalysisResult.dart';
import '../CommonWidget/MainScaffold.dart';
import '../ManageProvider.dart';

class LoadingPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  LoadingPage({super.key, required this.cameras});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  bool analysis = false;
  @override
  void initState() {
    super.initState();
    _uploadImage();
  }

  @override
  Widget build(BuildContext context) {
    if (analysis) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MainScaffold(
                child: AnalysisResult(cameras: widget.cameras),
                title: '신고문 작성',
              )),
        );
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: 345, // 이미지의 상단 위치를 조정하여 더 위로 올림
              child: Opacity(
                opacity: 0.5,
                child: Image.asset(
                  'assets/images/loading.png',  // 로컬 이미지 경로
                  fit: BoxFit.cover,
                  width: 100,//imageWidth,         // 조절 가능한 이미지 너비
                  height: 100,//imageHeight,       // 조절 가능한 이미지 높이
                ),
              ),
            ),
            Positioned(
              top : 335, // 인디케이터의 하단 위치를 조정하여 더 내림
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 115,  // 인디케이터의 크기 조정
                    height: 115,
                    child: CircularProgressIndicator(
                      strokeWidth: 8,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                  SizedBox(height: 45),  // 텍스트 간격 조정
                  Text('결과를 분석 중 입니다.', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  void _uploadImage() async {
    print("업로드 수행");
    final _prov =  Provider.of<Prov>(context, listen: false);
    Dio dio = Dio();
    File? _image = _prov.imagesList.last;

    log(_image.toString());
    FormData formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(_image.path, filename: _image!.path.split('/').last),
    });

    try {
      Response response = await dio.post(
          //"https://asia-northeast3-inisw04-project.cloudfunctions.net/area"  , data: formData);
        "https://asia-northeast3-inisw04-project.cloudfunctions.net/img_process", data: formData);
      if (response.statusCode ==200) {
        setState(() {
          analysis = true;
        });
        print(response.data);
      }
    } catch (e) {
      print('Error sending multipart request: $e');
      Future.delayed(const Duration(seconds: 10), (){
        _uploadImage();
      });
    }
    print("업로드 끝");
  }
}