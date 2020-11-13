//
//  ProfileViewController.swift
//  Lifie
//
//  Created by HAISONG MEI on 10/15/20.
//  Copyright © 2020 HAISONG MEI. All rights reserved.
//

import UIKit
import FirebaseAuth

/// ProfileViewController: show current user's profile and posts
class ProfileViewController: UIViewController {
    
    // MARK: - private fields
    
    private var collectionView: UICollectionView?
    
    private var posts = [UserPost]()
    
    private var currentUser: User?
    
    // MARK: - life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setCurrentUser()
        reloadPosts()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Profile"
        configureNavigationBar()
        configureCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    // MARK: - initialization

    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .done,
            target: self,
            action: #selector(didTapSettingsButton)
        )
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
        let size = (view.width - 4) / 3
        layout.itemSize = CGSize(width: size, height: size)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(PhotoCollectionViewCell.self,
                                 forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView?.register(ProfileInfoHeaderCollectionReusableView.self,
                                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                 withReuseIdentifier: ProfileInfoHeaderCollectionReusableView.identifier)
        collectionView?.register(ProfileTabCollectionReusableView.self,
                                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                 withReuseIdentifier: ProfileTabCollectionReusableView.identifier)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = .secondarySystemBackground
        guard let collectionView = collectionView else {
            return
        }
        view.addSubview(collectionView)
    }
    
    // MARK: - actions
    
    @objc func didTapSettingsButton() {
        let vc = SettingViewController()
        vc.title = "Settings"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - helper functions
    
    private func reloadPosts() {
        posts.removeAll(keepingCapacity: false)
        guard let currentUser = currentUser else {
            return
        }
        DatabaseManager.shared.downLoadPhotoPostByUser(user: currentUser) { success, post in
            if success, let post = post {
                self.posts.append(post)
            }
            else {
                
            }
            self.collectionView?.reloadData()
        }
    }
    
    func setCurrentUser() {
        currentUser = DatabaseManager.shared.getCurrrentUserFromDefaults()
    }
}

// MARK: - UICollectionView to show profile. It has 2 sections, one is for profile data, the other is for posts
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // seperate profile data and posts by sections
        if section == 0 {
            return 0
        }
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        cell.configure(with: posts[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let post = posts[indexPath.row]
        let viewController = PostViewController(model: post)
        viewController.title = post.postType.rawValue
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        // seperate profile data and posts by sections
        if indexPath.section == 1 {
            let tabHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ProfileTabCollectionReusableView.identifier,
                for: indexPath) as! ProfileTabCollectionReusableView
            tabHeader.delegate = self
            return tabHeader
        }
        let profileHeader = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: ProfileInfoHeaderCollectionReusableView.identifier,
            for: indexPath)
            as! ProfileInfoHeaderCollectionReusableView
        if let currentUser = currentUser {
            profileHeader.configure(with: currentUser)
        }
        profileHeader.delegate = self
        return profileHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // seperate profile data and posts by sections
        if section == 0 {
            return CGSize(width: collectionView.width, height: collectionView.height/3)
        }
        return CGSize(width: collectionView.width, height: 50)
    }
}

// MARK: - ProfileInfoHeaderCollectionReusableView to show profile data
extension ProfileViewController: ProfileInfoHeaderCollectionReusableViewDelegate {
    
    func profileHeaderDidTapPostsButton(_ header: ProfileInfoHeaderCollectionReusableView) {
        collectionView?.scrollToItem(at: IndexPath(row: 0, section: 1), at: .top, animated: true)
    }
    
    func profileHeaderDidTapFollowersButton(_ header: ProfileInfoHeaderCollectionReusableView) {
        var mockData = [UserRelationShip]()
        for x in 0..<1 {
            mockData.append(UserRelationShip(username: "@Trump\(x)", name: "Trump", followState: x % 2 == 0 ? .following : .unfollowing))
        }
        let viewController = ListViewController(data: mockData)
        viewController.title = "Followers"
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func profileHeaderDidTapFollowingButton(_ header: ProfileInfoHeaderCollectionReusableView) {
        var mockData = [UserRelationShip]()
        for x in 0..<1 {
            mockData.append(UserRelationShip(username: "@Trump\(x)", name: "Trump", followState: .following))
        }
        let viewController = ListViewController(data: mockData)
        viewController.title = "Following"
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - ProfileTabCollectionReusableView contains buttons to switch present mode
extension ProfileViewController: ProfileTabCollectionReusableViewDelegate {
    
    func didTapTabGridButton() {
        // refresh profileview in one way
    }
    
    func didTapTabTaggedButton() {
        // refresh profileview in another way
    }
    
}
