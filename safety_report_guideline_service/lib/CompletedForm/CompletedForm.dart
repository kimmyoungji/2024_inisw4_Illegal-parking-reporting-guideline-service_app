

import 'dart:io';
import '../IntroOutroPage/OutroPage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:safety_report_guideline_service/IntroOutroPage/OutroPage.dart';
import '../ManageProvider.dart';

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final newText = newValue.text;
    if (newText.length > 11) {
      return oldValue;
    }
    final buffer = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      if (i == 3 || i == 7) buffer.write('-');
      buffer.write(newText[i]);
    }
    final text = buffer.toString();
    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class CompletePage extends StatefulWidget {
  @override
  State<CompletePage> createState() => _CompletePageState();
}

class _CompletePageState extends State<CompletePage> {
  bool checked_box = false;

  late Prov _prov;

  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (_phoneController.text.length >= 13) {
      _focusNode.unfocus(); // 13자리에 도달하면 키보드 닫기
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _showImageDialog(BuildContext context, File imageFile) {
    showDialog(
      context: context,
      barrierDismissible: true, // 바깥을 클릭해도 닫히도록 설정
      builder: (context) {
        return Dialog(
          child:  Stack(
            children: [
              Image.file(imageFile),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
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
  }

  @override
  Widget build(BuildContext context) {
    _prov = Provider.of<Prov>(context);
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabelWithIcon('신고 유형', 'assets/images/logo.png'),
                SizedBox(height: 8),
                Text(_prov.report_type.toString(), style: TextStyle(fontSize: 16, color: Colors.blue,)),
                SizedBox(height: 16),
                _buildLabelWithIcon('사진', 'assets/images/logo.png'),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _showImageDialog(context, _prov.imagesList[0]),

                        child: Stack(
                          children: [
                            Image.file(
                              _prov.imagesList[0],
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              bottom: 8,
                              left: 8,
                              child: Container(
                                color: Colors.black54,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    '1차 촬영물',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                    onTap: () => _showImageDialog(context, _prov.imagesList[1]),
                        child: Stack(
                          children: [
                            Image.file(
                              _prov.imagesList[1],
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              bottom: 8,
                              left: 8,
                              child: Container(
                                color: Colors.black54,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    '2차 촬영물',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    _buildLabelWithIcon('발생 지역', 'assets/images/logo.png'),
                  ],
                ),
                SizedBox(height: 8),
                Text('서울특별시 강북구 삼양로 지하 259', style: TextStyle(fontSize: 16, color: Colors.blue,)),
                SizedBox(height: 16),
                Row(
                  children: [
                    _buildLabelWithIcon('내용', 'assets/images/logo.png'),
                  ],
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: TextEditingController(text: '${_prov.report_type.toString()} 불법주정차 신고합니다. 같은 위치에 자주 불법 주정차를 하는 차량입니다. 차량 번호 ${_prov.car_num.toString()}입니다.'),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                _buildLabelWithIcon('휴대전화', 'assets/images/logo.png'),
                SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                    PhoneNumberFormatter(),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Checkbox(
                        value: checked_box,
                        onChanged: (value) {
                          setState(() {
                            checked_box = value!;
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        side: const BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text('신고 내용 공유 동의', style: TextStyle(fontSize: 16)),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: checked_box?(){
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(
                          //     content: Text('신고하기 버튼이 눌렸습니다.'),
                          //   ),
                          // );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OutroPage()),
                          );
                        }:null,
                        child: Text('신고하기'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF295FE5), // 버튼 배경색
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }

  Widget _buildLabelWithIcon(String text, String iconPath) {
    return Row(
      children: [
        Image.asset(iconPath, width: 20.0, height: 20.0),
        SizedBox(width: 8.0),
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }
}