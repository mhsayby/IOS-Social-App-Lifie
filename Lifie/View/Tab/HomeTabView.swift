//
//  HomeTabView.swift
//  Lifie
//
//  Created by HAISONG MEI on 11/12/20.
//  Copyright © 2020 HAISONG MEI. All rights reserved.
//

import UIKit

/// PostViewDelegate for responses of actions from home tab
protocol HomeTabViewDelegate: AnyObject {
    func didTapTabCylinderButton()
    func didTapTabWheelButton()
    func didTapTabCoverFlowButton()
    func didTapTabLinearButton()
    func didTapTabRotatoryButton()
}

/// HomeTabView is used in HomeViewController, contains buttons to change iCarousel type
class HomeTabView: UIView {
    
    //MARK: - fields
        
    static let identifier = "HomeTabView"
    
    public weak var delegate: HomeTabViewDelegate?
    
    struct Constants {
        static let padding: CGFloat = 10
        static let selectedColor = UIColor.lightGray
        static let commonColor = UIColor.label
    }
    
    private let cylinderButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.tintColor = Constants.selectedColor
        button.setBackgroundImage(UIImage(systemName: "arrow.2.circlepath"), for: .normal)
        return button
    }()
    
    private let wheelButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.tintColor = Constants.commonColor
        button.setBackgroundImage(UIImage(systemName: "arrow.counterclockwise.circle"), for: .normal)
        return button
    }()
    
    private let coverFlowButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.tintColor = Constants.commonColor
        button.setBackgroundImage(UIImage(systemName: "barcode"), for: .normal)
        return button
    }()
    
    private let linearButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.tintColor = Constants.commonColor
        button.setBackgroundImage(UIImage(systemName: "arrow.left.to.line.alt"), for: .normal)
        return button
    }()
    
    private let rotatoryButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.tintColor = Constants.commonColor
        button.setBackgroundImage(UIImage(systemName: "rotate.left"), for: .normal)

        return button
    }()
    
    //MARK: - initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        clipsToBounds = true
        configureButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - life cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let buttonHeight = height - Constants.padding * 2
        let buttonWidth = (width - Constants.padding * 6 * 3)/5
        cylinderButton.frame = CGRect(x: Constants.padding * 2, y: Constants.padding, width: buttonWidth, height: buttonHeight)
        wheelButton.frame = CGRect(x: cylinderButton.right + Constants.padding * 3, y: Constants.padding, width: buttonWidth, height: buttonHeight)
        coverFlowButton.frame = CGRect(x: wheelButton.right + Constants.padding * 3, y: Constants.padding, width: buttonWidth, height: buttonHeight)
        linearButton.frame = CGRect(x: coverFlowButton.right + Constants.padding * 3, y: Constants.padding, width: buttonWidth, height: buttonHeight)
        rotatoryButton.frame = CGRect(x: linearButton.right + Constants.padding * 3, y: Constants.padding, width: buttonWidth, height: buttonHeight)
    }
    
    //MARK: - configurations
    
    private func configureButtons() {
        cylinderButton.addTarget(self, action: #selector(didTapCylinderButton), for: .touchUpInside)
        addSubview(cylinderButton)
        wheelButton.addTarget(self, action: #selector(didTapWheelButton), for: .touchUpInside)
        addSubview(wheelButton)
        coverFlowButton.addTarget(self, action: #selector(didTapCoverFlowButton), for: .touchUpInside)
        addSubview(coverFlowButton)
        linearButton.addTarget(self, action: #selector(didTapLinearButton), for: .touchUpInside)
        addSubview(linearButton)
        rotatoryButton.addTarget(self, action: #selector(didTapRotatoryButton), for: .touchUpInside)
        addSubview(rotatoryButton)
    }
    
    //MARK: - actions
    
    @objc func didTapCylinderButton() {
        cylinderButton.tintColor = Constants.selectedColor
        wheelButton.tintColor = Constants.commonColor
        coverFlowButton.tintColor = Constants.commonColor
        linearButton.tintColor = Constants.commonColor
        rotatoryButton.tintColor = Constants.commonColor
        delegate?.didTapTabCylinderButton()
    }
    
    @objc func didTapWheelButton() {
        cylinderButton.tintColor = Constants.commonColor
        wheelButton.tintColor = Constants.selectedColor
        coverFlowButton.tintColor = Constants.commonColor
        linearButton.tintColor = Constants.commonColor
        rotatoryButton.tintColor = Constants.commonColor
        delegate?.didTapTabWheelButton()
    }
    
    @objc func didTapCoverFlowButton() {
        cylinderButton.tintColor = Constants.commonColor
        wheelButton.tintColor = Constants.commonColor
        coverFlowButton.tintColor = Constants.selectedColor
        linearButton.tintColor = Constants.commonColor
        rotatoryButton.tintColor = Constants.commonColor
        delegate?.didTapTabCoverFlowButton()
    }
    
    @objc func didTapLinearButton() {
        cylinderButton.tintColor = Constants.commonColor
        wheelButton.tintColor = Constants.commonColor
        coverFlowButton.tintColor = Constants.commonColor
        linearButton.tintColor = Constants.selectedColor
        rotatoryButton.tintColor = Constants.commonColor
        delegate?.didTapTabLinearButton()
    }
    
    @objc func didTapRotatoryButton() {
        cylinderButton.tintColor = Constants.commonColor
        wheelButton.tintColor = Constants.commonColor
        coverFlowButton.tintColor = Constants.commonColor
        linearButton.tintColor = Constants.commonColor
        rotatoryButton.tintColor = Constants.selectedColor
        delegate?.didTapTabRotatoryButton()
    }
}

