//
//  SettingView.swift
//  Setting
//
//  Created by 가은 on 8/12/25.
//

import DesignSystem
import SwiftUI
import TCA

public struct SettingView: View {
    let store: StoreOf<SettingFeature>
    @Environment(\.openURL) var openURL
    
    public init(store: StoreOf<SettingFeature>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 16) {
                HStack {
                    Button {
                        viewStore.send(.tappedBackButton)
                    } label: {
                        Image("arrow_back", bundle: .module)
                            .padding(12)
                    }
                    .padding(.leading, 8)
                    
                    Spacer()
                }
                .overlay (
                    Text("설정")
                        .fontStyle(.body_1)
                        .foregroundStyle(Color(.gray_white))
                )
                
                VStack(spacing: 8) {
                    ItemCard(image: "icon_feedback", text: "문의하기", link: "https://forms.gle/bWFFvVC1iyTSRuGP6")
                    ItemCard(image: "icon_notes", text: "이용약관", link: "https://pretty-icicle-cfc.notion.site/gotchai2")
                    ItemCard(image: "icon_safe", text: "개인정보 처리방침", link: "https://pretty-icicle-cfc.notion.site/gotchai")
                    
                    Spacer()
                    
                    Button {
                        viewStore.send(.showPopUp(.logout))
                    } label: {
                        Text("로그아웃")
                            .foregroundStyle(Color(.gray_white))
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity)
                    }
                    .background(Color(.gray_900))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    Button {
                        viewStore.send(.showPopUp(.delete))
                    } label: {
                        Text("회원탈퇴")
                            .foregroundStyle(Color(.gray_500))
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity)
                    }
                }
                .fontStyle(.body_4)
                .padding(.horizontal, 24)
            }
            .navigationBarBackButtonHidden()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.gray_950))
            .settingPopUp(
                isPresented: viewStore.binding(
                    get: \.isPresentedPopUp,
                    send: SettingFeature.Action.setIsPresentedPopUp
                ),
                type: viewStore.popUpType) {
                    if viewStore.popUpType == .logout {
                        viewStore.send(.logout)
                    } else {
                        viewStore.send(.delete)
                    }
                }
            
        }
        
    }
    
    @ViewBuilder
    private func ItemCard(image: String, text: String, link: String) -> some View {
        HStack(spacing: 12) {
            Image(image, bundle: .module)
            Text(text)
                .fontStyle(.body_4)
                .foregroundStyle(Color(.gray_white))
            Spacer()
            Button {
                if let url = URL(string: link) {
                    openURL(url)
                }
            } label: {
                Image("arrow_right", bundle: .module)
                    .padding(.vertical, 8)
                    .padding(.leading, 14)
                    .padding(.trailing, 2)
            }
        }
        .padding([.vertical, .trailing], 12)
        .padding(.leading, 20)
        .background(Color(.gray_900))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    SettingView(store: .init(initialState: SettingFeature.State(), reducer: {
        SettingFeature()
    }))
}
