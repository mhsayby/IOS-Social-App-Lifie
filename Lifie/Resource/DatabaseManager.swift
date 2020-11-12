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
            print(dic)
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
        database.child("posts").observe(.childAdded) { snapshot in
            print(snapshot.value!)
            do {
                guard let dic = snapshot.value as? [String: Any] else {
                    return
                }
                let dicData = try JSONSerialization.data(withJSONObject: dic)
                let post = try JSONDecoder().decode(UserPost.self, from: dicData)
                completion(true, post)
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
            } catch {
                presentAlert(title: "Error", message: error.localizedDescription)
                completion(false, nil)
                return
            }
        }
    }
    
    // MARK: Private functions
}
