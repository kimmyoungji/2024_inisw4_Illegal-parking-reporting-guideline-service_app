import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainScaffold extends StatefulWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  String? reportType;
  late Future<void> _initializeControllerFuture;

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
        title: const Text('불법주정차 신고 가이드라인 서비스'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 40.0,
                    child: Icon(
                      Icons.camera_alt,
                      size: 40.0,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    '앱 이름',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('나가기'),
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
