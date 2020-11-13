//
//  PostView.swift
//  Lifie
//
//  Created by HAISONG MEI on 11/12/20.
//  Copyright © 2020 HAISONG MEI. All rights reserved.
//

import UIKit

/// PostPlaceHolderView is used in HomeViewController when available posts are not enough
class PostPlaceHolderView: UIView {
    
    //MARK: - private fields
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = nil
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // UIView to mask the screen
    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.isHidden = false
        view.alpha = 0.7
        return view
    }()
    
    //MARK: - initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        self.layer.cornerRadius = 5.0
        imageView.image = UIImage(named: "bedroom")
        addSubview(imageView)
        addSubview(dimmedView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - life cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.frame.insetBy(dx: 10, dy: 10)
        dimmedView.frame = self.frame.insetBy(dx: 10, dy: 10)
    }
}
