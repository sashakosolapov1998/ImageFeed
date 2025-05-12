//
//  ViewController.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 28.02.2025.
//

import UIKit

// MARK: - ImagesListViewController
final class ImagesListViewController: UIViewController, ImagesListViewProtocol {
    func reloadRows(at indexPaths: [IndexPath]) {
        tableView.reloadRows(at: indexPaths, with: .automatic)
    }

    func insertRows(at indexPaths: [IndexPath]) {
        print("insertRows вызван для: \(indexPaths)") // уберем
        tableView.performBatchUpdates {
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
    
    // MARK: - Outlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Properties
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    // private var photos: [ImagesListService.Photo] = []
    // private let imageListService = ImagesListService.shared

    private var presenter: ImagesListPresenterProtocol?

    func configure(presenter: ImagesListPresenterProtocol) {
        self.presenter = presenter
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        print("Presenter photosCount on load: \(presenter?.photosCount ?? -1)") // уберем
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    
        presenter?.viewDidLoad()
    }
    
    // MARK: - Private Methods
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let photo = presenter?.photo(at: indexPath) else { return }

        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(
            with: URL(string: photo.regularImageURL),
            placeholder: UIImage(named: "Stub")
        )

        cell.dateLabel.text = presenter?.formattedDate(for: photo)
        cell.likeButton.isSelected = photo.isLiked
    }
    
    func updateTableViewAnimated() {
        let oldCount = tableView.numberOfRows(inSection: 0)
        let newCount = presenter?.photosCount ?? 0

        if oldCount != newCount {
            tableView.performBatchUpdates({
                let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
                tableView.insertRows(at: indexPaths, with: .automatic)
            }, completion: nil)
        }
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.photosCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        print("cellForRowAt вызван для \(indexPath.row)") // убрать
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        imageListCell.delegate = self
        return imageListCell
    }
}

// MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
        
    }
    
    func tableView(_ tableView:UITableView, willDisplay cell:UITableViewCell, forRowAt indexPath: IndexPath){
        presenter?.willDisplayCell(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photo = presenter?.photo(at: indexPath) else { return 0 }
        
        let imageWidth = tableView.bounds.width - 32
        let imageHeight = photo.size.height / photo.size.width * imageWidth
        
        return imageHeight + 16 + 8
    }
}
// MARK: - Navigation

extension ImagesListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            guard let photo = presenter?.photo(at: indexPath) else { return }
            viewController.imageURL = URL(string: photo.fullImageURL)
        } else {
            super.prepare(for: segue, sender: sender)
        }
        
    }
}

// MARK: - ImagesListCellDelegate

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter?.didTapLikeButton(at: indexPath)
    }
}
