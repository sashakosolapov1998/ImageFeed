//
//  ImagesListPresenterSpy.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 13/5/25.
//

import Foundation
@testable import ImageFeed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var viewDidLoadCalled = false
    var willDisplayCellCalledIndexPath: IndexPath?
    var didTapLikeCalledIndexPath: IndexPath?
    var lastRequestedPhotoIndex: IndexPath?

    var photosCount: Int {
        return 10
    }

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func photo(at indexPath: IndexPath) -> ImagesListService.Photo? {
        lastRequestedPhotoIndex = indexPath
        return ImagesListService.Photo(
            id: "1",
            size: CGSize(width: 100, height: 100),
            createdAt: nil,
            welcomeDescription: nil,
            thumbImageURL: "",
            smallImageURL: "",
            regularImageURL: "",
            fullImageURL: "",
            isLiked: false
        )
    }

    func formatDate(_ date: Date?) -> String {
        return "formatted-date"
    }

    func formattedDate(for photo: ImagesListService.Photo) -> String {
        return "formatted-date-for-photo"
    }

    func willDisplayCell(at indexPath: IndexPath) {
        willDisplayCellCalledIndexPath = indexPath
    }

    func didTapLikeButton(at indexPath: IndexPath) {
        didTapLikeCalledIndexPath = indexPath
    }
}
