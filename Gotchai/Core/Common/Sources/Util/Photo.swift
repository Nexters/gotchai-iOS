//
//  Photo.swift
//  Common
//
//  Created by koreamango on 8/19/25.
//

import Photos
import UniformTypeIdentifiers
import UIKit

public func savePNGToPhotos(_ image: UIImage) {
    // iOS 14+ : 추가 전용 권한 요청
    PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
        guard status == .authorized else { return } // 거절/보류 시 처리

        guard let data = image.pngData() else { return }

        PHPhotoLibrary.shared().performChanges({
            let options = PHAssetResourceCreationOptions()
            options.uniformTypeIdentifier = UTType.png.identifier
            options.originalFilename = "badge-\(Int(Date().timeIntervalSince1970)).png"

            let req = PHAssetCreationRequest.forAsset()
            req.addResource(with: .photo, data: data, options: options)
        }, completionHandler: { success, error in
            #if DEBUG
            print("save PNG:", success, error?.localizedDescription ?? "nil")
            #endif
        })
    }
}
