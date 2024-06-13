import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ManageProvider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Dial extends StatefulWidget {
  const Dial({super.key});

  @override
  _DialState createState() => _DialState();
}


class _DialState extends State<Dial>{
  late Prov _prov;
  @override
  Widget build(BuildContext context){
    _prov = Provider.of<Prov>(context);
    List<String> buttonLabels = [
      '소화전',
      '교차로 모퉁이',
      '버스 정류소',
      '횡단보도',
      '어린이 보호구역',
      '인도'
    ];
    return AlertDialog(
      backgroundColor: Colors.white,
      alignment: Alignment.center,
      title: const Text(
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
                      backgroundColor: _prov.report_type.toString()== buttonLabels[index]
                          ? Colors.blue
                          : Colors.black,
                      minimumSize: const Size(300, 50)
                  ),
                  onPressed: () {
                    _prov.change_report_type(buttonLabels[index]);
                    Navigator.of(context).pop();
                    Fluttertoast.showToast(
                      msg: '${_prov.report_type.toString()} 변경 완료',
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
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      )
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
          })
      ), // 다이얼로그 본문 내용
    );
  }
}
