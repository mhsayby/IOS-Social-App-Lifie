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
    /// - Parameters
    ///     - username
    ///     - email
    public func canRegister(username: String, email: String, completion: (Bool) -> Void) {
        
    }
}
