//
//  LoginViewController.swift
//  Lifie
//
//  Created by HAISONG MEI on 10/25/20.
//  Copyright © 2020 HAISONG MEI. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    struct Constants {
        static let cornerRadius: CGFloat = 10.0
    }

    private let loginButtonA: UIButton = {
        let button = UIButton()
        button.setTitle("Login as user A", for: .normal)
        button.layer.cornerRadius = Constants.cornerRadius
        button.layer.masksToBounds = true
        button.backgroundColor = .lightGray
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let loginButtonB: UIButton = {
        let button = UIButton()
        button.setTitle("Login as user B", for: .normal)
        button.layer.cornerRadius = Constants.cornerRadius
        button.layer.masksToBounds = true
        button.backgroundColor = .darkGray
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let backgroundView: UIView = {
        let background = UIView()
        background.clipsToBounds = true
        let backgroundImage = UIImageView(image: UIImage(named: "bedroom"))
        background.addSubview(backgroundImage)
        return background
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backgroundView.frame = self.view.frame
        configureBackgroundView()
        
        loginButtonA.frame = CGRect(
            x: 50,
            y: backgroundView.height/3 * 2,
            width: view.width-100,
            height: 50
        )
        
        loginButtonB.frame = CGRect(
            x: 50,
            y: loginButtonA.bottom + 20,
            width: view.width-100,
            height: 50
        )
    }
        
    private func configureBackgroundView() {
        guard backgroundView.subviews.count == 1 else {
            return
        }
        guard let background = backgroundView.subviews.first else {
            return
        }
        background.frame = backgroundView.bounds
        let logoImage = UIImageView(image: UIImage(named: "logo"))
        background.addSubview(logoImage)
        logoImage.contentMode = .scaleAspectFit
        logoImage.frame = CGRect(
            x: backgroundView.width/4,
            y: backgroundView.height/10,
            width: backgroundView.width/2,
            height: backgroundView.height/4
        )
    }

    private func addSubViews() {
        view.addSubview(backgroundView)
        loginButtonA.addTarget(self, action: #selector(didTapLoginButtonA), for: .touchUpInside)
        view.addSubview(loginButtonA)
        loginButtonB.addTarget(self, action: #selector(didTapLoginButtonB), for: .touchUpInside)
        view.addSubview(loginButtonB)
    }
    
    @objc private func didTapLoginButtonA() {
        AuthenticationManager.shared.loginUser(
            username: "testUserA",
            email: nil,
            password: "password") { success in
                if success {
                    
                }
                else {
                    let alert = UIAlertController(
                        title: "Login Fails",
                        message: "Login fails for some reason",
                        preferredStyle: .alert)
                    alert.addAction(UIAlertAction(
                        title: "Dimiss",
                        style: .cancel,
                        handler: nil))
                    self.present(alert, animated: true)
                }
        }
    }
    
    @objc private func didTapLoginButtonB() {}
    
}

