import TCA
import SwiftUI
import Key
import Auth
import CustomNetwork
import Common
import Moya
import Profile

@main
struct GotchaiApp: App {

    private let store: StoreOf<AppFeature>

    init() {
        let tokenStore: TokenProvider = KeychainTokenProvider.shared
        let provider = MoyaProvider<MultiTarget>(plugins: [AuthPlugin(tokenStore: tokenStore)])
        let refresher: TokenRefresherProtocol = TokenRefresher(provider: provider, tokenStore: tokenStore)
        let networkClient = MoyaAPIClient(provider: provider, refresher: refresher)

        self.store = Store(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.networkClient = networkClient
            $0.solvedTuringTestService = .live(networkClient)
            $0.badgeService = .live(networkClient)
            $0.settingService = .live(networkClient)
            $0.signInService = .live(networkClient)
            $0.turingTestService = .live(networkClient)
            $0.profileService = .live(networkClient)
        }
    }

    var body: some Scene {
        WindowGroup {
            AppView(store: store)
                .task {
                    await store.send(.appLaunched).finish()
                }
        }
    }
}

