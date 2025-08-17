//
//  SolvedTuringTestListView.swift
//  Profile
//
//  Created by 가은 on 8/9/25.
//

import SwiftUI
import TCA
import DesignSystem

public struct SolvedTuringTestListView: View {
    let store: StoreOf<SolvedTuringTestFeature>
    
    public init(store: StoreOf<SolvedTuringTestFeature>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: \.solvedTuringTests) { viewStore in
            ZStack {
                Color(.gray_950).ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(store.solvedTuringTests ,id: \.id) { item in
                            TestCard(data: item)
                                .padding(.horizontal, 24)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .task { await store.send(.task).finish() }
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
                    Text("내가 풀었던 테스트")
                        .fontStyle(.body_1)
                        .foregroundStyle(Color(.gray_white))
                        .padding(.vertical, 10)
                        .padding(.bottom, 8)
                    
                }
            }
        }
    }
    
    @ViewBuilder
    private func TestCard(data: SolvedTuringTest) -> some View {
        HStack(spacing: 20) {
            AsyncImage(url: URL(string: data.iconURL)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 44, height: 44)
            VStack(alignment: .leading, spacing: 2) {
                Text(data.title)
                    .foregroundStyle(Color(.gray_white))
                Text("\(data.totalQuizCount)개 중 \(data.correctCount)개 맞췄어요")
                    .foregroundStyle(Color(.gray_500))
            }
            
            Spacer()
            Text("\(data.percent)%")
                .foregroundStyle(data.correctCount > 3 ? Color(.sub_blue) : Color(.sub_red))
        }
        .fontStyle(.body_4)
        .padding(.horizontal, 20)
        .padding(.vertical, 23)
        .background(Color(.gray_900))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    SolvedTuringTestListView(store: .init(initialState: SolvedTuringTestFeature.State(), reducer: {
        SolvedTuringTestFeature()
     }))
}
