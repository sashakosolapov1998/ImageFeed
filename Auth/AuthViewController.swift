//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 09.04.2025.
//
import Foundation
import UIKit
import ProgressHUD

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}
final class AuthViewController: UIViewController, WebViewViewControllerDelegate {
    private let showWebViewSegueIdentifier = "ShowWebView"
    weak var delegate: AuthViewControllerDelegate?
    
    
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func didTapLoginButton(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowWebView", sender: self)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
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
        UIBlockingProgressHUD.show()
        OAuth2Service.shared.fetchOAuthToken(code: code) { [weak self, weak vc] result in
            guard let self = self, let vc = vc else { return }
            switch result {
            case .success(let token):
                UIBlockingProgressHUD.dismiss()
                print("Токен успешно получен: \(token)")
                self.delegate?.didAuthenticate(self)
                self.dismiss(animated: true)
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print("Ошибка при получении токена: \(error)")
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
        
        if segue.identifier == showWebViewSegueIdentifier,
           let webViewVC = segue.destination as? WebViewViewController {
            webViewVC.delegate = self
            print("✅ Делегат WebView установлен")
        }
    }
}
