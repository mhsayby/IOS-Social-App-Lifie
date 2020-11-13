//
//  DatabaseManager.swift
//  Lifie
//
//  Created by HAISONG MEI on 10/19/20.
//  Copyright © 2020 HAISONG MEI. All rights reserved.
//

import FirebaseDatabase

public class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    // MARK: Public functions
    
    /// Check if can register
    func canRegister(username: String, email: String, completion: (Bool) -> Void) {
        completion(true)
    }
    
    /// Check if username and password are existing
    func addUser(username: String, email: String, completion: @escaping (Bool) -> Void) {
        database.child(email.safeDatabaseKey()).setValue(["username": username]) { error, _ in
            if error == nil {
                completion(true)
                return
            }
            else {
                completion(false)
                return
            }
        }
    }
    
    func updateUser(email: String, model: User, completion: @escaping (Bool) -> Void) {
        do {
            let jsonData = try JSONEncoder().encode(model)
            let dic = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] ?? [:]
            database.child(email.safeDatabaseKey()).setValue(dic) { error, ref in
                if let error = error {
                    presentAlert(title: "Error", message: error.localizedDescription)
                    completion(false)
                    return
                }
                presentAlert(title: "Success", message: "Successfully update user")
                completion(true)
                return
            }
        } catch {
            presentAlert(title: "Error", message: error.localizedDescription)
            completion(false)
            return
        }
    }
    
    func setCurrentUserDefaults(model: User) {
        do {
            let jsonData = try JSONEncoder().encode(model)
            let dic = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] ?? [:]
            UserDefaults.standard.set(dic, forKey: "CurrentUser")
        } catch {
            print(error)
            return
        }
    }
    
    func getCurrrentUserFromDefaults() -> User? {
        do {
            guard let dic = UserDefaults.standard.dictionary(forKey: "CurrentUser") else {
                return nil
            }
            let dicData = try JSONSerialization.data(withJSONObject: dic)
            let user = try JSONDecoder().decode(User.self, from: dicData)
            return user
        } catch {
            print(error)
            return nil
        }
    }
    
    func sendDataToDatabase(model: UserPost, completion: @escaping ((Bool) -> Void)) {
        let postsReference = database.child("posts")
        let newPostId = database.child("posts").childByAutoId().key
        let newPostReference = postsReference.child(newPostId!)
        
        do {
            let jsonData = try JSONEncoder().encode(model)
            let dic = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] ?? [:]
            print(dic)
            newPostReference.setValue(dic) { error, ref in
                if let error = error {
                    presentAlert(title: "Error", message: error.localizedDescription)
                    completion(false)
                    return
                }
                presentAlert(title: "Success", message: "Successfully upload post")
                //showErrorMessage("Success")
                completion(true)
                return
            }
        } catch {
            presentAlert(title: "Error", message: error.localizedDescription)
            completion(false)
            return
        }
    }
    
    func downLoadPhotoPost(completion: @escaping ((Bool, UserPost?) -> Void)) {
        database.child("posts").queryOrdered(byChild: "createDate").observe(.childAdded) { snapshot in
            print(snapshot.value!)
            do {
                guard let dic = snapshot.value as? [String: Any] else {
                    return
                }
                let dicData = try JSONSerialization.data(withJSONObject: dic)
                let post = try JSONDecoder().decode(UserPost.self, from: dicData)
                completion(true, post)
                return
            } catch {
                presentAlert(title: "Error", message: error.localizedDescription)
                completion(false, nil)
                return
            }
        }
    }
    
    func downLoadPhotoPostByUser(user: User, completion: @escaping ((Bool, UserPost?) -> Void)) {
        database.child("posts").queryOrdered(byChild: "owner/username").queryEqual(toValue: user.username).observe(.childAdded) { snapshot in
            print(snapshot.value!)
            do {
                guard let dic = snapshot.value as? [String: Any] else {
                    return
                }
                let dicData = try JSONSerialization.data(withJSONObject: dic)
                let post = try JSONDecoder().decode(UserPost.self, from: dicData)
                completion(true, post)
                return
            } catch {
                presentAlert(title: "Error", message: error.localizedDescription)
                completion(false, nil)
                return
            }
        }
    }
    
    func getUserByEmail(with email: String, completion: @escaping ((Bool, User?) -> Void)) {
        database.child(email.safeDatabaseKey()).observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot.value!)
            do {
                guard let dic = snapshot.value as? [String: Any] else {
                    return
                }
                let dicData = try JSONSerialization.data(withJSONObject: dic)
                let user = try JSONDecoder().decode(User.self, from: dicData)
                completion(true, user)
                return
            } catch {
                presentAlert(title: "Error", message: error.localizedDescription)
                completion(false, nil)
                return
            }
        }
    }
    
    // MARK: Private functions
}
