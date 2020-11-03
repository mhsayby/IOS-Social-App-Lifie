//
//  ProfileTabCollectionReusableView.swift
//  Lifie
//
//  Created by HAISONG MEI on 10/27/20.
//  Copyright © 2020 HAISONG MEI. All rights reserved.
//

import UIKit

class ProfileTabCollectionReusableView: UICollectionReusableView {
        
    static let identifier = "ProfileTabCollectionReusableView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
