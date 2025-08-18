//
//  SettingPopUp.swift
//  Setting
//
//  Created by 가은 on 8/13/25.
//

import SwiftUI

struct SettingPopUp: ViewModifier {
    @Binding var isPresented: Bool
    let type: SettingPopUpType?
    let action: () -> Void
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .blur(radius: isPresented && type != nil ? 10 : 0)
            
            if isPresented && type != nil {
                Color(.gray_black).opacity(0.6).ignoresSafeArea()
                PopUpView(isLogout: type == .logout)
            }
        }
    }
    
    @ViewBuilder
    private func PopUpView(isLogout: Bool) -> some View {
        VStack(spacing: 0) {
            Text(isLogout ? "로그아웃 하시겠어요?" : "정말로 계정을\n탈퇴하시겠어요?")
                .fontStyle(.body_1)
                .foregroundStyle(Color(.gray_100))
                .multilineTextAlignment(.center)
            
            if !isLogout {
                Text("모든 기록이 사라지며 복구될 수 없어요")
                    .fontStyle(.body_5)
                    .foregroundStyle(Color(.gray_300))
                    .padding(.top, 8)
            }
            
            HStack(spacing: 8) {
                Button {
                    isPresented = false
                } label: {
                    Text("취소")
                        .foregroundStyle(Color(.gray_200))
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                }
                .background(Color(.gray_700))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                Button {
                    action()
                } label: {
                    Text(isLogout ? "로그아웃" : "탈퇴하기")
                        .foregroundStyle(Color(.gray_black))
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                }
                .background(Color(.primary_400))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .fontStyle(.body_3)
            .padding(.top, 40)
        }
        .padding([.horizontal, .bottom], 20)
        .padding(.top, 42)
        .background(Color(.gray_900))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal, 33)
    }
}

extension View {
    func settingPopUp(isPresented: Binding<Bool>, type: SettingPopUpType?, action: @escaping () -> Void) -> some View {
        self.modifier(SettingPopUp(isPresented: isPresented, type: type, action: action))
    }
}
