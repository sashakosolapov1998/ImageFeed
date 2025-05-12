//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 12/5/25.
//

import UIKit

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewProtocol?

    init(view: ImagesListViewProtocol) {
        self.view = view
    }

    private var notificationToken: NSObjectProtocol?

    private var currentPhotoCount = 0

    func viewDidLoad() {
        notificationToken = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }

            let newCount = ImagesListService.shared.photos.count
            let oldCount = self.currentPhotoCount

            print("Presenter: oldCount=\(oldCount), newCount=\(newCount)")

            if newCount > oldCount {
                let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
                self.view?.insertRows(at: indexPaths)
                self.currentPhotoCount = newCount // обновляем после вставки
            }
        }

        // Сохраняем старое значение ДО начала загрузки
        currentPhotoCount = photosCount
        ImagesListService.shared.fetchPhotosNextPage()
    }

    func willDisplayCell(at indexPath: IndexPath) {
        if indexPath.row + 1 == photosCount {
            ImagesListService.shared.fetchPhotosNextPage()
        }
    }

    func didTapLikeButton(at indexPath: IndexPath) {
        let photo = ImagesListService.shared.photos[indexPath.row]

        UIBlockingProgressHUD.show()

        ImagesListService.shared.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            UIBlockingProgressHUD.dismiss()

            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.view?.reloadRows(at: [indexPath])
                }
            case .failure:
                DispatchQueue.main.async {
                    self.view?.presentAlert(
                        title: "Ошибка",
                        message: "Не удалось поставить лайк. Попробуйте ещё раз."
                    )
                }
            }
        }
    }

    func photo(at indexPath: IndexPath) -> ImagesListService.Photo? {
        let photos = ImagesListService.shared.photos
        guard indexPath.row < photos.count else { return nil }
        return photos[indexPath.row]
    }

    func formattedDate(for photo: ImagesListService.Photo) -> String {
        guard let date = photo.createdAt else { return "" }

        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date)
    }

    var photosCount: Int {
        return ImagesListService.shared.photos.count
    }
}
