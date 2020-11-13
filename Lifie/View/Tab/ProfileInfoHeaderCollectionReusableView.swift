//
//  ProfileInfoHeaderCollectionReusableView.swift
//  Lifie
//
//  Created by HAISONG MEI on 10/27/20.
//  Copyright © 2020 HAISONG MEI. All rights reserved.
//

import UIKit

/// PostViewDelegate for responses of actions from profile header
protocol ProfileInfoHeaderCollectionReusableViewDelegate: AnyObject {
    func profileHeaderDidTapPostsButton(_ header: ProfileInfoHeaderCollectionReusableView)
    func profileHeaderDidTapFollowersButton(_ header: ProfileInfoHeaderCollectionReusableView)
    func profileHeaderDidTapFollowingButton(_ header: ProfileInfoHeaderCollectionReusableView)
}

/// HomeTabView is used in ProfileViewController, presents user profile data
class ProfileInfoHeaderCollectionReusableView: UICollectionReusableView {
    
    //MARK: - fields
        
    static let identifier = "ProfileInfoHeaderCollectionReusableView"
    
    public weak var delegate: ProfileInfoHeaderCollectionReusableViewDelegate?
    
    private var currentUser: User?
    
    struct Constants {
        static let cornerRadius: CGFloat = 10.0
        static let textFont = UIFont(name: "AppleSDGothicNeo-Medium", size: 20)
    }
    
    private let profilePhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let postsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Posts", for: .normal)
        button.backgroundColor = .secondarySystemBackground
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = Constants.cornerRadius
        return button
    }()
    
    private let followersButton: UIButton = {
        let button = UIButton()
        button.setTitle("Followers", for: .normal)
        button.backgroundColor = .secondarySystemBackground
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = Constants.cornerRadius
        return button
    }()
    
    private let followingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Following", for: .normal)
        button.backgroundColor = .secondarySystemBackground
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = Constants.cornerRadius
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name is here. Hopefully you can see"
        label.textColor = .label
        label.numberOfLines = 1
        label.layer.cornerRadius = Constants.cornerRadius
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.text = "Bio"
        label.textColor = .label
        label.numberOfLines = 0
        label.layer.cornerRadius = Constants.cornerRadius
        return label
    }()
    
    //MARK: - initializations
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        addButtonActions()
        backgroundColor = .systemBackground
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - configurations
    
    func configure(with model: User) {
        self.currentUser = model
        if let currentUser = currentUser {
            profilePhotoImageView.sd_setImage(with: currentUser.profilePhoto)
            nameLabel.text = "\(model.firstName) \(model.lastName)"
            bioLabel.text = model.bio
        }
    }
    
    //MARK: - helper functions
    
    private func addSubviews() {
        addSubview(profilePhotoImageView)
        addSubview(postsButton)
        addSubview(followersButton)
        addSubview(followingButton)
        addSubview(bioLabel)
        addSubview(nameLabel)
    }
    
    private func addButtonActions() {
        followersButton.addTarget(self, action: #selector(didTapFollowersButton), for: .touchUpInside)
        followingButton.addTarget(self, action: #selector(didTapFollowingButton), for: .touchUpInside)
        postsButton.addTarget(self, action: #selector(didTapPostsButton), for: .touchUpInside)
    }
    
    //MARK: - life cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Set photo
        let photoSize = width / 4
        profilePhotoImageView.frame = CGRect(x: 5, y: 5, width: photoSize, height: photoSize)
        profilePhotoImageView.layer.cornerRadius = photoSize/2
        
        // Set buttons
        let buttonHeight = photoSize / 2;
        let buttonWidth = (width - 10 - photoSize) / 3
        postsButton.frame = CGRect(x: profilePhotoImageView.right, y: 5, width: buttonWidth, height: buttonHeight)
        followersButton.frame = CGRect(x: postsButton.right, y: 5, width: buttonWidth, height: buttonHeight)
        followingButton.frame = CGRect(x: followersButton.right, y: 5, width: buttonWidth, height: buttonHeight)
        
        // Set labels
        nameLabel.frame = CGRect(x: 5, y: 5 + profilePhotoImageView.bottom, width: width - 10, height: buttonHeight)
        bioLabel.frame = CGRect(x: 5, y: 5 + nameLabel.bottom, width: width - 10, height: buttonHeight)
    }
    
    // MARK: - actions
    
    @objc private func didTapFollowersButton() {
        delegate?.profileHeaderDidTapFollowersButton(self)
    }
    
    @objc private func didTapFollowingButton() {
        delegate?.profileHeaderDidTapFollowingButton(self)
    }
    
    @objc private func didTapPostsButton() {
        delegate?.profileHeaderDidTapPostsButton(self)
    }
}
