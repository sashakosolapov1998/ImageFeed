//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 11.03.2025.
//
import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var cellImage: UIImageView!
    
    override func awakeFromNib() {
            super.awakeFromNib()

            // Вот это обязательно!
            likeButton.setImage(UIImage(named: "like_button_off"), for: .normal)
            likeButton.setImage(UIImage(named: "like_button_on"), for: .selected)
        }
}

