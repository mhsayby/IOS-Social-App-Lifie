//
//  PostActionsCarouselView.swift
//  Lifie
//
//  Created by HAISONG MEI on 10/27/20.
//  Copyright © 2020 HAISONG MEI. All rights reserved.
//

import UIKit

protocol PostActionsTableViewCellDelegate: AnyObject {
    func didTapLikeButton()
    func didTapCommentButton()
    func didTapSendButton()
}

enum LikeState {
    case like, notLike
}

/// PostTableViewCell for post actions in post table view
class PostActionsTableViewCell: UITableViewCell {
    
    //MARK: - fields

    static let identifier = "PostActionsTableViewCell"
    
    weak var delegate: PostActionsTableViewCellDelegate?
    
    // Configuration for button image
    static let buttonConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
    
    private var likeState = LikeState.notLike
    private var commentState = LikeState.notLike
    private var sendState = LikeState.notLike
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart", withConfiguration: buttonConfig), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "message", withConfiguration: buttonConfig), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "paperplane", withConfiguration: buttonConfig), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    //MARK: - initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(sendButton)
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(didTapCommentButton), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - actions
    
    @objc func didTapLikeButton() {
        delegate?.didTapLikeButton()
        switch likeState {
        case .like:
            likeButton.setImage(UIImage(systemName: "heart", withConfiguration: PostActionsTableViewCell.buttonConfig), for: .normal)
            likeState = .notLike
        case .notLike:
            likeButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: PostActionsTableViewCell.buttonConfig), for: .normal)
            likeState = .like
        }
    }
    
    @objc func didTapCommentButton() {
        delegate?.didTapCommentButton()
        switch commentState {
        case .like:
            commentButton.setImage(UIImage(systemName: "message", withConfiguration: PostActionsTableViewCell.buttonConfig), for: .normal)
            commentState = .notLike
        case .notLike:
            commentButton.setImage(UIImage(systemName: "message.fill", withConfiguration: PostActionsTableViewCell.buttonConfig), for: .normal)
            commentState = .like
        }
    }
    
    @objc func didTapSendButton() {
        delegate?.didTapSendButton()
        switch sendState {
        case .like:
            sendButton.setImage(UIImage(systemName: "paperplane", withConfiguration: PostActionsTableViewCell.buttonConfig), for: .normal)
            sendState = .notLike
        case .notLike:
            sendButton.setImage(UIImage(systemName: "paperplane.fill", withConfiguration: PostActionsTableViewCell.buttonConfig), for: .normal)
            sendState = .like
        }
    }
    
    //MARK: - configuration
    
    public func configure(with post: UserPost) {
        // configure view
    }
    
    //MARK: - life cycle
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let buttonSize = contentView.height - 10
        let buttons = [likeButton, commentButton, sendButton]
        for i in 0..<buttons.count {
            let button = buttons[i]
            button.frame = CGRect(x: buttonSize * CGFloat(i), y: 5, width: buttonSize, height: buttonSize)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
