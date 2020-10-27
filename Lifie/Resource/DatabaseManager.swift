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
    
    // MARK: Private functions
}
