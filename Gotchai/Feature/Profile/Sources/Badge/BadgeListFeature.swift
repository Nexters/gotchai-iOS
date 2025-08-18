//
//  BadgeListFeature.swift
//  Profile
//
//  Created by 가은 on 8/9/25.
//

import TCA
import SwiftUI
import Combine

@Reducer
public struct BadgeListFeature {
    @Dependency(\.badgeService) var badgeService
    
    public init() { }
    
    enum CancelID {
        case fetchBadges
    }

    @ObservableState
    public struct State {
        var totalBadgeCount: Int
        var badgeItems: [Badge]
        var isLoading = false
        var error: String?
        
        public init(totalBadgeCount: Int, badgeItems: [Badge] = [], isLoading: Bool = false, error: String? = nil) {
            self.totalBadgeCount = totalBadgeCount
            self.badgeItems = badgeItems
            self.isLoading = isLoading
            self.error = error
        }
    }
    
    public enum Delegate {
        case moveToMainView
    }

    public enum Action {
        case task                  // 뷰 등장/갱신 트리거
        case badgesLoaded([Badge])
        case failed(String)
        case tappedBackButton
        case delegate(Delegate)
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .task:
                state.isLoading = true
                state.error = nil
                return .publisher {
                    badgeService.fetchBadges()
                        .map(BadgeListFeature.Action.badgesLoaded)
                        .catch { Just(.failed($0.localizedDescription)) }
                }
                .cancellable(id: CancelID.fetchBadges)

            case .badgesLoaded(let items):
                state.isLoading = false
                state.badgeItems = items
                return .none

            case .failed(let message):
                state.isLoading = false
                state.error = message
                return .none
                
            case .tappedBackButton:
                return .send(.delegate(.moveToMainView))
                
            case .delegate(_):
                return .none
            }
        }
    }
}
