//
//  ProfileService.swift.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 28.04.2025.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private var task: URLSessionTask?
    private var lastToken: String?
    
    
    private init() {}
    
    struct ProfileResults: Codable {
        let username: String
        let firstName: String?
        let lastName: String?
        let bio: String?
        
        enum CodingKeys: String, CodingKey {
            case username
            case firstName = "first_name"
            case lastName = "last_name"
            case bio
        }
    }
    
    struct Profile {
        let username: String
        let name: String
        let loginName: String
        let bio: String?
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        if lastToken == token {
            return
        }
        task?.cancel()
        lastToken = token

        guard let request = makeProfileRequest(token: token) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                defer {
                    self?.task = nil
                    self?.lastToken = nil
                }

                if let error = error {
                    print("Ошибка сети: \(error)")
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }

                do {
                    let result = try JSONDecoder().decode(ProfileResults.self, from: data)
                    let profile = Profile(
                        username: result.username,
                        name: "\(result.firstName ?? "") \(result.lastName ?? "")".trimmingCharacters(in: .whitespaces),
                        loginName: "@\(result.username)",
                        bio: result.bio
                    )
                    completion(.success(profile))
                } catch {
                    print("Ошибка декодирования: \(error)")
                    completion(.failure(error))
                }
            }
        }
        self.task = task
        task.resume()
    }
    
    private func makeProfileRequest(token: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/me") else { return nil}
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
