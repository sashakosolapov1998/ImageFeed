//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 13.03.2025.
//
import UIKit

final class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfileScreen()
        
    }
    
    func setupProfileScreen() {
        view.backgroundColor = .primaryBackground
        
        let avatar = UIImageView()
        avatar.image = UIImage(named: "AvatarSample")
        avatar.layer.cornerRadius = 35
        avatar.clipsToBounds = true
        
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        
        let usernameLabel = UILabel()
        usernameLabel.text = "@ekaterina_novikova"
        usernameLabel.textColor = .gray
        usernameLabel.font = UIFont.systemFont(ofSize: 13)
        
        let statusLabel = UILabel()
        statusLabel.text = "Hello, world!"
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
