import TCA
import SwiftUI
import Key
import Auth
import CustomNetwork
import Common
import Moya

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
            $0.networkClient = networkClient   // ✅ 여기서 한 번만 주입
        }
    }

    var body: some Scene {
        WindowGroup {
            AppView(store: store)
        }
    }
}

