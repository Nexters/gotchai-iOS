//
//  BadgeListView.swift
//  Profile
//
//  Created by 가은 on 8/9/25.
//

import DesignSystem
import TCA
import SwiftUI

public struct BadgeListView: View {
    let store: StoreOf<BadgeListFeature>
    
    let colums = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    public init(store: StoreOf<BadgeListFeature>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: \.badgeItems) { viewStore in
            ZStack {
                Color(.gray_950).ignoresSafeArea()

                ScrollView {
                    if viewStore.state.count > 0 {
                        HStack(spacing: 12) {
                            Image("icon_congratulations", bundle: .module)
                            VStack(alignment: .leading, spacing: 0) {
                                Text("축하해요")
                                    .fontStyle(.body_6)
                                    .foregroundStyle(Color(.gray_white))
                                Text("\(viewStore.state.count)개의 배지를 모았어요!")
                                    .fontStyle(.body_2)
                                    .foregroundStyle(Color(.primary_400))
                            }
                            Spacer()
                        }
                        .padding(.leading, 20)
                        .padding(.vertical, 16)
                        .background(Color(.primary_900))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.horizontal, 24)
                    }
                    
                    LazyVGrid(columns: colums, spacing: 16) {
                        ForEach(badgeList, id: \.id) { item in
                            VStack(spacing: 12) {
                                BadgeImage(item.imageURL)
                                    .frame(width: 68, height: 68)
                                    .padding(18)
                                    .background(Color(.gray_900))
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                
                                Text(item.name)
                                    .fontStyle(.body_6)
                                    .foregroundStyle(Color(.gray_100))
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                }
                .task { await viewStore.send(.task).finish() }         // 화면 등장 시 1회 호출
                .navigationBarBackButtonHidden()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            viewStore.send(.tappedBackButton)
                        } label: {
                            Image("arrow_back", bundle: .module)
                                .padding(12)
                        }
                        .padding(.bottom, 8)
                    }
                    ToolbarItem(placement: .principal) {
                        Text("내 배지")
                            .fontStyle(.body_1)
                            .foregroundStyle(Color(.gray_white))
                            .padding(.vertical, 10)
                            .padding(.bottom, 8)
                        
                    }
                }
            }
        }
    }
    
    private var badgeList: [Badge] {
        let count = max(0, store.totalBadgeCount - store.badgeItems.count)
        let notAquired: [Badge] = (0..<max(0,count)).map { i in
            Badge(id: -(i+1), imageURL: "icon_question", name: "숨겨진 배지", acquiredAt: "")
        }
        print("배지", store.badgeItems.count)
        print("total count", store.totalBadgeCount)
        print("안얻음", count, notAquired)
        return store.badgeItems + notAquired
    }
    
    @ViewBuilder
    private func BadgeImage(_ imageURL: String) -> some View {
        if imageURL == "icon_question" {
            Image(imageURL, bundle: .module)
        } else {
            AsyncImage(url: URL(string: imageURL)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
        }
    }
}

#Preview {
    BadgeListView(store: .init(initialState: BadgeListFeature.State(totalBadgeCount: 8), reducer: {
        BadgeListFeature()
    }))
}
