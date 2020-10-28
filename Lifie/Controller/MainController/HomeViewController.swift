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

    private var carousel: iCarousel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureiCarousel()
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
    
    private func configureiCarousel() {
        carousel = iCarousel(frame: CGRect(x: 25, y: 25, width: self.view.width-50, height: self.view.height/2))
        carousel?.dataSource = self
        carousel?.type = .cylinder
        guard let carousel = carousel else {
            return
        }
        self.view.addSubview(carousel)
    }
}

extension HomeViewController: iCarouselDelegate, iCarouselDataSource {
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return 15
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let imageView: UIImageView

        if view != nil {
            imageView = view as! UIImageView
        } else {
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        }

        imageView.image = UIImage(named: "bedroom")

        
        return imageView
    }
    
}

