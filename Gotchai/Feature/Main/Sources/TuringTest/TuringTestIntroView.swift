//
//  TuringTestIntroView.swift
//  TuringTest
//
//  Created by 가은 on 7/30/25.
//

import TCA
import DesignSystem
import SwiftUI
import Kingfisher

public struct TuringTestIntroView: View {
    let store: StoreOf<TuringTestFeature>
    
    public init(store: StoreOf<TuringTestFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            KFImage(URL(string: store.turingTest.iconURL))
                .resizable()
                .placeholder { ProgressView() }
                .frame(width: 40, height: 40)
            
            Text(store.turingTest.title)
                .fontStyle(.title_2)
                .foregroundStyle(Color(.primary_400))
                .padding(.top, 12)
            
            Text(store.turingTest.subtitle)
                .fontStyle(.title_4)
                .foregroundStyle(Color(.gray_white))
                .padding(.top, 2)
            
            Text("Ai가 한 말은 무엇일까요?")
                .fontStyle(.body_3)
                .foregroundStyle(Color(.gray_300))
                .padding(.top, 24)
            
            KFImage(URL(string: store.turingTest.imageURL))
                .resizable()
                .placeholder { ProgressView() }
                .frame(width: 305, height: 305)
                .background(Circle().fill(Color(.gray_800)))
                .padding(.top, 44)
            
            Spacer()
            
            CTAButton(text: "시작하기") {
                store.send(.tappedStartButton)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.gray_950))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    store.send(.tappedBackButton)
                } label: {
                    Image("icon_arrow_back", bundle: .module)
                        .padding(12)
                }
            }
        }
        .onAppear {
            store.send(.onAppearIntroView)
        }
        .navigationBarBackButtonHidden()
    }
    
}

#Preview {
    TuringTestIntroView(store: Store(initialState: TuringTestFeature.State(), reducer: {
        TuringTestFeature()
    }))
}
