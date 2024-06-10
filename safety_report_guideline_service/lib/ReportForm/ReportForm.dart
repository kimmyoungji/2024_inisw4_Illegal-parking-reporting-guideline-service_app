import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safety_report_guideline_service/CommonWidget/MainScaffold.dart';

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

class ReportForm extends StatefulWidget {
  @override
  _ReportFormState createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (_controller.text.length >= 13) {
      _focusNode.unfocus(); // 11자리에 도달하면 키보드 닫기
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: '신고문 작성',
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('신고 유형'),
            const Text(
              '횡단보도 불법주정차',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF862633),
              ),
            ),
            const SizedBox(height: 16.0),
            _buildLabel('사진'),
            Row(
              children: [
                Image.asset(
                  'assets/images/main.png',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(width: 8.0),
                Image.asset(
                  'assets/images/main.png',
                  width: 100,
                  height: 100,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            _buildLabel('발생 지역'),
            const Text(
              '서울특별시 강북구 삼양로 지하 259',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16.0),
            _buildLabel('내용'),
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            _buildLabel('휴대전화'),
            TextField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11), // 11자리 숫자로 제한
                PhoneNumberFormatter(),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Checkbox(
                  value: false,
                  onChanged: (bool? newValue) {},
                ),
                const Text('신고 내용 공유 동의'),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('재촬영하기'),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('계속하기'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
      ),
    );
  }
}
