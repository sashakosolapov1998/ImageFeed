//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 13.03.2025.
//
import UIKit
import Foundation
import Kingfisher
// MARK: - ProfileViewController
final class ProfileViewController: UIViewController, ProfileViewProtocol {
    
    // MARK: - Properties
    private let avatar = UIImageView()
    private let nameLabel = UILabel()
    private let usernameLabel = UILabel()
    private let statusLabel = UILabel()
    var exitButton = UIButton()
    
    private var presenter: ProfilePresenterProtocol?
    func configure(presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        view.backgroundColor = .primaryBackground
        setupProfileView()
    }
    
    // MARK: - ProfileViewProtocol
    func updateAvatar(with url: URL) {
        avatar.kf.setImage(with: url)
    }
    func showProfile(name: String, loginName: String, bio: String) {
        nameLabel.text = name
        usernameLabel.text = loginName
        statusLabel.text = bio
    }
    
    // MARK: - Private Methods
    @objc func didTapExitButton() {
        present(makeLogoutAlert(), animated: true)
    }
    func makeLogoutAlert() -> UIAlertController {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            self?.presenter?.didTapLogout()
        })
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel, handler: nil))
        
        return alert
    }
    
    // MARK: - SetupViewController
    private func setupProfileView() {
        view.backgroundColor = .primaryBackground
        
        avatar.layer.cornerRadius = 35
        avatar.clipsToBounds = true
        
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        
        usernameLabel.textColor = .gray
        usernameLabel.font = UIFont.systemFont(ofSize: 13)
        
        statusLabel.textColor = .white
        statusLabel.font = UIFont.systemFont(ofSize: 13)
        
        exitButton.setImage(UIImage(named: "ipad.and.arrow.forward"), for: .normal)
        exitButton.accessibilityIdentifier = "exit_button"
        exitButton.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
        
        [avatar, nameLabel, usernameLabel, statusLabel, exitButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatar.widthAnchor.constraint(equalToConstant: 70),
            avatar.heightAnchor.constraint(equalToConstant: 70),
            
            nameLabel.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatar.leadingAnchor),
            
            usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            usernameLabel.leadingAnchor.constraint(equalTo: avatar.leadingAnchor),
            
            statusLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: avatar.leadingAnchor),
            
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            exitButton.centerYAnchor.constraint(equalTo: avatar.centerYAnchor),
            exitButton.widthAnchor.constraint(equalToConstant: 44),
            exitButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
