# 스펙 구현 여부 


## 1. HTTP/1.1 의 Host 헤더를 해석하세요. (구현)

구현테스트 -> StartServerManagerTest junit 으로

host 값 a.com,  b.com 세팅해서 테스트

http://localhost:8000/index.html 호출 테스트 호스트마다 출력되는 화면변경


## 2.다음 사항을 설정 파일로 관리하세요.(구현)
## 3.403, 404, 500 오류를 처리합니다.(구현)
## 4.다음과 같은 보안 규칙을 둡니다.(구현)

StartServerManagerTest junit 으로 테스트 

host a.com, b.com 에따라 디렉토리 다르게 index.html 호출

http://localhost:8000/index2.hml 호출 404 에러 페이지 호출
http://localhost:8000/nhn.exe 호출 403 호출








