//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 7/5/25.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private init() { }
    
    func logout() {
        cleanCookies()
        OAuth2TokenStorage.shared.token = nil
        ProfileService.shared.clean()
        ProfileImageService.shared.clean()
        ImagesListService.shared.clean()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let delegate = windowScene.delegate as? SceneDelegate {
            delegate.window?.rootViewController?.dismiss(animated: false) {
                let splashVC = SplashViewController()
                delegate.window?.rootViewController = splashVC
            }
        }
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
}
