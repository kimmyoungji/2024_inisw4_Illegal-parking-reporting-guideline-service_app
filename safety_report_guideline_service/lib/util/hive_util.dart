import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class HiveUtils {
  static Future<void> initHive() async {
    final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
    log('Json데이터 저장 경로: $appDocumentDir');
    Hive.init(appDocumentDir.path);
  }

  static Future<void> initJsonData(String jsonPath) async {
    // Open the Hive box
    final box = await Hive.openBox('guideline');

    // Check if this is the first run
    bool isFirstRun = box.get('isFirstRun', defaultValue: true);

    if (isFirstRun) {
      try {
        // Load the JSON data from the specified path
        log('json 경로: $jsonPath');
        final jsonString = await rootBundle.loadString(jsonPath);
        log('json: $jsonString');
        final jsonData = json.decode(jsonString) as Map<String, dynamic>;

        // Iterate over the items in the JSON data and add them to the box
        for (var key in jsonData.keys) {
          box.put(key, jsonData[key]);
        }

        // Set 'isFirstRun' to false to indicate that initialization is complete
        box.put('isFirstRun', false);
      } catch (e) {
        print('Error initializing JSON data: $e');
      }
    }
  }

  static Future<Box<dynamic>> openBox(String boxName) async {
    // Open a Hive box with the given name
    return await Hive.openBox(boxName);
  }

  static Future<void> closeBox(Box<dynamic> box) async {
    // Close the given Hive box
    await box.close();
  }
}
