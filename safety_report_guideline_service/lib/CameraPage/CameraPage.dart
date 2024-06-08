import 'dart:io';

import 'package:camera/camera.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../CompletedForm/CompletedForm.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraPage({super.key, required this.cameras});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController cameraController;
  late Future<void> cameraValue;
  List<File> imagesList = [];
  String? reportType;
  int selectedCameraIdx = 0;
  late Future<void> _initializeControllerFuture;

  Future<File> saveImage(XFile image) async {
    final downloadPath = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    final fileName = '${DateTime
        .now()
        .millisecondsSinceEpoch}.png';
    final file = File('$downloadPath/$fileName');

    try {
      await file.writeAsBytes(await image.readAsBytes());
    } catch (e) {
      print("Error saving image: $e");
    }

    return file;
  }

  void takePicture() async {
    XFile? image;

    if (cameraController.value.isTakingPicture ||
        !cameraController.value.isInitialized) {
      return;
    }

    image = await cameraController.takePicture();

    final file = await saveImage(image);
    setState(() {
      imagesList.add(file);
    });
    MediaScanner.loadMedia(path: file.path);

    // 여기 바꾸는
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              CompletePage(),
      )
    );

  }

  void startCamera(int camera) {
    cameraController = CameraController(
      widget.cameras[camera],
      ResolutionPreset.high,
      enableAudio: false,
    );
    cameraValue = cameraController.initialize();
  }

  void switchCamera() {
    selectedCameraIdx = selectedCameraIdx == 0 ? 1 : 0;
    startCamera(selectedCameraIdx);
  }

  @override
  void initState() {
    super.initState();
    startCamera(selectedCameraIdx); // 0은 후면 카메라, 1은 전면 카메라
    cameraToast();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Spacer(flex: 2),
                  const SizedBox(
                    width: 45,
                  ), // 좌측에 빈 공간 생성
                  const Spacer(flex: 3),
                  Container(
                    width: 80,
                    height: 80,
                    child: FloatingActionButton(
                      backgroundColor: const Color(0xFF295FE5),
                      shape: const CircleBorder(),
                      onPressed: takePicture,
                      child: const Icon(
                        Icons.camera_alt,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(flex: 3),
                  IconButton(
                    icon: const Icon(
                      Icons.switch_camera,
                      color: Colors.black,
                      size: 30,
                    ),
                    onPressed: switchCamera,
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void cameraToast(){
  Future.delayed(const Duration(seconds: 3), () {
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