//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 09.04.2025.
//
import Foundation
import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}
final class AuthViewController: UIViewController, WebViewViewControllerDelegate {
    private let ShowWebViewSegueIdentifier = "ShowWebView"
    weak var delegate: AuthViewControllerDelegate?
    
    @IBAction func didTapLoginButton(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowWebView", sender: self)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }

    // MARK: - Private Methods
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "chevron.backward")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "chevron.backward")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP Black")
    }

    // MARK: - WebViewViewControllerDelegate
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        print("📥 AuthViewController: получен code: \(code)")
        OAuth2Service.shared.fetchOAuthToken(code: code) { result in
            switch result {
            case .success(let token):
                print("Токен успешно получен: \(token)")
                self.delegate?.didAuthenticate(self)
                self.dismiss(animated: true)
            case .failure(let error):
                print("Ошибка при получении токена: \(error)")
                // Тут можно показать UIAlert пользователю
            }
        }
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("🧭 AuthVC: prepare(for:) вызван")
        print("➡️ segue.identifier = \(segue.identifier ?? "nil")")
        
        if segue.identifier == ShowWebViewSegueIdentifier,
           let webViewVC = segue.destination as? WebViewViewController {
            webViewVC.delegate = self
            print("✅ Делегат WebView установлен")
        }
    }
}
