//
//  ProfileView.swift
//  Profile
//
//  Created by 가은 on 8/7/25.
//

import DesignSystem
import SwiftUI
import TCA
import Common

public struct ProfileView: View {
    
    let store: StoreOf<ProfileFeature>

    public init(store: StoreOf<ProfileFeature>) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 12) {
            Image("profile_default", bundle: .module)
            Text(store.profile.nickname)
                .fontStyle(.body_4)
                .foregroundStyle(Color(.gray_white))
                .padding(.vertical, 6)
                .padding(.horizontal, 16)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 50)
                            .fill(Color(hex: "1E2803"))
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(Color(.primary_600), lineWidth: 0.5)
                    }
                )
            
            RankCard()
                .padding(.top, 12)
            MyBadgeCard()
            MyTestCard()
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.gray_950))
        .onAppear { store.send(.onAppear) }
    }
    
    
    @ViewBuilder
    private func RankCard() -> some View {
        Image(rankImage, bundle: .module)
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(alignment: .topLeading) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(store.profile.nickname)님은")
                        .fontStyle(.body_6)
                        .foregroundStyle(Color(.gray_white).opacity(0.6))
                    Text("상위 \(store.profile.rating)%")
                        .fontStyle(.subtitle_2)
                        .foregroundStyle(Color(.gray_white))
                }
                .padding(20)
            }
    }
    
    @ViewBuilder
    private func MyBadgeCard() -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Image("icon_badge", bundle: .module)
                Text("내 배지")
                Spacer()
                Button {
                    store.send(.tappedBadgeComponent)
                } label: {
                    Image("arrow_right", bundle: .module)
                        .padding(.vertical, 8)
                        .padding(.leading, 14)
                }
            }
            .padding(.bottom, store.lastBadge == nil ? 12 : 8)
            
            if let badge = store.lastBadge {
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(Color(.gray_500))
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(badge.name)
                        Text("\(DateManager.shared.parseISO(badge.acquiredAt))에 획득")
                            .fontStyle(.body_6)
                            .foregroundStyle(Color(.gray_500))
                    }
                    Spacer()
                    AsyncImage(url: URL(string: badge.imageURL)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 95, height: 95)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .padding(.vertical, 20)
            }
        }
        .fontStyle(.body_2)
        .foregroundStyle(Color(.gray_white))
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .background(Color(.gray_900))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    @ViewBuilder
    private func MyTestCard() -> some View {
        HStack(spacing: 8) {
            Image("icon_history", bundle: .module)
            Text("내가 풀었던 테스트")
                .fontStyle(.body_2)
                .foregroundStyle(Color(.gray_white))
            
            Spacer()
            
            Button {
                store.send(.tappedSolvedTuringTestComponent)
            } label: {
                Image("arrow_right", bundle: .module)
                    .padding(.vertical, 8)
                    .padding(.leading, 14)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color(.gray_900))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var rankImage: String {
        let rating = store.profile.rating
        print(rating)
        let cap = [5, 10, 25, 50].first(where: { rating <= $0 }) ?? 50
        return "rank_card\(cap)"
    }
}

#Preview {
    ProfileView(
        store: Store(initialState: ProfileFeature.State(totalTuringTestCount: 8), reducer: {
            ProfileFeature()
        })
    )
}
