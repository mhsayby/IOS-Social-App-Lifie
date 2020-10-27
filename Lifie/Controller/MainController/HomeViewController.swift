//
//  ViewController.swift
//  Lifie
//
//  Created by HAISONG MEI on 10/15/20.
//  Copyright © 2020 HAISONG MEI. All rights reserved.
//

import FirebaseAuth
import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleNotAuthenticated()
    }

    private func handleNotAuthenticated() {
        if Auth.auth().currentUser == nil {
            let loginViewController = LoginViewController()
            loginViewController.modalPresentationStyle = .fullScreen
            present(loginViewController, animated: false)
        }
    }
}

