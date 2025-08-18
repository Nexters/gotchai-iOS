//
//  OnboardingView.swift
//  Onboarding
//
//  Created by koreamango on 7/28/25.
//

import DesignSystem
import SwiftUI
import TCA

public struct OnboardingView: View {
    @Bindable var store: StoreOf<OnboardingFeature>

    public init(store: StoreOf<OnboardingFeature>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                Color(.gray_950).ignoresSafeArea()

                VStack {
                    HStack {
                        Spacer()
                        if viewStore.currentPage < viewStore.pages.count - 1 {
                            Button("건너뛰기") {
                                viewStore.send(.start)
                            }
                            .fontStyle(.body_5)
                            .foregroundColor(Color(.gray_400))
                            .padding(.horizontal, 32)
                            .padding(.top, 10)
                        }
                    }
                    .frame(height: 22)

                    TabView(selection: viewStore.binding(
                        get: \.currentPage,
                        send: OnboardingFeature.Action.pageChanged
                    )) {
                        ForEach(Array(viewStore.pages.enumerated()), id: \.offset) {
                            idx,
                                page in
                            VStack(spacing: 44) {
                                Image(page.imageName, bundle: .module)

                                Text(page.title)
                                    .fontStyle(.body_1)
                                    .foregroundColor(Color(.gray_white))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 8)
                            }
                            .tag(idx)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                    HStack(spacing: 8) {
                        ForEach(0 ..< viewStore.pages.count, id: \.self) { idx in
                            Circle()
                                .fill(
                                    idx == viewStore.currentPage ?
                                        Color(.primary_400) :
                                        Color(.gray_700)
                                )
                                .frame(width: 6, height: 6)
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.bottom, 32)

                    CTAButton(text: viewStore.currentPage < viewStore.pages.count - 1 ? "다음" : "시작하기") {
                        viewStore.send(.nextButtonTapped)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 10)
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(
            store: StoreOf<OnboardingFeature>(
                initialState: OnboardingFeature.State()
            ) {
                OnboardingFeature()
            }
        )
    }
}
