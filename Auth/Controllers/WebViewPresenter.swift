//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 11/5/25.
//
import Foundation
import WebKit

// MARK: - WebViewPresenterProtocol
public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}

// MARK: - WebViewPresenter
final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
    
    // MARK: - Lifecycle
    func viewDidLoad() {
            guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else {
                print("Ошибка: не удалось создать URLComponents из строки")
                return
            }
            
            urlComponents.queryItems = [
                URLQueryItem(name: "client_id", value: Constants.accessKey),
                URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
                URLQueryItem(name: "response_type", value: "code"),
                URLQueryItem(name: "scope", value: Constants.accessScope)
            ]
            
            guard let url = urlComponents.url else {
                print("Ошибка: не удалось получить URL из urlComponents")
                return
            }
            
            let request = URLRequest(url: url)
            didUpdateProgressValue(0)
            view?.load(request: request)
        }
    
    // MARK: - Methods
    func didUpdateProgressValue(_ newValue: Double) {
            let newProgressValue = Float(newValue)
            view?.setProgressValue(newProgressValue)
            
            let shouldHideProgress = shouldHideProgress(for: newProgressValue)
            view?.setProgressHidden(shouldHideProgress)
        }
        
    func shouldHideProgress(for value: Float) -> Bool {
            abs(value - 1.0) <= 0.0001
        }
    
    func code(from url: URL) -> String? {
        guard let urlComponents = URLComponents(string: url.absoluteString),
              let items = urlComponents.queryItems,
              let codeItem = items.first(where: { $0.name == "code" }) else {
            return nil
        }
        return codeItem.value
    }
}
