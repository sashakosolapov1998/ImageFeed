//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 11.03.2025.
//
import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

// MARK: - ImageListCell
final class ImagesListCell: UITableViewCell {
    
    // MARK: - Static properties
    static let reuseIdentifier = "ImagesListCell"
    
    
    // MARK: - Outlets
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var cellImage: UIImageView!
    
    
    weak var delegate: ImagesListCellDelegate?
    
    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        likeButton.setImage(UIImage(named: "like_button_off"), for: .normal)
        likeButton.setImage(UIImage(named: "like_button_on"), for: .selected)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
        cellImage.image = nil
        dateLabel.text = ""
    }
    
    func setIsLiked(_ isLiked: Bool) {
        likeButton.isSelected = isLiked
    }
    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
}
