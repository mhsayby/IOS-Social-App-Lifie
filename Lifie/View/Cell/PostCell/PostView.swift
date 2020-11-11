//
//  PostView.swift
//  Lifie
//
//  Created by HAISONG MEI on 11/10/20.
//  Copyright © 2020 HAISONG MEI. All rights reserved.
//

import UIKit

protocol PostViewDelegate: AnyObject {
    func didTapHeaderActionButton()
}

class PostView: UIView {
    
    private let model: UserPost?
    
    private var renderModels = [PostViewModel]()
    
    weak var delegate: PostViewDelegate?

    private let tableView: UITableView! = {
        let tableView = UITableView()
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        tableView.register(PostHeaderTableViewCell.self, forCellReuseIdentifier: PostHeaderTableViewCell.identifier)
        tableView.register(PostActionsTableViewCell.self, forCellReuseIdentifier: PostActionsTableViewCell.identifier)
        tableView.register(PostCommentsTableViewCell.self, forCellReuseIdentifier: PostCommentsTableViewCell.identifier)
        return tableView
    }()
    
    init(model: UserPost, frame: CGRect) {
        self.model = model
        super.init(frame: frame)
        configurePostViewModels()
        backgroundColor = .systemBackground
        addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = frame.insetBy(dx: 10, dy: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func configureXib() {
//        let viewFromXib = Bundle.main.loadNibNamed("PostView", owner: self, options: nil)![0] as! UIView
//        viewFromXib.frame = self.frame
//        addSubview(viewFromXib)
//    }
    
    private func configurePostViewModels() {
        guard let userPostModel = self.model else {
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

extension PostView: UITableViewDelegate, UITableViewDataSource {
    
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
        let post = renderModels[indexPath.section]
        switch post.renderType {
        case .header(let user):
            let cell = tableView.dequeueReusableCell(withIdentifier: PostHeaderTableViewCell.identifier, for: indexPath) as! PostHeaderTableViewCell
            cell.configure(with: user)
            cell.delegate = self
            return cell
        case .body(let body):
            let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
            if let post = model {
                cell.configure(with: post)
            }
            return cell
        case .actions(let actions):
            let cell = tableView.dequeueReusableCell(withIdentifier: PostActionsTableViewCell.identifier, for: indexPath) as! PostActionsTableViewCell
            cell.delegate = self
            return cell
        case .comments(let comments):
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
        case .header(_): return 50
        case .body(_): return width
        case .actions(_): return 60
        case .comments(_): return 50
        }
    }
}

extension PostView: PostHeaderTableViewCellDelegate {
    
    func didTapActionButton() {
        delegate?.didTapHeaderActionButton()
    }
    
    func reportPost() {
        
    }
}

extension PostView: PostActionsTableViewCellDelegate {
    
    func didTapLikeButton() {
        //
    }
    
    func didTapCommentButton() {
        //
    }
    
    func didTapSendButton() {
        //
    }
    
    
}
