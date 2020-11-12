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
    public func canRegister(username: String, email: String, completion: (Bool) -> Void) {
        completion(true)
    }
    
    /// Check if username and password are existing
    public func addUser(username: String, email: String, completion: @escaping (Bool) -> Void) {
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
    
    public func uploadPhotoPost(model: UserPost, completion: (Bool) -> Void) {
        do {
            let jsonData = try JSONEncoder().encode(model)
            let dic = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] ?? [:]
            print(dic)
            database.child("post").setValue(dic)
        } catch {
            print(error)
        }
    }
    
    
    public func downLoadPhotoPost() -> [UserPost] {
        var res = [UserPost]()
        database.child("post").observe(.value) { snapshot in
            do {
                guard let dic = snapshot.value as? [String: Any] else {
                    return
                }
                let dicData = try JSONSerialization.data(withJSONObject: dic)
                let post = try JSONDecoder().decode(UserPost.self, from: dicData)
                res.append(post)
            } catch {
                print(error)
            }
        }
        return res
    }
    
    // MARK: Private functions
}
