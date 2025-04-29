//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 10.04.2025.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {}
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    struct OAuthTokenResponseBody: Decodable {
        let accessToken: String
        
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
        }
    }
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "unsplash.com"
        components.path = "/oauth/token"
        
        guard let url = components.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: String] = [
            "client_id": Constants.accessKey,
            "client_secret": Constants.secretKey,
            "redirect_uri": Constants.redirectURI,
            "code": code,
            "grant_type": "authorization_code"
        ]
        
        request.httpBody = parameters
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .data(using: .utf8)
        
        return request
    }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if lastCode == code {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastCode = code
        
        UIBlockingProgressHUD.show()
        
        print("🌐 fetchOAuthToken вызван с code: \(code)")
        guard let request = makeOAuthTokenRequest(code: code) else {
            UIBlockingProgressHUD.dismiss()
            completion(.failure(NetworkError.urlSessionError))
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            DispatchQueue.main.async {
                defer {
                    self?.task = nil
                    self?.lastCode = nil
                    UIBlockingProgressHUD.dismiss()
                }

                switch result {
                case .success(let decoded):
                    let token = decoded.accessToken
                    OAuth2TokenStorage().token = token
                    completion(.success(token))
                case .failure(let error):
                    print("[OAuth2Service]: Ошибка запроса - \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
        self.task = task
        task.resume()
    }
}
