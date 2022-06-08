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

#### Sticker Uploade Page
스티커 업로드 시 이미지와 제목, 내용을 입력 받습니다.

물체의 영역을 선택한 후, 선택한 영역만 3D 스티커로 변환되게 서버로 전송됩니다.

<img src="https://user-images.githubusercontent.com/48765232/172563328-a11b7522-3ae3-4b84-8baa-7fc78cd4f124.jpeg" width="270" height="600"> <img src="https://user-images.githubusercontent.com/48765232/172563482-e4a999d6-4afd-4e98-985d-417ad0f3c832.jpeg" width="270" height="600"> <img src="https://user-images.githubusercontent.com/48765232/172563608-eac3ba54-c7fd-41a3-a407-a3f5ff76bddc.jpeg" width="270" height="600"> 

#### AR Page
AR페이지에서 메뉴 버튼을 클릭하면 자신이 올린 스티커와 다른 사용자들이 올린 스티커 썸네일 사진을 볼 수 있습니다.

썸네일을 보고 어떤 3D 모델을 사용할 지 선택할 수 있으며,

3D 모델 크기 조정 및 회전이 가능합니다.

다운로드 후 3D 스티커를 배치할 수 있습니다. 또한 스티커를 업로드하면서 유저가 올린 글을 확인할 수 있습니다.

<img src="https://user-images.githubusercontent.com/48765232/172564233-7f2542fe-5ea1-4b3f-9033-86b8b1dd38c7.jpeg" width="270" height="600"> <img src="https://user-images.githubusercontent.com/48765232/172564340-fa7d1af6-5fb0-4822-b438-acc050f21b58.jpeg" width="270" height="600"> <img src="https://user-images.githubusercontent.com/48765232/172564361-3af694e4-24b4-4684-a2b0-4c95197f4a3f.jpeg" width="270" height="600"> <img src="https://user-images.githubusercontent.com/48765232/172564547-1857fb68-4785-44b0-8b3c-bbda39a4085e.jpeg" width="270" height="600"> <img src="https://user-images.githubusercontent.com/48765232/172564565-bc681b6f-e042-4a33-bee6-524d832f6e93.jpeg" width="270" height="600"> 


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

Backend: 

- 서버: Flask

- 이미지 처리: OpenCV(물체), MediaPipe(사람)

- 3D 모델링: Open3D

Frontend:

- 앱 프레임워크: Flutter

- Beacon: iBeacon

- AR: ar_flutter_plugin  

<img src="https://user-images.githubusercontent.com/48765232/172565884-f4973bd3-9af7-4bc4-8ca3-324282d3b4d9.png" width="800" height="400">


### 기능 구현

---

- 기능 1: 비콘으로 사용자의 정확한 위치 탐지 

- 기능 2: 3D 모델을 AR 화면에 출력 

- 기능 3: 2D 이미지에서 배경 제거

- 기능 4: 배경이 제거된 2D 이미지를 3D 모델로 변환 (렌더링)

<img src="https://user-images.githubusercontent.com/48765232/172566931-272effe3-1574-4dec-aa8b-1d34f877ba18.png" width="1775" height="920">

- 기능 1: 비콘으로 사용자의 정확한 위치 탐지 (Flutter blue 패키지 사용)


앱이 비콘을 인식하면 해당 비콘의 이름이 특정 패턴 (TRC-***)을 만족하는지 확인합니다. 

그런 다음 해당 비콘의 MAC 주소를 데이터베이스에서 검색하여 이 비콘이 어느 건물의 어떤 위치에 설치되었는지 확인합니다. 

이렇게 하여 사용자의 현재 위치를 찾아냅니다.


- 기능 2: 3D 모델을 AR 화면에 출력

앱은 사용자 근처에서 업로드된 모든 3D 모델의 썸네일을 다운로드합니다. 

유저는 썸네일을 보고 자신이 원하는 3D 모델을 선택하여 다운로드합니다. 

다운로드한 다음, 유저가 AR 화면을 클릭하면 바로 그 위치에 3D 모델이 들어갑니다. 

3D 모델의 크기와 각도를 조정하여 구도를 원하는대로 설정할 수 있습니다. 

그런 다음 3D 모델을 촬영할 수 있습니다. 촬영된 사진은 스마트폰 갤러리에 저장됩니다.

<img src="https://user-images.githubusercontent.com/48765232/172567203-bbd54af1-9fe6-428d-acae-6d0c169651f8.png" width="1775" height="920">

- 기능 3: 2D 이미지에서 배경 제거

사용자는 사진을 업로드하기 전에 오브젝트 영역을 지정합니다. 

이미지 파일와 함께 오브젝트 영역의 좌표값도 같이 서버로 전달합니다. 

서버는 OpenCV의 Grabcut 알고리즘으로 배경과 전경을 분리합니다. 

Grabcut 알고리즘은 사용자로부터 전경과 배경에 대한 정보를 전달 받아 이를 이미지 분리에 활용하는 알고리즘입니다. 

사진을 업로드할 때 유저가 선택한 오브젝트 영역이 바로 여기에 활용됩니다.

(단 픽셀값의 차이가 분명한 경우에만 Grabcut 알고리즘을 적용할 수 있습니다. 

전경과 배경의 색과 밝기가 비슷한 사진에는 Grabcut 알고리즘을 적용할 수 없습니다.)


물체가 아닌 사람의 경계를 따야 하는 경우에는 Grabcut 대신 MediaPipe의 Selfie Segmentation API를 사용합니다. 

Grabcut 알고리즘보다 빠르고 정확하게 배경과 전경을 분리합니다. 

(단 전경이 사람인 경우에만 적용할 수 있습니다. 

따라서 유저가 사진을 업로드할 때 전경이 사람인지 물체인지 서버에게 꼭 알려줘야 합니다.)



- 기능 4: 배경이 제거된 2D 이미지를 3D 모델로 변환 (렌더링)
배경이 제거된 2D 사진을 픽셀 배열로 만듭니다. 픽셀 배열로 여러 vertex를 만듭니다. 

vertex는 3D 좌표 평면 안에서 하나의 점을 말함. 하나의 점을 3개 모으면 삼각형(Triangle)이 만들어집니다. 

삼각형을 촘촘히 모아 3D 모델을 만듭니다. 이것이 3D 모델을 만드는 기본적인 방법입니다. 

vertex 하나하나에 RGB 값을 부여하면 그 vertex가 모여 만드는 triangle에 색을 칠할 수 있습니다. 

이렇게 만든 3D 모델을 .glb 파일로 export하고 백엔드 Storage에 저장합니다. 

이렇게 하면 누구나 이 스티커를 다운로드 받을 수 있습니다.


### 팀원 

---

- [Sungchan Cho](https://github.com/JoeSeongchan)
    - 서버, 이미지 처리, 3D 렌더링 담당
- [SeuYoon Joo](https://github.com/JooSeuYoon)
    - UI, 지도, 관리 페이지 담당
- [Namhyo Kim](https://github.com/namhyo01)
    - 비콘, AR, UI 담당


### 라이센스

---

MIT License

