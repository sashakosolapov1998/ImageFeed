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
        print("🌐 fetchOAuthToken вызван с code: \(code)")
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(NetworkError.urlSessionError))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                print("📶 URLSession завершила выполнение запроса")
                
                if let error = error {
                    print("❌ Сетевая ошибка: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ Не удалось получить HTTP-ответ")
                    completion(.failure(NetworkError.urlSessionError))
                    return
                }
                
                guard (200..<300).contains(httpResponse.statusCode) else {
                    print("❌ Сервер вернул статус-код: \(httpResponse.statusCode)")
                    if let data = data {
                        print("📨 Ответ от сервера (raw): \(String(data: data, encoding: .utf8) ?? "—")")
                    }
                    completion(.failure(NetworkError.httpStatusCode(httpResponse.statusCode)))
                    return
                }
                
                guard let data = data else {
                    print("❌ Нет данных в ответе")
                    completion(.failure(NetworkError.urlSessionError))
                    return
                }
                
                do {
                    print("📦 Получены данные: \(data.count) байт")
                    print("📨 Ответ от сервера (raw): \(String(data: data, encoding: .utf8) ?? "—")")
                    
                    let decoded = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    let token = decoded.accessToken
                    OAuth2TokenStorage().token = token
                    completion(.success(token))
                } catch {
                    print("❌ Ошибка декодирования: \(error)")
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
