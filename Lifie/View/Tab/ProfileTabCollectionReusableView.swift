//
//  ProfileTabCollectionReusableView.swift
//  Lifie
//
//  Created by HAISONG MEI on 10/27/20.
//  Copyright © 2020 HAISONG MEI. All rights reserved.
//

import UIKit

/// PostViewDelegate for responses of actions from profile tab
protocol ProfileTabCollectionReusableViewDelegate: AnyObject {
    func didTapTabGridButton()
    func didTapTabTaggedButton()
}

/// HomeTabView is used in ProfileViewController, contains buttons to change ways to show posts
class ProfileTabCollectionReusableView: UICollectionReusableView {
    
    //MARK: - fields
        
    static let identifier = "ProfileTabCollectionReusableView"
    
    public weak var delegate: ProfileTabCollectionReusableViewDelegate?
    
    struct Constants {
        static let padding: CGFloat = 12
    }
    
    private let gridButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.tintColor = .systemBlue
        button.setBackgroundImage(UIImage(systemName: "square.grid.2x2"), for: .normal)
        return button
    }()
    
    private let taggedButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.tintColor = .secondarySystemBackground
        button.setBackgroundImage(UIImage(systemName: "tag"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        clipsToBounds = true
        configureButtons()
    }
    
    //MARK: - initializations
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - life cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = height - Constants.padding * 2
        let gridButtonX = (width/2 - size) / 2
        gridButton.frame = CGRect(x: gridButtonX, y: Constants.padding, width: size, height: size)
        taggedButton.frame = CGRect(x: gridButtonX + width/2, y: Constants.padding, width: size, height: size)
    }
    
    //MARK: - configurations
    
    private func configureButtons() {
        gridButton.addTarget(self, action: #selector(didTapGridButton), for: .touchUpInside)
        addSubview(gridButton)
        taggedButton.addTarget(self, action: #selector(didTapTaggedButton), for: .touchUpInside)
        addSubview(taggedButton)
    }
    
    //MARK: - actions
    
    @objc func didTapGridButton() {
        gridButton.tintColor = .systemBlue
        taggedButton.tintColor = .lightGray
        delegate?.didTapTabGridButton()
    }
    
    @objc func didTapTaggedButton() {
        gridButton.tintColor = .lightGray
        taggedButton.tintColor = .systemBlue
        delegate?.didTapTabTaggedButton()
    }
}
