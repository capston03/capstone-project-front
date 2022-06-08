# Sticker with Beacon

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Flutter 2.10.5, Dart 2.16.2

### 프로젝트 설명
SwB (Sticker with Beacon) 는 사용자가 기억하고자 하는 에피소드를 맵에서 사진으로 확인할 수 있는 어플 입니다.

사용자가 원하는 이미지에서 물체를 인식하여 스티커(3D Model)로 만들어 AR 화면에 출력할 수 있습니다. 

이 사진을 포스트하면 근처 비콘의 위치를 인식하여 서버에 저장합니다. 

따라서 맵에서는 각 비콘에서의 사용자 에피소드를 확인할 수 있습니다. 



Dart와 Flutter를 프론트로 하여 제작된 안드로이드 어플 입니다.

---



### 어플리케이션 실행 예시

---

#### Map Page
유저 주위 500m의 반경까지 비콘이 설치 되어있는 건물을 확인합니다.
비콘이 설치된 건물을 찾으면 그 건물의 비콘들의 정보를 출력합니다.
이후 AR 페이지로 이동합니다.

<img src="https://user-images.githubusercontent.com/48765232/172561708-40d67ef0-159b-4d8c-8810-63bd3b3a7052.jpeg" width="270" height="600"> <img src="https://user-images.githubusercontent.com/48765232/172561909-0d9be0fe-6a80-48eb-a8b5-71a74f56386f.jpeg" width="270" height="600"> <img src="https://user-images.githubusercontent.com/48765232/172562793-521b3bbf-e975-49e9-b08a-ec526a5b6c0b.jpeg" width="270" height="600">

#### Episode Page

### Sticker Uploade Page
스티커 업로드 시 이미지와 제목, 내용을 입력 받습니다.
물체의 영역을 선택한 후, 선택한 영역만 3D 스티커로 변환되게 서버로 전송됩니다.
<img src="https://user-images.githubusercontent.com/48765232/172563328-a11b7522-3ae3-4b84-8baa-7fc78cd4f124.jpeg" width="270" height="600"> <img src="https://user-images.githubusercontent.com/48765232/172563482-e4a999d6-4afd-4e98-985d-417ad0f3c832.jpeg" width="270" height="600"> <img src="https://user-images.githubusercontent.com/48765232/172563608-eac3ba54-c7fd-41a3-a407-a3f5ff76bddc.jpeg" width="270" height="600"> 

#### AR Page



#### Photo to Sticker
<img src="https://user-images.githubusercontent.com/48765232/171727165-0e28911f-345a-4c44-999f-08ae95197a5c.jpg" width="270" height="600">

#### Profile
<img src="https://user-images.githubusercontent.com/48765232/171727154-1ef8aa3a-00c7-492d-8bca-97eb1781dad5.jpg" width="270" height="600">

### 어플리케이션 실행 방법

---


안드로이드 버전을 확인해 주세요. 

**SDK 2.16.2 부터 3.0.0** 까지 지원합니다. 해당 버전에 맞지 않는 OS를 사용하여 실행하는 경우 오류가 발생할 수 있습니다.

다음 코드를 flutter project 폴더에서 실행해 주세요.

```
flutter pub run flutter_launcher_icons:main
```





### 기술 스택

---


### 팀원 

---

- [Sungchan Cho](https://github.com/JoeSeongchan)
- [SeuYoon Joo](https://github.com/JooSeuYoon)
- [Namhyo Kim](https://github.com/namhyo01)

### 라이센스

---

MIT License

