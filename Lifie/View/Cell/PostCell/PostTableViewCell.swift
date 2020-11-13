//
//  CircularCollectionViewCell.swift
//  Lifie
//
//  Created by HAISONG MEI on 10/27/20.
//  Copyright © 2020 HAISONG MEI. All rights reserved.
//

import UIKit
import AVFoundation

/// PostTableViewCell for post body in post table view
class PostTableViewCell: UITableViewCell {
    
    static let identifier = "PostTableViewCell"
    
    struct Constants {
        static let cornerRadius: CGFloat = 2.0
        static let textFont = UIFont(name: "AppleSDGothicNeo-Medium", size: 20)
        static let buttonConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .regular)
    }
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = nil
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let postCaption: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.backgroundColor = .systemBackground
        label.font = Constants.textFont
        label.layer.cornerRadius = Constants.cornerRadius
        label.clipsToBounds = true
        return label
    }()
    
    private var player: AVPlayer?
    
    private var playerLayer = AVPlayerLayer()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.addSublayer(playerLayer)
        contentView.addSubview(postImageView)
        contentView.addSubview(postCaption)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with post: UserPost) {
        switch post.postType {
        case .photo:
            postImageView.sd_setImage(with: post.postUrl)
            postCaption.text = post.caption
        case .video:
            player = AVPlayer(url: post.postUrl)
            playerLayer.player = player
            playerLayer.player?.volume = 0
            playerLayer.player?.play()
        }
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = contentView.frame
        postImageView.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.maxY/5*4)
        postCaption.frame = CGRect(x: 0, y: postImageView.bottom, width: contentView.frame.width, height: contentView.frame.maxY/5)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
    }
}
