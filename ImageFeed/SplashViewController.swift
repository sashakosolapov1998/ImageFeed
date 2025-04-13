//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 13.04.2025.
//
import UIKit
import Foundation

final class SplashViewController: UIViewController, AuthViewControllerDelegate {
    private let storage = OAuth2TokenStorage()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = storage.token {
            // переход на галерею
            switchToTabBarController()
        } else {
            // переход на экран авторизации
            performSegue(withIdentifier: "ShowAuthenticationScreen", sender: nil)
        }
    }
    
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true) {[weak self] in self?.switchToTabBarController()}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAuthenticationScreen",
           let authVC = segue.destination as? AuthViewController {
            authVC.delegate = self
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
    }
}
