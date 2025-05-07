//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 29.04.2025.
//

import Foundation

final class ProfileImageService {
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageServiceDidChange")
    static let shared = ProfileImageService()
    private(set) var avatarURL: String?
    private var isFetching = false
    
    private init() {}
    
    struct UserResult: Codable {
        let profileImage: ProfileImage
        
        struct ProfileImage: Codable {
            let large: String
        }
        enum CodingKeys: String, CodingKey {
            case profileImage = "profile_image"
        }
    }
        
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        if isFetching { return }
        isFetching = true
    
        guard let token = OAuth2TokenStorage().token else {
            // Обрабатываем отсутствие токена
            completion(.failure(NetworkError.tokenMissing))
            return
        }

        guard let url = URL(string: "https://api.unsplash.com/users/\(username)") else {
            // Обрабатываем неправильный URL
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            defer { self.isFetching = false }

            switch result {
            case .success(let userResult):
                let largeAvatarURL = userResult.profileImage.large
                self.avatarURL = largeAvatarURL
                completion(.success(largeAvatarURL))

                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": largeAvatarURL]
                )
            case .failure(let error):
                print("[ProfileImageService]: Ошибка запроса - \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func clean() {
        avatarURL = nil
    }
}
