import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safety_report_guideline_service/util/enums.dart';
import '../ManageProvider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ReportTypeDial extends StatefulWidget {
  @override
  _ReportTypeDialState createState() => _ReportTypeDialState();
}


class _ReportTypeDialState extends State<ReportTypeDial>{
  late Prov _prov;
  @override
  Widget build(BuildContext context){
    _prov = Provider.of<Prov>(context);
    List<String> buttonLabels = [
      '소화전',
      '교차로 모퉁이',
      '버스정류소',
      '횡단보도',
      '어린이 보호구역',
      '인도'
    ];

    return AlertDialog(
      backgroundColor: Colors.white,
      alignment: Alignment.center,
      title: Text(
        "불법 주정차 신고 유형",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ), // 다이얼로그 제목
      content: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(buttonLabels.length, (index) {
            return Column(
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: _prov.report_type.toString() == buttonLabels[index]
                          ? Colors.blue
                          : Colors.black,
                      minimumSize: Size(300, 50)
                  ),
                  onPressed: () {
                    _prov.change_report_type(buttonLabels[index]);
                    Navigator.of(context).pop();
                    Fluttertoast.showToast(
                      msg: '${reportTypeToKorean(_prov.report_type)} 변경 완료',
                      gravity: ToastGravity.BOTTOM,
                      fontSize: 20,
                      backgroundColor: Colors.grey,
                      textColor: Colors.black,
                      toastLength: Toast.LENGTH_SHORT,
                    );
                    //print('${buttonLabels[index]} 버튼 클릭됨');
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
      ), // 다이얼로그 본문 내용
    );
  }
}
