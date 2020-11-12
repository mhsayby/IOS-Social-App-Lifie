//
//  PostViewController.swift
//  Lifie
//
//  Created by HAISONG MEI on 10/15/20.
//  Copyright © 2020 HAISONG MEI. All rights reserved.
//

import UIKit

enum PostRenderType {
    case header(provider: User)
    case body(provider: UserPost)
    case actions(provider: String) //like or not, comment, share
    case comments(comments: [PostComment])
}

struct PostViewModel {
    let renderType: PostRenderType
}

class PostViewController: UIViewController {
    
    private let post: UserPost?
    
    private var renderModels = [PostViewModel]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        tableView.register(PostHeaderTableViewCell.self, forCellReuseIdentifier: PostHeaderTableViewCell.identifier)
        tableView.register(PostActionsTableViewCell.self, forCellReuseIdentifier: PostActionsTableViewCell.identifier)
        tableView.register(PostCommentsTableViewCell.self, forCellReuseIdentifier: PostCommentsTableViewCell.identifier)
        return tableView
    }()
    
    init(model: UserPost) {
        self.post = model
        super.init(nibName: nil, bundle: nil)
        configurePostViewModels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configurePostViewModels() {
        guard let userPostModel = self.post else {
            return
        }
        // header
        renderModels.append(PostViewModel(renderType: .header(provider: userPostModel.owner)))
        // body
        renderModels.append(PostViewModel(renderType: .body(provider: userPostModel)))
        // actions
        renderModels.append(PostViewModel(renderType: .actions(provider: "")))
        // comments
        var comments = [PostComment]()
        for x in 0...5 {
            comments.append(PostComment(identifier: "id_\(x)", username: "@Trump", text: "Post is here", createDate: Date(), likes: []))
        }
        renderModels.append(PostViewModel(renderType: .comments(comments: comments)))
    }
}

extension PostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return renderModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch renderModels[section].renderType {
        case .header(_),
             .body(_),
             .actions(_):
            return 1
        case .comments(let comments):
            return comments.count > 4 ? 4 : comments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = renderModels[indexPath.section]
        switch model.renderType {
        case .header(_):
            let cell = tableView.dequeueReusableCell(withIdentifier: PostHeaderTableViewCell.identifier, for: indexPath) as! PostHeaderTableViewCell
            if let post = post {
                cell.configure(with: post.owner)
            }
            return cell
        case .body(_):
            let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
            if let post = post {
                cell.configure(with: post)
            }
            return cell
        case .actions(_):
            let cell = tableView.dequeueReusableCell(withIdentifier: PostActionsTableViewCell.identifier, for: indexPath) as! PostActionsTableViewCell
            return cell
        case .comments(_):
            let cell = tableView.dequeueReusableCell(withIdentifier: PostCommentsTableViewCell.identifier, for: indexPath) as! PostCommentsTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = renderModels[indexPath.section]
        switch model.renderType {
        case .header(_): return 70
        case .body(_): return view.width
        case .actions(_): return 60
        case .comments(_): return 50
        }
    }
}
