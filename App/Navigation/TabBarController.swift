//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 03.05.2025
//
import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let imagesListVC = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController else {
            assertionFailure("Failed to cast to ImagesListViewController")
            return
        }
        let imagesListPresenter = ImagesListPresenter(view: imagesListVC)
        imagesListVC.configure(presenter: imagesListPresenter)
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfilePresenter(view: profileViewController)
        profileViewController.configure(presenter: profilePresenter)
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "Active"),
            selectedImage: nil
        )
        self.viewControllers = [imagesListVC, profileViewController]
    }
}
