//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 09.04.2025.
//
import Foundation
import WebKit
import UIKit

// MARK: - WebView Constants
enum WebViewConstants {
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

final class WebViewViewController: UIViewController, WKNavigationDelegate {
    
    // MARK: - Outlets
    @IBOutlet var webView: WKWebView!
    @IBOutlet var progressView: UIProgressView!
    
    // MARK: - Actions
    @IBAction private func didTapBackButton(_ sender: Any?) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    // MARK: - Public Properties
    weak var delegate: WebViewViewControllerDelegate?

    // MARK: - Private Properties
    private var estimatedProgressObservation: NSKeyValueObservation?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
            options: [],
            changeHandler: { [weak self] _, _ in
                guard let self = self else { return }
                self.updateProgress()
            })
        loadAuthView()
    }
    
    // MARK: - Private Methods
    private func loadAuthView() {
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
        webView.load(request)
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            
                let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
    // KVO for estimatedProgress is handled via estimatedProgressObservation property.
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
}

// MARK: - WKNavigationDelegate
extension WebViewViewController {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let url = navigationAction.request.url {
            print("➡️ Загружается URL: \(url)")
            if let code = code(from: navigationAction) {
                print("✅ Найден code: \(code)")
                delegate?.webViewViewController(self, didAuthenticateWithCode: code)
                print("📤 Делегат вызван с code")
                decisionHandler(.cancel)
                return
            } else {
                print("❌ Code не найден в URL")
            }
        }
        decisionHandler(.allow)
    }
}
