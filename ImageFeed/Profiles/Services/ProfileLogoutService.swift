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
               let storyboard = UIStoryboard(name: "Main", bundle: .main)
               let authVC = storyboard.instantiateViewController(withIdentifier: "AuthViewController")
               delegate.window?.rootViewController = authVC
           }
       }

       private func cleanCookies() {
          // Очищаем все куки из хранилища
          HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
          // Запрашиваем все данные из локального хранилища
          WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
             // Массив полученных записей удаляем из хранилища
             records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
             }
          }
       }

}
