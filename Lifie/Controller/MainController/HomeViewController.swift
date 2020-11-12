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
    
    private var carouselFrame = CGRect(x: 0, y: 0, width: 250, height: 400)
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        tableView.register(PostHeaderTableViewCell.self, forCellReuseIdentifier: PostHeaderTableViewCell.identifier)
        tableView.register(PostActionsTableViewCell.self, forCellReuseIdentifier: PostActionsTableViewCell.identifier)
        tableView.register(PostCommentsTableViewCell.self, forCellReuseIdentifier: PostCommentsTableViewCell.identifier)
        return tableView
    }()
    
    private var homeTabView: HomeTabView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Playground"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleNotAuthenticated()
        reloadPosts()
        configureiCarousel()
        configureTabView()
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
        carousel = iCarousel(frame: CGRect(x: 25, y: 25, width: view.width, height: view.height-100))
        carousel?.delegate = self
        carousel?.dataSource = self
        carousel?.type = .cylinder
        carousel?.contentOffset = CGSize(width: -70, height: -20)
        guard let carousel = carousel else {
            return
        }
        view.addSubview(carousel)
    }
    
    private func configureTabView() {
        homeTabView = HomeTabView(frame: CGRect(x: 0, y: view.bottom - 100, width: view.width, height: 50))
        guard let homeTabView = homeTabView else {
            return
        }
        homeTabView.delegate = self
        view.addSubview(homeTabView)
    }
}

extension HomeViewController: iCarouselDelegate, iCarouselDataSource {
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return 15
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        if(index >= posts.count) {
            return PostPlaceHolderView(frame: carouselFrame)
        }
        let postView = PostView(model: posts[index], frame: carouselFrame)
        postView.delegate = self
        return postView
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        let post = posts[index]
        let viewController = PostViewController(model: post)
        viewController.title = post.postType.rawValue
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
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

extension HomeViewController: HomeTabViewDelegate {
    
    func didTapTabCylinderButton(){
        carousel?.type = .cylinder
    }
    func didTapTabWheelButton(){
        
    }
    func didTapTabCoverFlowButton(){
        
    }
    func didTapTabLinearButton(){
        
    }
    func didTapTabRotatoryButton(){
        
    }
}
