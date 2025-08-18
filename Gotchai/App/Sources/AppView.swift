//
//  AppView.swift
//  Gotchai
//
//  Created by 가은 on 8/2/25.
//

import TCA
import SwiftUI
import SignIn
import Auth
import Onboarding
import Main
import Setting
import Profile

struct AppView: View {
    let store: StoreOf<AppFeature>

    var body: some View {
        WithViewStore(store, observe: \.root) { viewStore in
            Group {
                switch viewStore.state {
                case .booting:
                  ZStack {
                    Color("launch_color")
                    Image("launch_logo")
                      .renderingMode(.original)
                  }
                  .ignoresSafeArea()
                  .statusBar(hidden: true)

                case .onboarding:
                    OnboardingView(
                        store: store.scope(state: \.onboarding, action: \.onboarding)
                    )

                case .signIn:
                    SignInView(
                        store: store.scope(state: \.signIn, action: \.signIn)
                    )

                case .main:
                    // 필요 시 여기서 NavigationStackStore를 둘러서
                    // 메인 내부 push를 확장 가능
                    NavigationStackStore(
                        // ✅ path에 바인딩
                        store.scope(state: \.path, action: \.path)
                    ) {
                        // ✅ root(첫 화면)
                        MainView(
                            store: store.scope(state: \.main, action: \.main)
                        )
                    } destination: { store in
                        // ✅ 목적지 매핑
                        switch store.state {
                        case .turingTest:
                            if let turingStore = store.scope(state: \.turingTest, action: \.turingTest) {
                                TuringTestIntroView(store: turingStore)
                            }
                        case .turingTestConcept:
                            if let turingStore = store.scope(state: \.turingTestConcept, action: \.turingTestConcept) {
                                TuringTestConceptView(store: turingStore)
                            }
                        case .quiz:
                            if let quizStore = store.scope(state: \.quiz, action: \.quiz) {
                                QuizView(store: quizStore)
                            }
                        case .turingTestResult:
                            if let turingStore = store.scope(state: \.turingTestResult, action: \.turingTestResult) {
                                TuringTestResultView(store: turingStore)
                            }
                        case .setting:
                            if let settingStore = store.scope(state: \.setting, action: \.setting) {
                                SettingView(store: settingStore)
                            }
                        case .badgeList:
                            if let badgeListStore = store.scope(state: \.badgeList, action: \.badgeList) {
                                BadgeListView(store: badgeListStore)
                            }
                        case .solvedTuringTest:
                            if let solvedTestStore = store.scope(state: \.solvedTuringTest, action: \.solvedTuringTest) {
                                SolvedTuringTestListView(store: solvedTestStore)
                            }
                        }
                    }

                }
            }
        }
    }
}
