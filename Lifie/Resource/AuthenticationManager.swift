//
//  AuthenticationManager.swift
//  Lifie
//
//  Created by HAISONG MEI on 10/26/20.
//  Copyright © 2020 HAISONG MEI. All rights reserved.
//

import FirebaseAuth

///AuthenticationManager is singletion class to handle firebase authentication
public class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    
    // MARK: Public functions
    
    public func registerUser(username: String, email: String, password: String, completion: @escaping ((Bool) -> Void)) {
        DatabaseManager.shared.canRegister(username: username, email: email) { (canRegister) in
            if canRegister {
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    //check Firebase auth results
                    guard result != nil, error == nil else {
                        //Firebase auth cannot create user
                        completion(false)
                        return
                    }
                    //add user to database
                    DatabaseManager.shared.addUser(username: username, email: email) { (added) in
                        if added {
                            completion(true)
                            return
                        }
                        else {
                            //cannot add user to database
                            completion(false)
                            return
                        }
                    }
                }
            }
            else {
                // DatabaseManager check fails, username or email unavailable
                completion(false)
            }
        }
    }
    
    public func loginUser(username: String?, email: String?, password: String, completion: @escaping ((Bool) -> Void)) {
        if let email = email {
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                guard result != nil, error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        }
        else if let username = username {
            print(username)
        }
    }
    
    // Logout Firebase user
    public func logout(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
            return
        }
        catch {
            print("[Error] \(error)")
            completion(false)
            return
        }
    }
}
