import 'package:flutter/material.dart';

void no_car_popup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.lightBlue[50], // 다이얼로그 배경색 변경
          title: Column(
            children: [
              SizedBox(height: 15.0), // 원하는 높이의 여백 추가
              Center(
                child: Container(
                  width: double.infinity, // 가로 크기를 화면에 맞게 설정
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0), // 패딩 값 증가
                  decoration: BoxDecoration(
                    color: Colors.black, // 검정색 배경
                    borderRadius: BorderRadius.circular(20.0), // 둥근 모서리
                  ),
                  child: Center(
                    child: Text(
                      '신고 차량 미탐지',
                      textAlign: TextAlign.center, // 제목 중앙 정렬
                      style: TextStyle(
                        color: Colors.white, // 글씨 색상 흰색
                        fontWeight: FontWeight.bold, // 제목 글씨 굵게
                        fontSize: 23.0, // 글씨 크기
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          content: SizedBox(
            height: 150.0, // 원하는 높이로 설정
            child: Center( // 텍스트가 중앙에 위치하도록 변경
              child: Text(
                '신고 차량이 \n명확히 보이게\n촬영 해주세요.',
                textAlign: TextAlign.center, // 내용 중앙 정렬
                style: TextStyle(
                  color: Colors.black, // 글씨 색상
                  fontWeight: FontWeight.bold, // 내용 글씨 굵게
                  fontSize: 20.0, // 글씨 크기
                ),
              ),
            ),
          ),
        );
      },
    );
  }
void no_license_popup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.lightBlue[50], // 다이얼로그 배경색 변경
        title: Column(
          children: [
            SizedBox(height: 15.0), // 원하는 높이의 여백 추가
            Center(
              child: Container(
                width: double.infinity, // 가로 크기를 화면에 맞게 설정
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0), // 패딩 값 증가
                decoration: BoxDecoration(
                  color: Colors.black, // 검정색 배경
                  borderRadius: BorderRadius.circular(20.0), // 둥근 모서리
                ),
                child: Center(
                  child: Text(
                    '번호판 미탐지',
                    textAlign: TextAlign.center, // 제목 중앙 정렬
                    style: TextStyle(
                      color: Colors.white, // 글씨 색상 흰색
                      fontWeight: FontWeight.bold, // 제목 글씨 굵게
                      fontSize: 23.0, // 글씨 크기
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        content: SizedBox(
          height: 150.0, // 원하는 높이로 설정
          child: Center( // 텍스트가 중앙에 위치하도록 변경
            child: Text(
              '번호판이 \n명확히 보이게\n촬영 해주세요.',
              textAlign: TextAlign.center, // 내용 중앙 정렬
              style: TextStyle(
                color: Colors.black, // 글씨 색상
                fontWeight: FontWeight.bold, // 내용 글씨 굵게
                fontSize: 20.0, // 글씨 크기
              ),
            ),
          ),
        ),
      );
    },
  );
}

// void school_zone_popup(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         backgroundColor: Colors.lightBlue[50], // 다이얼로그 배경색 변경
//         title: Text(
//           '어린이 보호구역 신고',
//           textAlign: TextAlign.center, // 제목 중앙 정렬
//           style: TextStyle(
//             fontWeight: FontWeight.bold, // 제목 글씨 굵게
//           ),
//         ),
//         content: Text(
//           '어린이 보호구역 불법 주정차는\n정문 주차 차량만 신고 대상입니다.\n정문에서 촬영된 사진인가요?',
//           textAlign: TextAlign.center, // 내용 중앙 정렬
//           style: TextStyle(
//             fontWeight: FontWeight.bold, // 내용 글씨 굵게
//           ),
//         ),
//         actionsAlignment: MainAxisAlignment.spaceAround, // 버튼을 고르게 배치
//         actions: <Widget>[
//           OutlinedButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               print('Yes clicked');
//             },
//             style: OutlinedButton.styleFrom(
//               side: BorderSide(color: Colors.black), // 버튼의 테두리 색상
//               backgroundColor: Colors.black, // 버튼의 배경 색상
//               foregroundColor: Colors.white, // 글씨 색상
//             ),
//             child: Text(
//               '예',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold, // 버튼 글씨 굵게
//               ),
//             ),
//           ),
//           OutlinedButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               print('No clicked');
//             },
//             style: OutlinedButton.styleFrom(
//               side: BorderSide(color: Colors.black), // 버튼의 테두리 색상
//               backgroundColor: Colors.black, // 버튼의 배경 색상
//               foregroundColor: Colors.white, // 글씨 색상
//             ),
//             child: Text(
//               '아니요',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold, // 버튼 글씨 굵게
//               ),
//             ),
//           ),
//         ],
//       );
//     },
//   );
// }
