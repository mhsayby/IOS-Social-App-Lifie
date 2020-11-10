//
//  NotificationLikeEventTableViewCell.swift
//  Lifie
//
//  Created by HAISONG MEI on 11/8/20.
//  Copyright © 2020 HAISONG MEI. All rights reserved.
//

import UIKit
import SDWebImage

protocol NotificationLikeEventTableViewCellDelegate: AnyObject {
    func didTapRelatedPostButton(model: Notification)
}

class NotificationLikeEventTableViewCell: UITableViewCell {

    static let identifer = "NotificationLikeEventTableViewCell"
    
    private var model: Notification?
    
    weak var delegate: NotificationLikeEventTableViewCellDelegate?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .tertiarySystemBackground
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.text = "Thrump likes your post"
        return label
    }()
    
    private let postButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "bedroom"), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(profileImageView)
        contentView.addSubview(label)
        contentView.addSubview(postButton)
        postButton.addTarget(self, action: #selector(didTapPostButton), for: .touchUpInside)
    }
    
    @objc func didTapPostButton() {
        guard let model = model else {
            return
        }
        delegate?.didTapRelatedPostButton(model: model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: Notification){
        self.model = model
        switch model.type {
        case .Like(let post):
            let thumb = post.thumbImage
            guard !thumb.absoluteString.contains("google.com") else {
                return
            }
            postButton.sd_setBackgroundImage(with: thumb, for: .normal)
            break
        default:
            break
        }
        label.text = model.text
        profileImageView.sd_setImage(with: model.user.profilePhoto, completed: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postButton.setTitle(nil, for: .normal)
//        postButton.backgroundColor = nil
//        postButton.layer.borderWidth = 0
        label.text = nil
        profileImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.frame = CGRect(x: 3,
                                        y: 3,
                                        width: contentView.height-6,
                                        height: contentView.height-6)
        profileImageView.layer.cornerRadius = profileImageView.height/2
        let size = contentView.height-4
        postButton.frame = CGRect(x: contentView.width,
                                  y: 2,
                                  width: size,
                                  height: size)
        label.frame = CGRect(x: profileImageView.right+5,
                             y: 0,
                             width: contentView.width-size-profileImageView.width-16,
                             height: contentView.height)
    }
}

