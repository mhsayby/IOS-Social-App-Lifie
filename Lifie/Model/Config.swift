//
//  Config.swift
//  InstagramClone
//
//  Created by The Zero2Launch Team on 12/17/16.
//  Copyright © 2016 The Zero2Launch Team. All rights reserved.
//

import Foundation
import FirebaseAuth

struct Config {
    static let STORAGE_ROOF_REF = "gs://lifie-b986c.appspot.com"
}

var currentUser: User?

//func setCurrentUser() {
//    guard let email = Auth.auth().currentUser?.email else {
//        return
//    }
//    if email == "testUserA@duke.edu" {
//        setTestUserA()
//    }
//    else {
//        setTestUserB()
//    }
//}
//
//func setTestUserA() {
//    if let data = UIImage(named: "TestUserAProfile")?.jpegData(compressionQuality: 0.1) {
//        let photoIdString = NSUUID().uuidString
//        StorageManager.shared.uploadImage(imageData: data, to: "/posts/\(photoIdString)") { (success, url) in
//            if success, let url = url {
//                let userA = User(username: TestUserA.username, firstName: TestUserA.username, lastName: "Willams", bio: "", birthDate: Date(), gender: .female, counts: UserCount(followers: 0, following: 0, posts: 0), joinDate: Date(), profilePhoto: url)
//                currentUser = userA
//            }
//        }
//    }
//}
//
//func setTestUserB() {
//    if let data = UIImage(named: "TestUserBProfile")?.jpegData(compressionQuality: 0.1) {
//        let photoIdString = NSUUID().uuidString
//        StorageManager.shared.uploadImage(imageData: data, to: "/posts/\(photoIdString)") { (success, url) in
//            if success, let url = url {
//                let userB = User(username: TestUserB.username, firstName: TestUserB.username, lastName: "Smith", bio: "", birthDate: Date(), gender: .male, counts: UserCount(followers: 0, following: 0, posts: 0), joinDate: Date(), profilePhoto: url)
//                currentUser = userB
//            }
//        }
//    }
//}
