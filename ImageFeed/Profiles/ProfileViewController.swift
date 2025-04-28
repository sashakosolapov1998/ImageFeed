//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 13.03.2025.
//
import UIKit
import Foundation

final class ProfileViewController: UIViewController {
    
    private let nameLabel = UILabel()
    private let usernameLabel = UILabel()
    private let statusLabel = UILabel()
    private var profile: ProfileService.Profile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .primaryBackground
        
        guard let token = OAuth2TokenStorage().token else {
            print("❌ Токен не найден")
            return
        }

        ProfileService.shared.fetchProfile(token) { [weak self] result in
            switch result {
            case .success(let profile):
                self?.profile = profile
                self?.setupProfileScreen()
            case .failure(let error):
                print("❌ Ошибка загрузки профиля: \(error)")
            }
        }
    }
    
    func setupProfileScreen() {
        view.backgroundColor = .primaryBackground
        
        let avatar = UIImageView()
        avatar.image = UIImage(named: "AvatarSample")
        avatar.layer.cornerRadius = 35
        avatar.clipsToBounds = true
        
        guard let profile = profile else { return }
        nameLabel.text = profile.name
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        
        usernameLabel.text = profile.loginName
        usernameLabel.textColor = .gray
        usernameLabel.font = UIFont.systemFont(ofSize: 13)
        
        statusLabel.text = profile.bio
        statusLabel.textColor = .white
        statusLabel.font = UIFont.systemFont(ofSize: 13)
        
        let exitButton = UIButton()
        exitButton.setImage(UIImage(named: "ipad.and.arrow.forward "), for: .normal)
        
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
