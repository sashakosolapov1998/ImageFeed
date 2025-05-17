//
//  ProfileViewSpy.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 13/5/25.
//

//
//  ProfileTests.swift
//  ImageFeedTests
//
//  Created by Александр Косолапов on 13/5/25.
//
@testable import ImageFeed
import Foundation

 final class ProfileViewSpy: ProfileViewProtocol {
    var receivedName: String?
    var receivedLogin: String?
    var receivedBio: String?
    var updateAvatarCalled = false
    var receivedAvatarURL: URL?

    func showProfile(name: String, loginName: String, bio: String) {
        receivedName = name
        receivedLogin = loginName
        receivedBio = bio
    }

    func updateAvatar(with url: URL) {
        updateAvatarCalled = true
        receivedAvatarURL = url
    }
}

final class ProfilePresenterWithFakeData: ProfilePresenterProtocol {
    weak var view: ProfileViewProtocol?

    func viewDidLoad() {
        view?.showProfile(name: "Имя", loginName: "@login", bio: "Описание профиля")
    }

    func didTapLogout() {}
}
