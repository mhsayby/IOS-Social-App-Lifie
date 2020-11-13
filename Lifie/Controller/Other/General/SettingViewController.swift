//
//  SettingViewController.swift
//  Lifie
//
//  Created by HAISONG MEI on 10/15/20.
//  Copyright © 2020 HAISONG MEI. All rights reserved.
//

import UIKit
import FirebaseAuth

/// SettingCellModel used to show cells in setting page
struct SettingCellModel {
    let title: String
    let handler: (() -> Void)
}

/// SettingViewController shows one post in a single view controller
class SettingViewController: UIViewController {
    
    //MARK: - private fields
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    private var data = [[SettingCellModel]]()
    
    //MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    //MARK: - configurations
    
    private func configureModels() {
        data.append([
            SettingCellModel(title: "Edit Profile") { [weak self] in
                self?.didTapEditProfile()
            }
        ])
        data.append([
            SettingCellModel(title: "Logout") { [weak self] in
                self?.didTapLogout()
            }
        ])
    }
    
    //MARK: - actions
    
    private func didTapEditProfile(){
        let viewController = EditProfileViewController()
        viewController.title = "Edit Profile"
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func didTapLogout(){
        AuthenticationManager.shared.logout(completion: { success in
            DispatchQueue.main.async{
                if success {
                    //redirect to login page
                    currentUser = nil
                    let loginViewController = LoginViewController()
                    loginViewController.modalPresentationStyle = .fullScreen
                    self.present(loginViewController, animated: true) {
                        self.navigationController?.popToRootViewController(animated: false)
                        self.tabBarController?.selectedIndex = 0
                    }
                }
                else {
                    
                }
            }
        })
    }
}

//MARK: - UITableView to show setting cells
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        data[indexPath.section][indexPath.row].handler();
    }
}
