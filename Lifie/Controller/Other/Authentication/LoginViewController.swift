//
//  LoginViewController.swift
//  Lifie
//
//  Created by HAISONG MEI on 10/25/20.
//  Copyright © 2020 HAISONG MEI. All rights reserved.
//

import UIKit

// two test users
struct TestUserA {
    static let username = "testUserA"
    static let email = "testUserA@duke.edu"
    static let password = "passwordA"
}

struct TestUserB {
    static let username = "testUserB"
    static let email = "testUserB@duke.edu"
    static let password = "passwordB"
}

/// LoginViewController to login, pre-added 2 test users can be used to test
class LoginViewController: UIViewController {
    
    //MARK: - private fields
    
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
    
    //MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureBackgroundView()
        configureButtons()
        configureAuth()
    }
    
    private func addSubViews() {
        view.addSubview(backgroundView)
        view.addSubview(loginButtonA)
        view.addSubview(loginButtonB)
    }
    
    //MARK: - configurations
        
    private func configureBackgroundView() {
        backgroundView.frame = self.view.frame
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
        logoImage.frame = CGRect(x: backgroundView.width/4,
                                 y: backgroundView.height/10,
                                 width: backgroundView.width/2,
                                 height: backgroundView.height/4)
    }
    
    private func configureButtons() {
        loginButtonA.frame = CGRect(x: 50,
                                    y: backgroundView.height/3 * 2,
                                    width: view.width-100,
                                    height: 50)
        loginButtonA.addTarget(self, action: #selector(didTapLoginButtonA), for: .touchUpInside)
        loginButtonB.frame = CGRect(x: 50,
                                    y: loginButtonA.bottom + 20,
                                    width: view.width-100,
                                    height: 50)
        loginButtonB.addTarget(self, action: #selector(didTapLoginButtonB), for: .touchUpInside)
    }
    
    private func configureAuth() {
        
        // TODO: check if first open this page
        
        AuthenticationManager.shared.registerUser(username: TestUserA.username, email: TestUserA.email, password: TestUserA.password) { (registered) in
            DispatchQueue.main.async {
                if registered {
                    print("[Init] Register user A succeeds")
                }
                else {
                    print("[Init] User A has been registered")
                }
            }
        }
        AuthenticationManager.shared.registerUser(username: TestUserB.username, email: TestUserB.email, password: TestUserB.password) { (registered) in
            DispatchQueue.main.async {
                if registered {
                    print("[Init] Register user B succeeds")
                }
                else {
                    print("[Init] User B has been registered")
                }
            }
        }
    }
    
    //MARK: - actions
    
    @objc private func didTapLoginButtonA() {
        AuthenticationManager.shared.loginUser(username: nil, email: TestUserA.email, password: TestUserA.password) { success in
            DispatchQueue.main.async {
                if success {
                    //login succeeds
                    self.dismiss(animated: true, completion: nil)
                    //cache userA as currentUser in UserDefaults
                    let userA = User(username: TestUserA.username, firstName: TestUserA.username, lastName: "Willams", bio: "Willams's bio is here", birthDate: Date(), gender: .female, counts: UserCount(followers: 0, following: 0, posts: 0), joinDate: Date(), profilePhoto: URL(string: "https://firebasestorage.googleapis.com/v0/b/lifie-b986c.appspot.com/o/users%2F49492405-E747-410B-8922-1A7046C9A6B4?alt=media&token=4e8caa78-1f28-4ed3-803a-94fbabc01f73")!)
                    DatabaseManager.shared.setCurrentUserDefaults(model: userA)
                }
                else {
                    self.loginFailAlert()
                }
            }
        }
    }
    
    @objc private func didTapLoginButtonB() {
        AuthenticationManager.shared.loginUser(username: nil, email: TestUserB.email, password: TestUserB.password) { success in
            DispatchQueue.main.async {
                if success {
                    //login succeeds
                    self.dismiss(animated: true, completion: nil)
                    //cache userB as currentUser in UserDefaults
                    let userB = User(username: TestUserB.username, firstName: TestUserB.username, lastName: "Smith", bio: "Smith's bio is here", birthDate: Date(), gender: .male, counts: UserCount(followers: 0, following: 0, posts: 0), joinDate: Date(), profilePhoto: URL(string: "https://firebasestorage.googleapis.com/v0/b/lifie-b986c.appspot.com/o/posts%2F20F41BE0-D6BE-4109-B520-B16A93E62801?alt=media&token=f53b2fff-fd62-4bf3-994d-f3fc6a0dbaac")!)
                    DatabaseManager.shared.setCurrentUserDefaults(model: userB)
                }
                else {
                    self.loginFailAlert()
                }
            }
        }
    }
    
    //MARK: - helper functions
    
    private func loginFailAlert(){
        let alert = UIAlertController(title: "Login Fails",
                                      message: "Login fails for some reason",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dimiss",
                                      style: .cancel,
                                      handler: nil))
        self.present(alert, animated: true)
    }
    
}

