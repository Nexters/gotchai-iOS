//
//  ProfileFeature.swift
//  Profile
//
//  Created by koreamango on 8/15/25.
//

import Combine
import TCA

@Reducer
public struct ProfileFeature {
    @Dependency(\.profileService) var profileService
    @Dependency(\.badgeService) var badgeService
    
    public init() { }
    
    public enum CancelID {
        case getRanking
        case getBadgeList
    }

    @ObservableState
    public struct State {
        var totalTuringTestCount: Int
        var profile: Profile
        var lastBadge: Badge?
        
        public init(totalTuringTestCount: Int, profile: Profile = Profile(nickname: "닉네임", rating: 50), lastBadge: Badge? = nil) {
            self.totalTuringTestCount = totalTuringTestCount
            self.profile = profile
            self.lastBadge = lastBadge
        }
    }

    public enum Delegate {
        case openMyBadgeList(Int)
        case openMySovledTuringTestList
    }

    public enum Action {
        // life cycle
        case onAppear
        
        case tappedBadgeComponent
        case tappedSolvedTuringTestComponent

        case delegate(Delegate)
        
        case getRankingResponse(Result<Profile, Error>)
        case getBadgeListResponse(Result<[Badge], Error>)
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                let getRanking: Effect<Action> = .publisher {
                    profileService.getRanking()
                        .map { .getRankingResponse(.success($0)) }
                        .catch { Just(.getRankingResponse(.failure($0)))}
                }
                .cancellable(id: CancelID.getRanking)
                
                let getBadgeList: Effect<Action> = .publisher {
                    badgeService.fetchBadges()
                        .map { .getBadgeListResponse(.success($0)) }
                        .catch { Just(.getBadgeListResponse(.failure($0)))}
                }
                .cancellable(id: CancelID.getBadgeList)
                
                return .merge(getRanking, getBadgeList)
                
            case .tappedBadgeComponent:
                return .send(.delegate(.openMyBadgeList(state.totalTuringTestCount)))
            case .tappedSolvedTuringTestComponent:
                return .send(.delegate(.openMySovledTuringTestList))
                
            case .getRankingResponse(let result):
                switch result {
                case .success(let profile):
                    state.profile = profile
                    return .none
                case .failure(let error):
                    return .none
                }
                
            case .getBadgeListResponse(let result):
                switch result {
                case .success(let badges):
                    state.lastBadge = badges.first
                    return .none
                case .failure(let error):
                    return .none
                }

            case .delegate: return .none
            }
        }
    }
}
