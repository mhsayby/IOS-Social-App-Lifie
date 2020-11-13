//
//  NotificationViewController.swift
//  Lifie
//
//  Created by HAISONG MEI on 10/15/20.
//  Copyright © 2020 HAISONG MEI. All rights reserved.
//

import UIKit

/// NotificationType: Another user likes your post or follows you
enum NotificationType {
    case like(post: UserPost)
    case follow(state: FollowState)
}

/// Notification struct used to present notifications
struct Notification {
    let type: NotificationType
    let text: String
    let user: User
}

/// NotificationViewController: notify users when notifications come, haven't implemented yet
class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - private fields

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = false
        tableView.register(NotificationLikeEventTableViewCell.self,
                           forCellReuseIdentifier: NotificationLikeEventTableViewCell.identifer)
        tableView.register(NotificationFollowEventTableViewCell.self,
                           forCellReuseIdentifier: NotificationFollowEventTableViewCell.identifer)
        return tableView
    }()
    
    private var models = [Notification]()
    
    private lazy var emptyNotificationView = EmptyNotificationView()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.tintColor = .label
        return spinner
    }()
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNotifications()
        navigationItem.title = "Notification"
        view.backgroundColor = .systemBackground
        view.addSubview(spinner)
        //spinner.startAnimating()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        configureEmptyNotificationView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
    }
    
    // MARK: - initialization

    private func configureEmptyNotificationView() {
        tableView.isHidden = true
        view.addSubview(emptyNotificationView)
        emptyNotificationView.frame = CGRect(x: 0, y: 0, width: view.width/2, height: view.height/4)
        emptyNotificationView.center = view.center
    }
    
    // MARK: - helper functions
    
    private func fetchNotifications() {
        if models.count == 0 {
            emptyNotificationView.isHidden = false
        }
    }
    
    private func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dimiss",
                                      style: .cancel,
                                      handler: nil))
        self.present(alert, animated: true)
    }
    
    // MARK: - UITableView to show notifications
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        switch model.type {
        case .like(_):
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationLikeEventTableViewCell.identifer, for: indexPath)
                as! NotificationLikeEventTableViewCell
            cell.configure(with: model)
            cell.delegate = self
            return cell
        case .follow:
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationFollowEventTableViewCell.identifer, for: indexPath)
                as! NotificationFollowEventTableViewCell
            //cell.configure(with: model)
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

// MARK: - Response to LikeEvent
extension NotificationViewController: NotificationLikeEventTableViewCellDelegate {
    
    func didTapRelatedPostButton(model: Notification) {
        switch model.type {
        case .like(let post):
            let viewController = PostViewController(model: post)
            viewController.title = post.postType.rawValue
            viewController.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(viewController, animated: true)
        default:
            fatalError("Error: follow notification should not happen in like event")
        }
    }
}

// MARK: - Response to FollowEvent
extension NotificationViewController: NotificationFollowEventTableViewCellDelegate {
    
    func didTapFollowUnFollowButton(model: Notification) {
        showAlert(title: "You tapped follow button", message: "Not open yet")
    }
}


