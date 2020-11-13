//
//  PostCommentTableViewCell.swift
//  Lifie
//
//  Created by HAISONG MEI on 11/9/20.
//  Copyright © 2020 HAISONG MEI. All rights reserved.
//

import UIKit

/// PostTableViewCell for post comments in post table view, haven't implemented yet
class PostCommentsTableViewCell: UITableViewCell {
    
    //MARK: - fields

    static let identifier = "PostCommentsTableViewCell"
    
    //MARK: - initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .secondarySystemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - configuration
    
    public func configure() {
        // configure view
    }
    
    //MARK: - life cycle
        
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
