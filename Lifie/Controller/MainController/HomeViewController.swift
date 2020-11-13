//
//  ViewController.swift
//  Lifie
//
//  Created by HAISONG MEI on 10/15/20.
//  Copyright © 2020 HAISONG MEI. All rights reserved.
//

import FirebaseAuth
import UIKit

/// HomeViewController: use iCarousel to present posts from all users in database in cool ways
class HomeViewController: UIViewController {
    
    // MARK: - private fields

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
    
    // MARK: - life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Playground"
        observePostsChanges()
        configureiCarousel()
        configureTabView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleNotAuthenticated()
    }
    
    // MARK: - initialization
    
    private func observePostsChanges() {
        posts.removeAll(keepingCapacity: false)
        DatabaseManager.shared.downLoadPhotoPost { success, post in
            if success, let post = post {
                self.posts.insert(post, at: 0)
                if(self.posts.count > 15) {
                    self.posts.remove(at: 15)
                }
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
    
    //MARK: helper functions
    
    private func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dimiss",
                                      style: .cancel,
                                      handler: nil))
        self.present(alert, animated: true)
    }
}

// MARK: - iCarousel to present posts in cool ways
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
        if(index >= posts.count) {
            return
        }
        let post = posts[index]
        let viewController = PostViewController(model: post)
        viewController.title = post.postType.rawValue
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - PostView shown in iCarousel
extension HomeViewController: PostViewDelegate {
    
    func didTapActionLikeButton() {
        showAlert(title: "You tapped like button", message: "Not open yet")
    }
    
    func didTapActionCommentButton() {
        showAlert(title: "You tapped comment button", message: "Not open yet")
    }
    
    func didTapActionSendButton() {
        showAlert(title: "You tapped send button", message: "Not open yet")
    }
    
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

// MARK: - HomeTabView containing buttons to change iCarousel type
extension HomeViewController: HomeTabViewDelegate {
    
    func didTapTabCylinderButton(){
        carousel?.isHidden = true
        carousel?.type = .cylinder
        carousel?.reloadData()
        carousel?.isHidden = false
    }
    func didTapTabWheelButton(){
        carousel?.isHidden = true
        carousel?.type = .wheel
        carousel?.reloadData()
        carousel?.isHidden = false
    }
    func didTapTabCoverFlowButton(){
        carousel?.isHidden = true
        carousel?.type = .coverFlow
        carousel?.reloadData()
        carousel?.isHidden = false
    }
    func didTapTabLinearButton(){
        carousel?.isHidden = true
        carousel?.type = .linear
        carousel?.reloadData()
        carousel?.isHidden = false
    }
    func didTapTabRotatoryButton(){
        carousel?.isHidden = true
        carousel?.type = .rotary
        carousel?.reloadData()
        carousel?.isHidden = false
    }
}
