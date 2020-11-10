//
//  ViewController.swift
//  Lifie
//
//  Created by HAISONG MEI on 10/15/20.
//  Copyright © 2020 HAISONG MEI. All rights reserved.
//

import FirebaseAuth
import UIKit

struct HomePostViewModel {
    let header: PostViewModel
    let post: PostViewModel
    let actions: PostViewModel
    let comments: PostViewModel
}

class HomeViewController: UIViewController {

    private var carousel: iCarousel?
    
    private var renderModels = [HomePostViewModel]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        tableView.register(PostHeaderTableViewCell.self, forCellReuseIdentifier: PostHeaderTableViewCell.identifier)
        tableView.register(PostActionsTableViewCell.self, forCellReuseIdentifier: PostActionsTableViewCell.identifier)
        tableView.register(PostCommentsTableViewCell.self, forCellReuseIdentifier: PostCommentsTableViewCell.identifier)
        return tableView
    }()
    
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
        carousel = iCarousel(frame: CGRect(x: 25, y: 25, width: self.view.width-50, height: self.view.height-100))
        carousel?.delegate = self
        carousel?.dataSource = self
        carousel?.type = .cylinder
        carousel?.contentOffset = CGSize(width: -100, height: -20)
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
        let user = User(username: "@Thrump", name: (first: "Donald", last: "Trump"), bio: "", birthDate: Date(), gender: .male, counts: UserCount(followers: 0, following: 0, posts: 0), joinDate: Date(), profilePhoto: URL(string: "https://www.google.com")!)
        let post = UserPost(identifier: "", owner: user, postType: .photo, thumbImage: URL(string: "https://www.google.com")!, postUrl: URL(string: "https://www.google.com")!, caption: nil, likes: [], comments: [], createDate: Date(), taggedUsers: [])
        let postView = PostView(model: post, frame: CGRect(x: 0, y: 0, width: 220, height: 400))
//        let imageView: UIImageView
//
//        if view != nil {
//            imageView = view as! UIImageView
//        } else {
//            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
//        }
//
//        imageView.image = UIImage(named: "bedroom")

        
        return postView
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        
    }
}

