//
//  ProfileService.swift.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 28.04.2025.
//

import Foundation

// MARK: - ProfileService
final class ProfileService {
    static let shared = ProfileService()
    private var task: URLSessionTask?
    private var lastToken: String?
    private(set) var profile: Profile?
    
    private init() {}
    
    // MARK: - Struct
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
    
    // MARK: - Public Methods
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

        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResults, Error>) in
            DispatchQueue.main.async {
                defer {
                    self?.task = nil
                    self?.lastToken = nil
                }

                switch result {
                case .success(let result):
                    let profile = Profile(
                        username: result.username,
                        name: "\(result.firstName ?? "") \(result.lastName ?? "")".trimmingCharacters(in: .whitespaces),
                        loginName: "@\(result.username)",
                        bio: result.bio
                    )
                    self?.profile = profile
                    completion(.success(profile))

                case .failure(let error):
                    print("[ProfileService]: Ошибка запроса - \(error.localizedDescription)")
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
    
    func clean() {
        profile = nil
    }
}
