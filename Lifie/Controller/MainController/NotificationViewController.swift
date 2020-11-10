//
//  NotificationViewController.swift
//  Lifie
//
//  Created by HAISONG MEI on 10/15/20.
//  Copyright © 2020 HAISONG MEI. All rights reserved.
//

import UIKit

enum NotificationType {
    case like(post: UserPost)
    case follow(state: FollowState)
}

struct Notification {
    let type: NotificationType
    let text: String
    let user: User
}

class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
    }
    
    private func fetchNotifications() {
        for x in 0...100 {
            let user = User(username: "@Thrump", name: (first: "Donald", last: "Trump"), bio: "", birthDate: Date(), gender: .male, counts: UserCount(followers: 0, following: 0, posts: 0), joinDate: Date(), profilePhoto: URL(string: "https://www.google.com")!)
            let post = UserPost(identifier: "", owner: user, postType: .photo, thumbImage: URL(string: "https://www.google.com")!, postUrl: URL(string: "https://www.google.com")!, caption: nil, likes: [], comments: [], createDate: Date(), taggedUsers: [])
            let model = Notification(type: x%2 == 0 ? .like(post: post) : .follow(state: .following),
                                     text: "Hello",
                                     user: user)
            models.append(model)
        }
    }
    
    private func configureEmptyNotificationView() {
        tableView.isHidden = true
        view.addSubview(emptyNotificationView)
        emptyNotificationView.frame = CGRect(x: 0, y: 0, width: view.width/2, height: view.height/4)
        emptyNotificationView.center = view.center
    }
    
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
        return 50
    }
}

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

extension NotificationViewController: NotificationFollowEventTableViewCellDelegate {
    
    func didTapFollowUnFollowButton(model: Notification) {
        //
    }
}


