//
//  PostCommentTableViewCell.swift
//  Lifie
//
//  Created by HAISONG MEI on 11/9/20.
//  Copyright © 2020 HAISONG MEI. All rights reserved.
//

import UIKit

class PostCommentsTableViewCell: UITableViewCell {

    static let identifier = "PostCommentsTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .secondarySystemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure() {
        // configure view
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
