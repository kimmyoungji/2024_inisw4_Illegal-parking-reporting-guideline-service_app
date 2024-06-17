import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';

import '../AnalysisResult/AnalysisResult.dart';
import '../CommonWidget/MainScaffold.dart';
import '../ManageProvider.dart';
import '../ReportTypeDialog/AllPopupPage.dart';

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
    _segmentation();
  }

  @override
  Widget build(BuildContext context) {
    if (analysis) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MainScaffold(
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
                  'assets/images/loading.png', // 로컬 이미지 경로
                  fit: BoxFit.cover,
                  width: 100, //imageWidth,         // 조절 가능한 이미지 너비
                  height: 100, //imageHeight,       // 조절 가능한 이미지 높이
                ),
              ),
            ),
            Positioned(
              top: 335, // 인디케이터의 하단 위치를 조정하여 더 내림
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 115, // 인디케이터의 크기 조정
                    height: 115,
                    child: CircularProgressIndicator(
                      strokeWidth: 8,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                  SizedBox(height: 45), // 텍스트 간격 조정
                  Text('결과를 분석 중 입니다.', style: TextStyle(fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _segmentation() async {
    print("업로드 수행");
    final _prov = Provider.of<Prov>(context, listen: false);
    Dio dio = Dio();
    File? _image = _prov.imagesList.last;

    FormData formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(_image.path, filename: _image!
          .path.split('/').last),
    });

    try {
      Response response = await dio.post(
          "https://asia-northeast3-inisw04-project.cloudfunctions.net/img_process", data: formData);

      if (response.statusCode == 200) {
        print("200 response");
        Map<String, dynamic> responseData = response.data; //json 형식으로
        if(responseData['msg'].toString() == 'Model facebook/mask2former-swin-large-cityscapes-panoptic is currently loading'){
          LoadingToast('Again');
          print("다시");
          Future.delayed(const Duration(seconds: 10), (){ // 판옵틱 세그멘테이션 로딩중이라면 10초 후 재실행
            _segmentation();
          });
        }else {
          setState(() {
            analysis = true;
          });
          if (responseData['image'] != null){
            Uint8List binaryData = base64Decode(responseData['image']);
            saveImage(binaryData);
            print("저장");
          }else{
            print("segmentation 안됨");
          }
        }
        //List<dynamic> full_od_result = responseData['full_od_result']; //[{box: {xmax: 522, xmin: 279, ymax: 544, ymin: 358}, label: LABEL_1, score: 0.6640685796737671}]
        //print('full_od_result: $full_od_result');
        String msg = responseData['msg'].toString();
        print("msg: $msg"); // 에러 메세지
        LoadingToast(msg);

        // Map<String, dynamic> area = responseData['area']; // json 형태
        // if(area.isNotEmpty){
        //   String max_car_ratio = area['max_car_ratio'].toString().split("%")[0];
        //   _prov.car_ratio = double.parse(max_car_ratio);
        // }
        // // print(_prov.check_backgroud);

        List<dynamic> od_result = responseData['od_result']; // 라벨 값 [LABEL_1]
        _prov.set_result(od_result);
        print('od_result: ${_prov.origin_od_result}');
        // print(od_result[0].runtimeType); // String
        LoadingToast(od_result.toString());
        _prov.guess_report_type(od_result);


        // String area = responseData['area'].toString();
        // String max_car_ratio = responseData['area']['max_car_ratio'].toString().split("%")[0];
        // String road_ratio = responseData['area']['road_ratio'].toString().split("%")[0];
        // String sidewalk_ratio = responseData['area']['sidewalk_ratio'].toString().split("%")[0];
        // _prov.get_car_ratio(double.parse(max_car_ratio));
        // print(_prov.check_backgroud);

        String license_number = responseData['license_number'].toString();
        print('license_number: $license_number');
        _prov.change_car_num('' == license_number ? "인식X" : license_number);
      }
      print("segmentation 끝");
    } catch (e) {
      print('Error sending multipart request: $e');
      // Future.delayed(const Duration(seconds: 10), (){
      //   _segmentation();
      // });
    }
    print("업로드 끝");
  }

  Future<void> saveImage(Uint8List imageData) async {
    final _prov = Provider.of<Prov>(context, listen: false);
    String _image = _prov.imagesList.last.path;
    final file = File("${_image.substring(0, _image.length - 4)}seg.png");
    _prov.add_seg_img(file);
    await file.writeAsBytes(imageData);
  }


  void LoadingToast(String st) {
    Fluttertoast.showToast(
      msg: st,
      gravity: ToastGravity.TOP,
      fontSize: 20,
      backgroundColor: Colors.grey,
      textColor: Colors.black,
      toastLength: Toast.LENGTH_LONG,
    );
  }

}
