# 2024_inisw_team04
2024 고려대 지능정보 아카데미 04기 04조 프로젝트 : 안전신문고 불법주정차 신고 가이드라인 서비스 앱

## 소개 
촬영물을 Object Detection과 Segmentation 모델의 분석 결과를 토대로 **불법주정차의 신고 유형을 분류하고, 그에 맞는 가이드라인을 상세하게 판단해주는 서비스입니다.**

## 앱 실행 방법
[안드로이드스튜디오에서 플러터 실행 환경 구축하기](https://kmjoyit.tistory.com/183).

## 앱 설명
1. 플러터 앱 초기 페이지   
 <img src = "https://github.com/kimmyoungji/2024_inisw4_Illegal-parking-reporting-guideline-service_app/assets/127651962/5006cb24-9ab2-49a3-8360-ce6b6ecd7956" width="30%" height="40%">
 
2. 카메라 페이지
 <img src = "https://github.com/kimmyoungji/2024_inisw4_Illegal-parking-reporting-guideline-service_app/assets/127651962/ad22831c-6e15-48f5-82cc-2ef74a7f6dd5" width="30%" height="40%">
 
   기능
   - 전방 주시 토스트메세지 출력
   - 촬영
   - 갤러리에서 이미지 선택(테스트를 위한 기능)

3. 로딩 페이지: 백엔드로 요청을 보내 모델의 분석 결과를 받는다
 <img src = "https://github.com/kimmyoungji/2024_inisw4_Illegal-parking-reporting-guideline-service_app/assets/127651962/f7213ac4-936d-4115-aad2-b55c726bd842" width="30%" height="40%">
   
4. 분석 페이지: 모델의 분석 결과를 토대로 신고 유형 및 가이드 라인을 제시한다
 <img src = "https://github.com/kimmyoungji/2024_inisw4_Illegal-parking-reporting-guideline-service_app/assets/127651962/b2032428-0388-4832-b1db-a427d628ca89" width="30%" height="40%">
 <img src = "https://github.com/kimmyoungji/2024_inisw4_Illegal-parking-reporting-guideline-service_app/assets/127651962/2e8d942f-1509-4431-b2f0-52872f64664e" width="30%" height="40%">
 <img src = "https://github.com/kimmyoungji/2024_inisw4_Illegal-parking-reporting-guideline-service_app/assets/131633396/867107e3-7c84-4894-834c-53388b8e1d9a" width="30%" height="40%">

   기능
   - 예외 처리 다이얼로그
   - 신고 유형 수정 기능
   - 사진 클릭 시 세그멘테이션 결과 출력
   - 가이드 라인 준수율 시각화
   - 재촬영
  
5. 타이머 페이지: 1분 간격으로 2번 촬영을 위한 60초 타이머를 보여준다
  <img src = "https://github.com/kimmyoungji/2024_inisw4_Illegal-parking-reporting-guideline-service_app/assets/127651962/ced89690-a113-458d-8852-d067a767011f" width="30%" height="40%">
   
6. 카메라 페이지
   
  <img src = "https://github.com/kimmyoungji/2024_inisw4_Illegal-parking-reporting-guideline-service_app/assets/127651962/0fae0ed5-c12b-4894-95e6-a3caf5025388" width="30%" height="40%"> (동일각도 X)
  <img src = "https://github.com/kimmyoungji/2024_inisw4_Illegal-parking-reporting-guideline-service_app/assets/127651962/826bf895-b1cf-4a63-b5f3-733fce1fbd42" width="30%" height="40%"> (동일각도 O)

   기능
   - 첫 번째 촬영물 다시 보기
   - 전방 주시 토스트메세지 출력
   - 촬영
   - 갤러리에서 이미지 선택(테스트를 위한 기능)

7. 로딩 페이지(위와 동일)

8. 분석 페이지  
   기능
   - 사진 클릭 시 세그멘테이션 결과 출력
   - 가이드 라인 준수율 시각화
   - 재촬영

9. 신고문 작성 페이지  
   기능
   - 선택된 신고 유형 출력
   - 두 장의 촬영물 출력
   - 판단 결과를 토대로 내용 작성(ex: ~ 불법 주정차 신고입니다. 차랑 번호는 ~ 입니다.) + 수정 기능
   - 휴대전화 입력
   - 신고 내용 공유 동의 체크
   - 신고하기 버튼

10. 제출 페이지
  <img src = "https://github.com/kimmyoungji/2024_inisw4_Illegal-parking-reporting-guideline-service_app/assets/127651962/c4874c34-c7c9-4da5-a403-b1b58c914e12" width="30%" height="40%">
  
  기능
  - 초기 화면 버튼
  - 나가기 버튼

11. 네비게이션 바
  <img src = "https://github.com/kimmyoungji/2024_inisw4_Illegal-parking-reporting-guideline-service_app/assets/127651962/0bc15e3e-596d-4099-98c8-1816ce08fb00" width="30%" height="40%">
  
  기능
  - 나가기
