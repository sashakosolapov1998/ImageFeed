//
//  ProfileViewControllerSpy.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 13/5/25.
//
import ImageFeed
import Foundation
@testable import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var viewDidLoadCalled = false
    var didTapLogoutCalled = false

    weak var view: ProfileViewProtocol?

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func didTapLogout() {
        didTapLogoutCalled = true
    }
}
