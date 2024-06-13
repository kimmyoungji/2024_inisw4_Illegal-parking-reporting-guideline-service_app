import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart'; // Timer를 사용하기 위해 필요
import 'dart:ui' as ui;
class OutroPage extends StatefulWidget {
  @override
  _OutroPageState createState() => _OutroPageState();
}

class _OutroPageState extends State<OutroPage> with TickerProviderStateMixin {
  late AnimationController _firstImageController;
  late AnimationController _secondImageController;
  late Animation<double> _firstImageAnimation;
  late Animation<double> _secondImageAnimation;
  String _firstImagePath = "assets/images/outro1.png"; // 첫 번째 이미지 경로 설정
  String _secondImagePath = "assets/images/outro2.png"; // 두 번째 이미지 경로 설정
  bool _showText = false; // 텍스트 표시 여부를 제어하는 변수

  @override
  void initState() {
    super.initState();
    _firstImageController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _secondImageController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _firstImageAnimation = CurvedAnimation(parent: _firstImageController, curve: Curves.easeInOut);
    _secondImageAnimation = CurvedAnimation(parent: _secondImageController, curve: Curves.easeInOut);

    _firstImageController.forward();

    // 첫 번째 애니메이션 완료 후 텍스트 표시 및 두 번째 이미지 애니메이션 시작
    _firstImageController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showText = true; // 텍스트 표시
        });

        Timer(Duration(milliseconds: 500), () {
          _firstImageController.reverse();
          _secondImageController.forward();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              child: FadeTransition(
                opacity: _firstImageAnimation,
                child: Image.asset(
                  _firstImagePath,
                  width: MediaQuery.of(context).size.width * 0.5, // 이미지 너비를 50%로 변경
                  height: MediaQuery.of(context).size.height * 0.2, // 이미지 높이를 20%로 설정
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              child: FadeTransition(
                opacity: _secondImageAnimation,
                child: Image.asset(
                  _secondImagePath,
                  width: MediaQuery.of(context).size.width * 0.5, // 이미지 너비를 50%로 변경
                  height: MediaQuery.of(context).size.height * 0.2, // 이미지 높이를 20%로 설정
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.6, // 텍스트 위치 설정
              child: _showText
                  ? Text(
                '신고가 완료되었습니다.',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              )
                  : SizedBox.shrink(),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.1,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton.icon(
                    onPressed: () {
                      print("Home button pressed");
                      //ui.Window.instance.restart();
                    },
                    icon: Icon(Icons.home),
                    label: Text('초기 화면'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      print("Exit button pressed");
                      SystemNavigator.pop();
                    },
                    icon: Icon(Icons.exit_to_app),
                    label: Text('나가기'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstImageController.dispose();
    _secondImageController.dispose();
    super.dispose();
  }
}

void main() => runApp(MaterialApp(
  home: OutroPage(),
  theme: ThemeData(
    primarySwatch: Colors.blue,
  ),
));
