//
//  ExploreViewController.swift
//  Lifie
//
//  Created by HAISONG MEI on 10/15/20.
//  Copyright © 2020 HAISONG MEI. All rights reserved.
//

import UIKit

/// ExploreViewController: present all posts in another way so that users may search for their interests, haven't implemented yet
class ExploreViewController: UIViewController {
    
    // MARK: - private fields

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundColor = .secondarySystemBackground
        searchBar.placeholder = "Search"
        return searchBar
    }()
    
    // UIView to mask the screen when users entering inputs
    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.isHidden = true
        view.alpha = 0
        return view
    }()
    
    private var collectionView: UICollectionView?
    
    private var tabbedSearchCollectionView: UICollectionView?
    
    private var posts = [UserPost]()
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureCollectionView()
        configureSearchBar()
        configureDimmedView()
        reloadPosts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.frame
        dimmedView.frame = view.frame
        tabbedSearchCollectionView?.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: 72)
    }
    
    // MARK: - initialization
    
    private func configureSearchBar() {
        navigationController?.navigationBar.topItem?.titleView = searchBar
        searchBar.delegate = self
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let itemSize = (view.width-4)/3
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = .systemBackground
        guard let collectionView = collectionView else {
            return
        }
        view.addSubview(collectionView)
    }
    
    private func configureDimmedView() {
        view.addSubview(dimmedView)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didCancelSearch))
        gesture.numberOfTouchesRequired = 1
        gesture.numberOfTapsRequired = 1
        dimmedView.addGestureRecognizer(gesture)
    }
    
    private func configureTabbedSearch() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.width/3, height: 52)
        layout.scrollDirection = .horizontal
        tabbedSearchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        tabbedSearchCollectionView?.isHidden = false
        tabbedSearchCollectionView?.backgroundColor = .blue
        guard let tabbedSearchCollectionView = tabbedSearchCollectionView else {
            return
        }
        tabbedSearchCollectionView.delegate = self
        tabbedSearchCollectionView.dataSource = self
        view.addSubview(tabbedSearchCollectionView)
    }
    
    private func reloadPosts() {
        posts.removeAll(keepingCapacity: false)
        DatabaseManager.shared.downLoadPhotoPost { success, post in
            if success, let post = post {
                self.posts.append(post)
            }
            else {
                
            }
            self.collectionView?.reloadData()
        }
    }
}

// MARK: - CollectionView to show posts
extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tabbedSearchCollectionView {
            return 0
        }
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tabbedSearchCollectionView {
            return UICollectionViewCell()
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        cell.configure(with: posts[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if collectionView == tabbedSearchCollectionView {
            return
        }
        
        let post = posts[indexPath.row]
        let viewController = PostViewController(model: post)
        viewController.title = testPost.postType.rawValue
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - SearchBar
extension ExploreViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        didCancelSearch()
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        query(with: text)
    }
    
    private func query(with text: String) {
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didCancelSearch))
        dimmedView.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.dimmedView.alpha = 0.4
        }) { completion in
            if completion {
                self.tabbedSearchCollectionView?.isHidden = false
            }
        }
    }
    
    @objc func didCancelSearch() {
        searchBar.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
        self.tabbedSearchCollectionView?.isHidden = true
        UIView.animate(withDuration: 0.2, animations: {
            self.dimmedView.alpha = 0
        }) { completion in
            if completion {
                self.dimmedView.isHidden = true
            }
        }
    }
}
