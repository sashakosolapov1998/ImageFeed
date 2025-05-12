//
//  ImagesListPresenterProtocol.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 12/5/25.
//


import UIKit

protocol ImagesListViewProtocol: AnyObject {
    func updateTableViewAnimated()
    func reloadRows(at indexPaths: [IndexPath])
    func insertRows(at indexPaths: [IndexPath])
}

protocol ImagesListPresenterProtocol {
    func viewDidLoad()
    func willDisplayCell(at indexPath: IndexPath)
    func didTapLikeButton(at indexPath: IndexPath)
    func photo(at indexPath: IndexPath) -> ImagesListService.Photo?
    func formattedDate(for photo: ImagesListService.Photo) -> String
    var photosCount: Int { get }
}
