//
//  PhotoCollectionViewCell.swift
//  Lifie
//
//  Created by HAISONG MEI on 10/27/20.
//  Copyright © 2020 HAISONG MEI. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PhotoCollectionViewCell"
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 5.0
        photoImageView.frame = contentView.frame.insetBy(dx: 1, dy: 1)
        photoImageView.layer.cornerRadius = 5.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(photoImageView)
        contentView.clipsToBounds = true
        accessibilityLabel = "User post image"
        accessibilityHint = "Double tap to post"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: UserPost) {
        photoImageView.sd_setImage(with: model.postUrl)
    }
    
    public func configure(with debug: String) {
        photoImageView.image = UIImage(named: "bedroom")
    }
}
