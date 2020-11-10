//
//  Models.swift
//  Lifie
//
//  Created by HAISONG MEI on 11/2/20.
//  Copyright © 2020 HAISONG MEI. All rights reserved.
//

enum UserPostType {
    case photo, video
}

enum Gender {
    case male, female, other
}

/// User post model
public struct UserPost {
    let identifier: String
    let postType: UserPostType
    let thumbImage: URL
    let postUrl: URL //video or photo with high resolution
    let caption: String?
    let likes: [PostLike]
    let comments: [PostComment]
    let createDate: Date
    let taggedUsers: [String]
}

struct User {
    let username: String
    let name: (first: String, last: String)
    let bio: String
    let birthDate: Date
    let gender: Gender
    let counts: UserCount
    let joinDate: Date
    let profilePhoto: URL
}

struct UserCount {
    let followers: Int
    let following: Int
    let posts: Int
}

struct PostLike {
    let username: String
    let postIdentifier: String
}

struct CommentLike {
    let username: String
    let commentIdentifier: String
}

struct PostComment {
    let identifier: String
    let username: String
    let text: String
    let createDate: Date
    let likes: [CommentLike]
}

