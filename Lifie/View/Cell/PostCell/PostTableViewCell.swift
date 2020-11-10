//
//  CircularCollectionViewCell.swift
//  Lifie
//
//  Created by HAISONG MEI on 10/27/20.
//  Copyright © 2020 HAISONG MEI. All rights reserved.
//

import UIKit
import AVFoundation

/// Cell for post body in post table view
class PostTableViewCell: UITableViewCell {
    
    static let identifier = "PostTableViewCell"
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = nil
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var player: AVPlayer?
    
    private var playerLayer = AVPlayerLayer()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.addSublayer(playerLayer)
        contentView.addSubview(postImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with post: UserPost) {
        postImageView.image = UIImage(named: "bedroom")
        return
        
        
        switch post.postType {
        case .photo:
            postImageView.sd_setImage(with: post.postUrl)
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
        postImageView.frame = contentView.frame
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
    }
}
