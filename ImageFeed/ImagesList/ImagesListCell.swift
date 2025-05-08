//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 11.03.2025.
//
import UIKit

final class ImagesListCell: UITableViewCell {
    
    // MARK: - Static properties
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - @IBOutlet properties
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var cellImage: UIImageView!
    
    // MARK: - Override methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        likeButton.setImage(UIImage(named: "like_button_off"), for: .normal)
        likeButton.setImage(UIImage(named: "like_button_on"), for: .selected)
    }
}

