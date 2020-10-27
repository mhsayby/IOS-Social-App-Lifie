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

    private var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let carousel = iCarousel(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        carousel.dataSource = self
        carousel.type = .coverFlow
        view.addSubview(carousel)

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

extension HomeViewController: iCarouselDelegate, iCarouselDataSource {
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return 10
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let imageView: UIImageView

        if view != nil {
            imageView = view as! UIImageView
        } else {
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 128, height: 128))
        }

        imageView.image = UIImage(named: "bedroom")

        return imageView
    }
    
}

