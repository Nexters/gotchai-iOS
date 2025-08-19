//
//  SignInView.swift
//  SignIn
//
//  Created by koreamango on 7/30/25.
//

import SwiftUI
import TCA
import DesignSystem
import Auth

public struct SignInView: View {
    let store: StoreOf<SignInFeature>

    public init(store: StoreOf<SignInFeature>) {
        self.store = store
    }

    let kakaoButtonColor: Color = Color(hex: "FEE500")
    let kakaoButtonTextColor: Color = Color(hex: "191600")
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Spacer()
                VStack(spacing: 4) {
                    Image("logo", bundle: .module)
                    Text("인간 사이 숨은 AI 찾기")
                        .fontStyle(FontStyle.body_2)
                        .foregroundColor(Color(.gray_200))
                }
                Spacer(minLength: 300)
                VStack(spacing: 16) {
                    Button {
                        viewStore.send(.tappedAppleLogin)
                    } label: {
                        HStack {
                            Image(systemName: "apple.logo")
                            Text("Apple로 시작하기")
                                .fontStyle(.body_2)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Color(.gray_800))
                        .foregroundColor(Color(.gray_white))
                        .cornerRadius(50)
                    }
                    
                    Button {
                        viewStore.send(.tappedKakaoLogin)
                    } label: {
                        HStack {
                            Image(systemName: "message.fill")
                            Text("카카오로 시작하기")
                                .fontStyle(.body_2)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(kakaoButtonColor)
                        .foregroundColor(kakaoButtonTextColor)
                        .cornerRadius(50)
                    }

                }
                .padding(.horizontal, 33)
                .padding(.bottom, 125)
            }
            .background(Color(.gray_950))
        }
    }
}


