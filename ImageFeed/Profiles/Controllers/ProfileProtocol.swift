//
//  ProfilePresenterProtocol.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 11/5/25.
//

import Foundation

protocol ProfileViewProtocol: AnyObject {
    func showProfile(name: String, loginName: String, bio: String)
    func updateAvatar(with url: URL)
}

protocol ProfilePresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapLogout()
    var view : ProfileViewProtocol? { get set }

}
