//
//  TuringTestConceptView.swift
//  TuringTest
//
//  Created by 가은 on 7/30/25.
//

import TCA
import DesignSystem
import SwiftUI
import Kingfisher

public struct TuringTestConceptView: View {
    @Bindable var store: StoreOf<TuringTestFeature>
    
    public init(store: StoreOf<TuringTestFeature>) {
        self.store = store
    }
    
    public var body: some View {
        ZStack {
            KFImage(URL(string: store.turingTest.backgroundImageURL))
                .resizable()
                .placeholder { ProgressView() }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            
            Color(.gray_950).opacity(0.5).ignoresSafeArea()
            
            BackgroundGradient().ignoresSafeArea()
            
            VStack {
                Text("""
                \(store.turingTest.explanation)
                """)
                .fontStyle(.body_1)
                .foregroundStyle(Color(.gray_white))
                .multilineTextAlignment(.center)
                .padding(.top, 32)
                
                Spacer()
                
                CTAButton(text: "다음") {
                    store.send(.tappedNextButton)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 10)
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        store.send(.tappedBackButton)
                    } label: {
                        Image("icon_xmark", bundle: .module)
                            .padding(12)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func BackgroundGradient() -> some View {
        VStack(spacing: 108) {
            Color.clear
                .gradientBackground(
                    stops: [
                        .init(color: Color(.gray_950), location: 0.0),
                        .init(color: Color(.gray_950).opacity(0.7), location: 0.7),
                        .init(color: Color(.gray_950).opacity(0.0), location: 1.0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            
            Color.clear
                .frame(height: 160)
                .gradientBackground(
                    stops: [
                        .init(color: Color(.gray_950), location: 0.0),
                        .init(color: Color(.gray_950).opacity(0.0), location: 1.0)
                    ],
                    startPoint: .bottom,
                    endPoint: .top
                )
        }
    }
}

#Preview {
    TuringTestConceptView(store: Store(initialState: TuringTestFeature.State(), reducer: {
        TuringTestFeature()
    }))
}
