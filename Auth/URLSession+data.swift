//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 13.04.2025.
//
import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidRequest
    case invalidResponse
    case tokenMissing
    case invalidURL
}

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    print("[dataTask]: NetworkError - Status code \(statusCode)")
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                print("[dataTask]: NetworkError - \(error.localizedDescription)")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError)) 
            }
        })
        
        return task
    }
    
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        let task = data(for: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    let decodedObject = try decoder.decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(decodedObject))
                    }
                } catch {
                    print("[objectTask]: DecodingError - \(error.localizedDescription)")
                    print("[objectTask]: Response data - \(String(data: data, encoding: .utf8) ?? "nil")")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        return task
    }
}
