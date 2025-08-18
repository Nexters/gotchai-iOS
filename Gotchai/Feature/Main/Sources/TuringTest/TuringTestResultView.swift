//
//  TuringTestResultView.swift
//  Main
//
//  Created by 가은 on 8/7/25.
//

import DesignSystem
import SwiftUI
import TCA
import Kingfisher

public struct TuringTestResultView: View {
    let store: StoreOf<TuringTestFeature>
    var gradientStops = GradientHelper.getGradientStops(for: .bronze)
    var badgeCardColor = GradientHelper.getBadgeColors(for: .bronze)
    
    public init(store: StoreOf<TuringTestFeature>) {
        self.store = store
        if let tier = store.resultBadge?.tier, tier != .bronze {
            self.gradientStops = GradientHelper.getGradientStops(for: tier)
            self.badgeCardColor = GradientHelper.getBadgeColors(for: tier)
        }
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            Color(.gray_900).ignoresSafeArea()
            BackgroundGradient()
            
            ScrollView {
                VStack(spacing: 24) {
                    BadgeCard()
                    PromptCard()
                }
                .padding(.horizontal, 36)
                .padding(.bottom, 126)
                .padding(.top, 68)
            }
            
            VStack {
                TopNaviBar()
                Spacer()
            }
            
            BottomButtons()
            
            if store.showToastMessage {
                Toast(message: store.toastMessage)
                    .padding(.bottom, 90)
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            store.send(.getResultBadge)
        }
    }
    
    @ViewBuilder
    private func TopNaviBar() -> some View {
        HStack {
            Spacer()
            Button {
                store.send(.tappedBackButton)
            } label: {
                Image("icon_xmark", bundle: .module)
                    .padding(12)
            }
            .padding(.trailing, 12)
            .padding(.bottom, 20)
        }
        .gradientBackground(
            stops: gradientStops.naviBackground,
            startPoint: .top,
            endPoint: .bottom)
    }
    
    @ViewBuilder
    private func BadgeCard() -> some View {
        let count = store.resultBadge?.correctCount ?? 0
        let countText = count == 7 ? "모두 맞춘 당신은" : "7개 중 \(count)개를 맞춘 당신은"
        
        VStack(spacing: 0) {
            KFImage(URL(string: store.resultBadge?.imageURL ?? ""))
                .resizable()
                .placeholder { ProgressView() }
                .frame(width: 213, height: 213)
                .clipShape(Circle())

            Text(countText)
                .fontStyle(.body_1)
                .foregroundStyle(Color(hex: badgeCardColor.subColor))
                .padding(.top, 26)
            Text(store.resultBadge?.badgeName ?? "")
                .fontStyle(.title_3)
                .foregroundStyle(Color(hex: badgeCardColor.titleColor))
            Text(store.resultBadge?.description ?? "")
                .fontStyle(.body_4)
                .foregroundStyle(Color(.gray_white).opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.top, 16)
            Image(badgeCardColor.image, bundle: .module)
                .padding(.top, 36)
        }
        .padding([.horizontal, .top], 34)
        .padding(.bottom, 27)
        .frame(maxWidth: .infinity)
        .gradientBackground(
            stops: gradientStops.badgeLinearBackground,
            startPoint: .topLeading,
            endPoint: .bottomTrailing,
            cornerRadius: 24,
            strokeColor: Color(.gray_white).opacity(0.2),
            backgroundOpacity: 0.2
        )
        .background(
            RadialGradient(
                gradient: Gradient(stops: gradientStops.badgeRadialBackground),
                center: .bottom,
                startRadius: 0,
                endRadius: 400
            ).opacity(0.2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
    
    @ViewBuilder
    private func PromptCard() -> some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Text("GPT")
                    .fontStyle(.body_5)
                    .foregroundStyle(Color(.gray_white).opacity(0.5))
            }
            .padding(.top, 18)
            Text(store.turingTest.theme)
                .fontStyle(.subtitle_2)
                .foregroundStyle(Color(.primary_300))
            Text("이 프롬프트로 만들었어요")
                .fontStyle(.subtitle_1)
            KFImage(URL(string: store.turingTest.imageURL))
                .resizable()
                .placeholder { ProgressView() }
                .frame(width: 133, height: 133)
                .clipShape(Circle())
                .padding(.vertical, 16)
                
            Text(store.turingTest.prompt)
                .fontStyle(.body_4)
                .multilineTextAlignment(.center)
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color(.gray_500))
                .padding(.top, 32)
            Button {
                store.send(.copyPromptButton)
            } label: {
                HStack {
                    Image("icon_copy", bundle: .module)
                    Text("프롬프트 복사하기")
                        .fontStyle(.body_3)
                        .foregroundStyle(Color(.primary_400))
                }
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity)
            }
            .padding(.bottom, 6)
        }
        .foregroundStyle(Color(.gray_white))
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(hex: "BFC9E7").opacity(0.1))
        )
    }
    
    @ViewBuilder
    private func BackgroundGradient() -> some View {
        Color.clear
            .ignoresSafeArea()
            .gradientBackground(
                stops: gradientStops.mainBackground,
                startPoint: .top,
                endPoint: .bottom
            )
    }
    
    @ViewBuilder
    private func BottomButtons() -> some View {
        HStack(alignment: .bottom, spacing: 13) {
            Button {
                
            } label: {
                HStack(spacing: 4) {
                    Image("icon_save", bundle: .module)
                    Text("이미지 저장")
                        .fontStyle(.body_3)
                        .foregroundStyle(Color(.gray_black))
                        .padding(.vertical, 15)
                }
                .frame(maxWidth: .infinity)
            }
            .background(Color(.primary_100))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            Button {
                
            } label: {
                HStack(spacing: 4) {
                    Image("icon_insta", bundle: .module)
                    Text("배지 공유")
                        .fontStyle(.body_3)
                        .foregroundStyle(Color(.gray_black))
                        .padding(.vertical, 15)
                }
                .frame(maxWidth: .infinity)
            }
            .background(Color(.primary_400))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .padding(.top, 66)
        .padding(.horizontal, 24)
        .gradientBackground(
            stops: [
                .init(color: Color(.gray_950).opacity(0.0), location: 0.0),
                .init(color: Color(.gray_950), location: 0.5),
                .init(color: Color(.gray_950), location: 1.0)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

#Preview {
    TuringTestResultView(store: Store(initialState: TuringTestFeature.State(), reducer: {
        TuringTestFeature()
    }))
}
