# 스펙 구현 여부 

### jdk 1.8 빌드 패키징시 java -jar was-jar-with-dependencies.jar 파일로 실행
### C:\dev\work2020\was 경로에서 구현

### 1. HTTP/1.1 의 Host 헤더를 해석하세요. (구현)

구현테스트 -> StartServerManagerTest junit 으로<br>
StartServerManager 주석풀고 테스트합니다.

host 변수 a.com,  b.com 세팅해서 테스트<br>
http://localhost:8000/index.html 호출 테스트 호스트마다 출력되는 화면변경


### 2.다음 사항을 설정 파일로 관리하세요.(구현)

GetConfig 클래스에서 global.properties JSON 형태의 설정파일로 구현

### 3.403, 404, 500 오류를 처리합니다.(구현)
### 4.다음과 같은 보안 규칙을 둡니다.(구현)
http://localhost:8000/index2.hml 호출 404 에러 페이지 호출 /error/404ErrorPage.html<br>
http://localhost:8000/main.exe 호출 403 호출 /error/403ErrorPage.html
 

### 5.logback 프레임워크 http://logback.qos.ch/를 이용하여 다음의 로깅 작업을 합니다.(구현)

프로젝트/logs 디렉토리  
전체로그: was-server.log, 파일로 출력 
오류로그: was-error.log 파일로 StackTrace 출력 

### 6.간단한 WAS 를 구현합니다. (구현)
### 7.현재 시각을 출력하는 SimpleServlet 구현체를 작성하세요 (구현)

http://localhost:8000/Hello<br> 
http://localhost:8000/service.Hello 호출

현재 시간과 각각 호출되는 sevlet url 매핑으로 호출

### 8.앞에서 구현한 여러 스펙을 검증하는 테스트 케이스를 JUnit4 를 이용해서 작성하세요. (일부구현)

StartServerManagerTest junit 테스트 주석 제거 host 명 변경으로 호출 테스트






