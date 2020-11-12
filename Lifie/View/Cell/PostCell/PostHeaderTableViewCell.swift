//
//  PostHeaderCarouselView.swift
//  Lifie
//
//  Created by HAISONG MEI on 10/27/20.
//  Copyright © 2020 HAISONG MEI. All rights reserved.
//

import UIKit

protocol PostHeaderTableViewCellDelegate: AnyObject {
    func didTapActionButton()
}

class PostHeaderTableViewCell: UITableViewCell {

    static let identifier = "PostHeaderTableViewCell"
    
    weak var delegate: PostHeaderTableViewCellDelegate?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(actionButton)
        actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
        contentView.backgroundColor = .secondarySystemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapActionButton() {
        delegate?.didTapActionButton()
    }
    
    public func configure(with model: User) {
        // configure view
        usernameLabel.text = model.username
        profileImageView.image = UIImage(systemName: "person.circle")
        profileImageView.sd_setImage(with: model.profilePhoto)
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = contentView.height - 4
        profileImageView.frame = CGRect(x: 2, y: 2, width: size, height: size)
        profileImageView.layer.cornerRadius = size / 2
        actionButton.frame = CGRect(x: contentView.width-size, y: 2, width: size, height: size)
        usernameLabel.frame = CGRect(x: profileImageView.right+10, y: 2, width: contentView.width-(size*2)-15, height: contentView.height-4)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        usernameLabel.text = nil
        profileImageView.image = nil
    }
}
