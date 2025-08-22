# gotchai-iOS

> **Gotcha iOS** – AI와 사람을 비판적으로 구분하기 위해 AI와 인간의 답을 구분하는 튜링테스트 게임

<img width="180" alt="01" src="https://github.com/user-attachments/assets/df2f9130-3669-4f24-b583-5a618a89b808" />
<img width="180" alt="02" src="https://github.com/user-attachments/assets/f1f65767-9fe5-48be-baf1-f8e486e423f6" />
<img width="180" alt="03" src="https://github.com/user-attachments/assets/6ab245e7-9ce4-46cb-b1a8-cd16875053e3" />
<img width="180" alt="05" src="https://github.com/user-attachments/assets/7882519b-a41f-4014-acb9-3e125222f298" />
<img width="180" alt="04" src="https://github.com/user-attachments/assets/8f8c901f-4a5c-4ebd-94e9-f25822f520e1" />


<br/>

## 📖 소개

넥스터즈 27기 Gotchai! 팀의 iOS 앱 레포지토리 입니다.

### 특징


- **Tuist**를 이용해 모듈화(Modularization)를 적용했습니다.
- **The Composable Architecture**를 사용해 일관된 상태 관리와 테스트 및 구조 파악에 용이하게 개발하였습니다.
<br/>


## ✨ 주요 기능

- [x]  소셜로그인 (Apple/Kakao)
- [x]  퀴즈/게임 기능
- [x]  퀴즈 뱃지 기능
- [x]  뱃지 공유 기능

<br/>

## 🛠 기술 스택

- **언어:** Swift, SwiftUI
- **아키텍처:** TCA (Composable Architecture)
- **프로젝트 관리:** Tuist
- **네트워크:** Moya
- **의존성 관리:** Swift Package Manager (SPM)

<br/>

## 📂 프로젝트 구조

<p align="center">
<img width="500" alt="image" src="https://github.com/user-attachments/assets/30d295e3-c517-4a0d-ac98-b2b91fc492b0" />
</p>

<br/>

```
Gotchai-iOS/
├── App/                        # 엔트리 포인트 (앱 타겟)
│   └── Sources/
│       ├── GotchaiApp.swift
│       ├── AppFeature.swift
│       ├── AppView.swift
│       └── AppPath.swift
│
├── Feature/                    # 화면/도메인 단위 기능 모듈
│   ├── Onboarding/             # 온보딩 화면
│   ├── SignIn/                 # 로그인/회원가입
│   ├── Main/                   # 홈 화면/튜링테스트/퀴즈
│   ├── Profile/                # 프로필/뱃지
│   └── Setting/                # 설정
│
├── Core/                       # 비즈니스/인프라 레이어
│   ├── Auth/                   # 인증/토큰/Provider
│   ├── Network/                # 네트워크 레이어
│   ├── Key/                    # KeyChain 레이어
│   └── Common/                 # 공용 유틸, 헬퍼, 프로토콜
│
├── Shared/                     # 디자인시스템 + 유틸
│   └── DesignSystem/           # 색상, 폰트, UI 컴포넌트
│
├── Tuist/                      # Tuist 설정
│   ├── ProjectDescriptionHelpers/
│   ├── Configurations/
│   └── Tuist.swift
│
└── Workspace.swift             # tuist graph 산출물

```

- **App/**: 엔트리 포인트 (iOS Target)
- **Feature/**: 기능별 모듈 (Home, Onboarding, Profile, SignIn 등)
- **Core/**: 공용 모듈 (Network, Auth, DesignSystem 등)
- **Tuist/**: 프로젝트 정의 및 설정 파일

<br/>

## 💻 iOS 개발자

| 강민규 | 유가은 |
| :---: | :---: |
|<img width="150" src="https://github.com/koreamango.png">|<img width="150" src="https://github.com/slr-09.png"> |
|👁️👄👁️ | ˗ˏˋ(∩╹□╹∩)ˎˊ˗|
|모바일 앱 개발 러버 🙂| 병아리 개발자 🐥 |

<br/>

## 🚏 서비스


- [앱 프로토타입](https://gotchai-ai.com/)
- [앱 가이드](https://sir0.notion.site/gotchai-support?source=copy_link)

<br/>

## 📄 라이선스

이 프로젝트는 MIT License를 따릅니다.
