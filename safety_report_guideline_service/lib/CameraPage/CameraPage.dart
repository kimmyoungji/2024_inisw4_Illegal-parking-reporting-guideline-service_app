
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:external_path/external_path.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:provider/provider.dart';
import 'package:safety_report_guideline_service/AnalysisResult/AnalysisResult.dart';
import 'package:safety_report_guideline_service/IntroOutroPage/OutroPage.dart';
import 'package:safety_report_guideline_service/LoadingPage/LoadingPage.dart';
import '../CommonWidget/MainScaffold.dart';
import '../ManageProvider.dart';

/* 카메라 페이지 */
class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraPage({super.key, required this.cameras});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

/* 카메라 페이지 State */
class _CameraPageState extends State<CameraPage> {
  final ImagePicker _picker = ImagePicker();
  late CameraController cameraController;
  late Future<void> cameraValue;
  String? reportType;
  int selectedCameraIdx = 0;

  @override
  void initState() {
    super.initState();
    cameraController = CameraController(
      widget.cameras[selectedCameraIdx],
      ResolutionPreset.high,
      enableAudio: false,
    );
    cameraValue = cameraController.initialize();

    // 페이지 진입 시 Toast 메시지 표시
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cameraProvider = Provider.of<Prov>(context, listen: false);
      cameraToast(cameraProvider.imagesList.isEmpty);
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  Future<File> saveImage(XFile ximage) async {
    final downloadPath = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File('$downloadPath/$fileName');

    final bytes = await ximage.readAsBytes();
    img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;

    // 카메라의 방향에 따라 이미지 회전
    // final int rotationDegrees = getCameraRotation(cameraController.description.sensorOrientation);
    // image = img.copyRotate(image, rotationDegrees);

    // 한국 시간으로 변환하여 현재 시간 가져오기
    final kstTime = DateTime.now().toUtc().add(const Duration(hours: 9));
    String timestamp = DateFormat('yyyy/MM/dd HH:mm:ss').format(kstTime);

    int fontSize = 48;
    int padding = 10;
    int textWidth = fontSize * timestamp.length ~/ 2;
    int textHeight = fontSize + padding * 2;

    // 타임스탬프 텍스트 및 배경 그리기
    img.fillRect(image, 0, 0, textWidth, textHeight, img.getColor(255, 255, 255));
    img.drawString(image, img.arial_48, padding, padding, timestamp, color: img.getColor(0, 0, 0));

    // 타임스탬프가 추가된 이미지를 새로운 파일로 저장
    await file.writeAsBytes(Uint8List.fromList(img.encodePng(image)));

    return file;
  }

  int getCameraRotation(int sensorOrientation) {
    switch (sensorOrientation) {
      case 90:
        return 90;
      case 270:
        return -90;
      case 180:
        return 180;
      default:
        return 0;
    }
  }


  void cameraToast(bool isListEmpty) {
    final duration = isListEmpty ? Duration(seconds: 3) : Duration(seconds: 61);
    Future.delayed(duration, () {
      Fluttertoast.showToast(
        msg: '주변을 주시하세요.',
        gravity: ToastGravity.TOP,
        fontSize: 20,
        backgroundColor: Colors.grey,
        textColor: Colors.black,
        toastLength: Toast.LENGTH_LONG,
      );
    });
  }

  void takePicture(BuildContext context) async {
    final cameraProvider = Provider.of<Prov>(context, listen: false);

    if (cameraController.value.isTakingPicture ||
        !cameraController.value.isInitialized) {
      return;
    }

    try {
      
      DateTime captureTime = DateTime.now();
      cameraProvider.photo_time = captureTime;

      XFile image = await cameraController.takePicture();
      final file = await saveImage(image);
      cameraProvider.add_img(file);
      print(cameraProvider.imagesList);

      MediaScanner.loadMedia(path: file.path);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoadingPage(cameras: widget.cameras),
        ),
      );

      // 이미지 리스트의 상태에 따라 Toast 메시지 표시 시간 설정
      if (cameraProvider.imagesList.isEmpty) {
        cameraToast(true);
      } else {
        cameraToast(false);
      }

    } catch (e) {
      print("Error taking picture: $e");
    }
  }

  Future<void> _pickImage() async {
    final cameraProvider = Provider.of<Prov>(context, listen: false);
    File? _image;
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    }
    cameraProvider.add_img(_image);
    print(cameraProvider.imagesList);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoadingPage(cameras: widget.cameras),
      ),
    );
  }


//   void switchCamera() {
//     setState(() {
//       selectedCameraIdx = (selectedCameraIdx + 1) % widget.cameras.length;
//       cameraController = CameraController(
//         widget.cameras[selectedCameraIdx],
//         ResolutionPreset.high,
//         enableAudio: false,
//       );
//       cameraValue = cameraController.initialize();
//     });
//   }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: cameraValue,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SizedBox(
                  width: size.width,
                  height: size.height,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: size.width,
                      height: size.height,
                      child: CameraPreview(cameraController),
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              height: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),
                  Consumer<Prov>(
                    builder: (context, cameraProvider, child) {
                      if (cameraProvider.imagesList.isNotEmpty) {
                        return GestureDetector(
                          onTap: () {
                            showGeneralDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierLabel: MaterialLocalizations.of(context)
                                  .modalBarrierDismissLabel,
                              pageBuilder: (context, _, __) {
                                return Center(
                                  child: Stack(
                                    children: [
                                      Image.file(cameraProvider.imagesList.first),
                                      Positioned(
                                        top: 10,
                                        right: 10,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(cameraProvider.imagesList.first),
                                fit: BoxFit.cover,
                              ),
                              color: Colors.grey,
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox(width: 60, height: 60); // 빈 공간 생성
                      }
                    },
                  ),
                  const Spacer(flex: 3),
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: FloatingActionButton(
                      backgroundColor: const Color(0xFF295FE5),
                      shape: const CircleBorder(),
                      onPressed: () => takePicture(context),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(flex: 3),
                  SizedBox(
                    width: 55,
                    height: 55,
                    child: ElevatedButton(
                    onPressed: (){
                      print("시작");
                        _pickImage();
                      print("끝");
                    },
                      child: Text('G'),
                  ),
                  ),
                  const Spacer(flex: 3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

