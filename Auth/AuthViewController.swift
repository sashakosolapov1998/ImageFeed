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
// MARK: - AuthViewController
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
        navigationItem.backBarButtonItem?.accessibilityIdentifier = "navBackButton"
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
                let alert = UIAlertController(
                    title: "Что-то пошло не так(",
                    message: "Не удалось войти в систему",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "ОК", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else {
                assertionFailure("Failed to prepare for \(showWebViewSegueIdentifier)")
                return
            }
            let authHelper = AuthHelper()
            let webViewPresenter = WebViewPresenter(authHelper: authHelper)
            webViewViewController.presenter = webViewPresenter
            webViewPresenter.view = webViewViewController
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}
