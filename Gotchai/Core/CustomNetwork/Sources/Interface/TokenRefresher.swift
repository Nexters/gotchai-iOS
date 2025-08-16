//
//  TokenRefresher.swift
//  CustomNetwork
//
//  Created by koreamango on 8/17/25.
//

import Combine

/// 네트워크 레이어가 인증 구현 세부사항을 모르도록 하는 계약.
/// 구현체는 Core/Auth에서 제공.
public protocol TokenRefresherProtocol: AnyObject {

    /// 주어진 에러가 토큰 만료/401 등 "리프레시 시도" 대상인지 판단.
    /// - Note: 서버 사양(ErrorResponseDTO, errorCode 등)에 맞게 구현부에서 판정.
    func shouldRefresh(for error: Error) -> Bool

    /// 필요한 경우 리프레시를 수행한다.
    /// - 성공: 새 토큰 저장까지 완료하고 `Void` 방출
    /// - 실패: 에러 방출(이후 상위에서 세션 종료/로그아웃 처리)
    /// - 구현체는 **동시 요청에 대해 in-flight 공유**를 반드시 제공할 것(share/replay).
    func refreshIfNeeded() -> AnyPublisher<Void, Error>

    /// 리프레시 실패 시(예: 400/401/403) 호출되는 훅. 상위에서 세션 종료/로그아웃 등에 사용.
    /// - 구현체가 내부에서 실패 판단 시 호출. 옵셔널.
    var onRefreshFailed: (() -> Void)? { get set }
}
