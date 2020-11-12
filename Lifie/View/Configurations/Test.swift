//
//  Font.swift
//  Lifie
//
//  Created by HAISONG MEI on 11/11/20.
//  Copyright © 2020 HAISONG MEI. All rights reserved.
//

import Foundation

let testUser = User(username: "@Thrump", firstName: "Donald", lastName: "Trump", bio: "", birthDate: Date(), gender: .male, counts: UserCount(followers: 0, following: 0, posts: 0), joinDate: Date(), profilePhoto: URL(string: "https://www.google.com")!)
let testPost = UserPost(identifier: "", owner: testUser, postType: .photo, thumbImage: URL(string: "https://www.google.com")!, postUrl: URL(string: "https://www.google.com")!, caption: nil, createDate: Date())
//let testPost = UserPost(identifier: "", owner: testUser, postType: .photo, thumbImage: URL(string: "https://www.google.com")!, postUrl: URL(string: "https://www.google.com")!, caption: nil, likes: [], comments: [], createDate: Date(), taggedUsers: [])
