//
//  AppFeature.swift
//  Gotchai
//
//  Created by 가은 on 8/2/25.
//
import TCA
import Onboarding
import SignIn
import Main // 모듈명이 Swift의 @main 과 헷갈리면 이름 변경 고려
import Setting
import Key
import Auth
import Common
import Combine

@Reducer
struct AppFeature {
    @Dependency(\.authClient) var authClient
    @Dependency(\.autoAuthProvider) var autoAuthProvider

    struct State {
        enum Root: Equatable { case booting, onboarding, signIn, main }
        var root: Root = .booting
        var onboarding = OnboardingFeature.State()
        var signIn     = SignInFeature.State()
        var main = MainFeature.State()
        var turingTest = TuringTestFeature.State()

        var path = StackState<AppPath.State>()
    }

    enum Action {
        case onboarding(OnboardingFeature.Action)
        case signIn(SignInFeature.Action)
        case setRoot(State.Root)
        case main(MainFeature.Action)

        case path(StackActionOf<AppPath>)

        // 👇 자동 로그인 트리거 & 결과
        case appLaunched
        case signInResponse(Result<UserSession, Error>)
    }

    // 핵심 리듀서를 분리(타입 추론 안정화)
    private var core: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                // 앱이 켜지면 자동 로그인 시도
            case .appLaunched:
                authClient.deleteUser()
                    
                return .publisher {
                  authClient.signIn(autoAuthProvider)
                    .map { .signInResponse(.success($0)) }
                    .catch { Just(.signInResponse(.failure($0))) }
                }
            
            case let .signInResponse(.success(session)):
                print("자동 로그인 성공")
              state.root = session.token.isEmpty ? .onboarding : .main
              return .none

            case .signInResponse(.failure):
                print("자동 로그인 실패")
                state.root = .onboarding
              return .none

                // 온보딩 → 로그인으로
            case .onboarding(.delegate(.navigateToSignIn)):
                state.root = .signIn
                return .none

                // 로그인 성공 → 메인으로
            case .signIn(.delegate(.didSignIn)):
                state.root = .main
                return .none

            case let .main(.delegate(mainAction)):
                switch mainAction {
                case .openTuringTest(let id):
                    state.turingTest = .init(turingTestID: id)
                    state.path.append(.turingTest(state.turingTest))
                case .moveToSetting:
                    state.path.append(.setting(.init()))
                }
                return .none
            case .main(.profile(.delegate(let profileAction))):
                switch profileAction {
                case .openMyBadgeList(let total):
                    state.path.append(.badgeList(.init(totalBadgeCount: total)))
                case .openMySovledTuringTestList:
                    state.path.append(.solvedTuringTest(.init()))
                }
                return .none

                // 필요 시 메인에서 로그아웃 이벤트 받아 루트 전환
            case .path(.element(id: _, action: .turingTest(.delegate(let turingAction)))):
                // 테스트 표지 화면에서 받는 Action
                switch turingAction {
                case let .moveToConceptView(testID, turingTest):
                    state.turingTest = .init(turingTestID: testID, turingTest: turingTest)
                    state.path.append(.turingTestConcept(state.turingTest))
                case .moveToMainView:
                    state.path.removeAll()
                default: break
                }

                return .none

            case .path(.element(id: _, action: .turingTestConcept(.delegate(let turingAction)))):
                // 테스트 상황 세팅 화면에서 받는 Action
                switch turingAction {
                case let .moveToQuizView(quizIds, backgroundImage):
                    state.path.append(.quiz(.init(quizIdList: quizIds, backgroundImageURL: backgroundImage)))
                case .moveToMainView:
                    state.path.removeAll()
                default: break
                }

                return .none

            case .path(.element(id: _, action: .quiz(.delegate(let quizAction)))):
                // 퀴즈 화면에서 받는 Action
                switch quizAction {
                case .moveToMainView:
                    state.path.removeAll()
                case .moveToResultView:
                    state.path.append(.turingTestResult(state.turingTest))
                }
                return .none

                // Setting 화면에서 로그아웃 완료 델리게이트 수신
            case .path(.element(id: _, action: .setting(.delegate(.didLogout)))):
                // 네비 스택 및 상태 정리 후 로그인 루트로 이동
                state.path.removeAll()
                state.main = MainFeature.State()      // 필요 시 초기화
                state.signIn = SignInFeature.State()  // 필요 시 초기화
                state.root = .signIn
                return .none

            case .path(.element(id: _, action: .setting(.delegate(.moveToMainView)))):
                // 세팅 화면에서 받는 Action
                state.path.removeAll()
                return .none

            case .path(.element(id: _, action: .badgeList(.delegate(.moveToMainView)))):
                // 배지 리스트 화면에서 받는 Action
                state.path.removeAll()
                return .none

            case .path(.element(id: _, action: .solvedTuringTest(.delegate(.moveToMainView)))):
                state.path.removeAll()
                return .none

            case .path(.element(id: _, action: .turingTestResult(.delegate(.moveToMainView)))):
                state.path.removeAll()
                return .none

            case let .setRoot(root):
                state.root = root
                return .none

            default:
                return .none
            }
        }

    }

    var body: some ReducerOf<Self> {
        Scope(state: \.onboarding, action: \.onboarding) { OnboardingFeature() }
        Scope(state: \.signIn,     action: \.signIn)     { SignInFeature() }
        Scope(state: \.main,       action: \.main)       { MainFeature() }
        core
            .forEach(\.path, action: \.path) {
                AppPath()
            }
    }
}
