//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 09.04.2025.
//
import Foundation
import WebKit
import UIKit
// MARK: - WebView Protocol
public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

// MARK: - WebView Constants
enum WebViewConstants {
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}
// MARK: - WebViewViewController
final class WebViewViewController: UIViewController, WKNavigationDelegate, WebViewViewControllerProtocol {
    
    var presenter: (any WebViewPresenterProtocol)?
    func load(request: URLRequest) {
        webView.load(request)
    }
    
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
        webView.accessibilityIdentifier = "authWebView"
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 self.presenter?.didUpdateProgressValue(self.webView.estimatedProgress)
             })
        presenter?.viewDidLoad()
    }
    
    // MARK: - Methods
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        guard let url = navigationAction.request.url else { return nil }
        return presenter?.code(from: url)
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
