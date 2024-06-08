import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainScaffold extends StatefulWidget {
  final Widget child;
  final String title;
  const MainScaffold({super.key, required this.child, required this.title});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  String? reportType;
  late Future<void> _initializeControllerFuture;

  bool _isReportTypeSelected = false;
  bool _isExitSelected = false;

  void _quitApp(BuildContext context) {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }

  Future<dynamic> _showdial(BuildContext context){
    return showDialog(
        barrierDismissible: true, //바깥 영역 터치시 닫을지 여부 결정
        context: context,
        builder: (context){
          List<String> buttonLabels = ['소화전', '교차로 모퉁이', '버스 정류소', '횡단보도', '어린이 보호구역', '인도'];

          return AlertDialog(
            backgroundColor: Colors.white,
            alignment: Alignment.center,
            title: Text(
              "불법 주정차 신고 유형",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ), // 다이얼로그 제목
            content: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(buttonLabels.length, (index){
                  return Column(
                    children:  [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.black,
                            minimumSize: Size(300, 50)
                        ),
                        onPressed: () {
                          print('${buttonLabels[index]} 버튼 클릭됨');
                        },
                        child: Text(
                            buttonLabels[index],
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            )
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  );
                })
            ),// 다이얼로그 본문 내용

            // actions. 사용자와 상호작용할 수 있도록 하는 역할
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/widget logo.png',
                      width: 250.0,
                      height: 100.0,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Image.asset(
                'assets/images/report.png',
                width: 24.0,
                height: 24.0,
              ),
              title: const Text(
                '신고 유형 선택하기',
                style: TextStyle(
                  color: Color(0xFF295FE5),
                ),
              ),
              selected: _isReportTypeSelected,
              selectedTileColor: Colors.grey[300],
              onTap: () {
                print('신고유형 선택하기 선택됨'); // 신고 유형 선택하기 버튼 클릭 시 실행할 코드로 변경 필요
                _showdial(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.exit_to_app,
                color: Color(0xFF295FE5),
                size: 23.0,
              ),
              title: const Text(
                '나가기',
                style: TextStyle(
                  color: Color(0xFF295FE5),
                ),
              ),
              selected: _isExitSelected,
              selectedTileColor: Colors.grey[300],
              onTap: () {
                _quitApp(context);
              },
            ),
          ],
        ),
      ),
      body: widget.child,
    );
  }
}