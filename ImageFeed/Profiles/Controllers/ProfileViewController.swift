//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 13.03.2025.
//
import UIKit
import Foundation
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private let avatar = UIImageView()
    private let nameLabel = UILabel()
    private let usernameLabel = UILabel()
    private let statusLabel = UILabel()
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        
        view.backgroundColor = .primaryBackground
        
        guard let profile = ProfileService.shared.profile else {
            print("❌ Профиль не найден")
            return
        }
        
        updateProfileDetails(profile: profile)
        updateAvatar()
    }
    
    func updateProfileDetails(profile: ProfileService.Profile) {
        view.backgroundColor = .primaryBackground
      
        
        avatar.image = UIImage(named: "AvatarSample")
        avatar.layer.cornerRadius = 35
        avatar.clipsToBounds = true
        
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
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        avatar.kf.setImage(with: url)
    }
    
    @objc private func didTapExitButton() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Да", style: .default) { _ in
                   ProfileLogoutService.shared.logout()
               })
        
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel, handler: nil))
        
       
        
        present(alert, animated: true, completion: nil)
    }
}

  
