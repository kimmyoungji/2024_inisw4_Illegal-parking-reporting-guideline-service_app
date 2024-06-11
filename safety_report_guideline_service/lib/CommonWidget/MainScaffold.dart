import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../ReportTypeDialog/ReportTypeDialog.dart';

class MainScaffold extends StatefulWidget {
  final Widget
  child;
  final String title;
  const MainScaffold({super.key, required this.child, required this.title});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  String? reportType;
  late Future<void> _initializeControllerFuture;

  //bool _isReportTypeSelected = false;
  bool _isExitSelected = false;

  void _quitApp(BuildContext context) {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
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