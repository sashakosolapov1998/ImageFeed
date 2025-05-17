//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 11/5/25.
//

import Foundation

final class ProfilePresenter: ProfilePresenterProtocol {
    private var profileImageServiceObserver: NSObjectProtocol?
    weak var view: ProfileViewProtocol?
    
    init(view: ProfileViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        guard let profile = ProfileService.shared.profile else {
            print("❌ Профиль не найден")
            return
        }
        
        if let urlString = ProfileImageService.shared.avatarURL,
           let url = URL(string: urlString) {
            view?.updateAvatar(with: url)
        }
        
        view?.showProfile(
            name: profile.name,
            loginName: profile.loginName,
            bio: profile.bio ?? ""
        )
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard
                    let self = self,
                    let urlString = ProfileImageService.shared.avatarURL,
                    let url = URL(string: urlString)
                else { return }
                
                self.view?.updateAvatar(with: url)
            }
    }
    
    func didTapLogout() {
        ProfileLogoutService.shared.logout()
    }
}

