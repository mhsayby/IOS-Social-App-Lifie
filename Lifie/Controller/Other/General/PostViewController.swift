//
//  PostViewController.swift
//  Lifie
//
//  Created by HAISONG MEI on 10/15/20.
//  Copyright © 2020 HAISONG MEI. All rights reserved.
//

import UIKit

/// PostViewController shows one post in a single view controller
class PostViewController: UIViewController {
    
    // MARK: - private fields
    
    private let post: UserPost?
    
    private var postView: PostView?
    
    // MARK: - initialization

    init(model: UserPost) {
        self.post = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configurePostView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - configurations
    
    private func configurePostView() {
        guard let post = self.post else {
            return
        }
        postView = PostView(model: post, frame: view.frame)
        guard let postView = postView else {
            return
        }
        postView.delegate = self
        view.addSubview(postView)
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

// MARK: - response to PostView actions
extension PostViewController: PostViewDelegate {
    
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
