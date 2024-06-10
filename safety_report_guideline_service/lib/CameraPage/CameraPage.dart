import 'dart:io';
import 'package:camera/camera.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:safety_report_guideline_service/AnalysisResult/AnalysisResult.dart';

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
    if (cameraController.value.isTakingPicture ||
        !cameraController.value.isInitialized) {
      return;
    }

    try {
      DateTime captureTime = DateTime.now();

      XFile image = await cameraController.takePicture();
      final file = await saveImage(image);
      setState(() {
        imagesList.add(file);
      });
      MediaScanner.loadMedia(path: file.path);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnalysisResult(
            imageFile: file,
            cameras: widget.cameras,
          ),
        ),
      );
    } catch (e) {
      print("Error taking picture: $e");
    }
  }

  void startCamera(int camera) {
    cameraController = CameraController(
      widget.cameras[camera],
      ResolutionPreset.high,
      enableAudio: false,
    );
    cameraValue = cameraController.initialize();
  }

  @override
  void initState() {
    super.initState();
    startCamera(selectedCameraIdx); // 0은 후면 카메라, 1은 전면 카메라
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}