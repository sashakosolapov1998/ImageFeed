//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 11.03.2025.
//
import UIKit
import Kingfisher
// MARK: - ImageListCell
final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - Outlets
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var cellImage: UIImageView!
    
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
}

