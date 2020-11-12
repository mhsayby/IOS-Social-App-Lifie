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
    
    private var posts = [UserPost]()
    
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
        reloadPosts()
        configureiCarousel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleNotAuthenticated()
    }
    
    private func reloadPosts() {
        posts.removeAll(keepingCapacity: false)
        DatabaseManager.shared.downLoadPhotoPost { success, post in
            if success, let post = post {
                self.posts.append(post)
            }
            else {
                
            }
            self.carousel?.reloadData()
        }
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
        if(index == 0){
            let postView = PostView(model: testPost, frame: CGRect(x: 0, y: 0, width: 220, height: 400))
            postView.delegate = self
            return postView
        }
        if(index >= posts.count) {
            return UIView()
        }
        let postView = PostView(model: posts[index], frame: CGRect(x: 0, y: 0, width: 220, height: 400))
        postView.delegate = self
        return postView
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        
    }
    
    func carouselDidScroll(_ carousel: iCarousel) {

    }
    
}

extension HomeViewController: PostViewDelegate {
    func didTapHeaderActionButton() {
        let actionSheet = UIAlertController(title: "Post Actions", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Report", style: .destructive, handler: { [weak self] _ in
            self?.reportPost()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
    
    func reportPost() {
        // Implement this if you want to report this post
    }
}
