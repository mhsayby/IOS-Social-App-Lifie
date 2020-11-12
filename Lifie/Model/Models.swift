//
//  Models.swift
//  Lifie
//
//  Created by HAISONG MEI on 11/2/20.
//  Copyright © 2020 HAISONG MEI. All rights reserved.
//

enum UserPostType: String, Codable {
    case photo = "Photo"
    case video = "Video"
}

enum Gender: String, Codable {
    case male = "Male"
    case female = "Female"
    case other = "Other"
}

/// User post model
public struct UserPost: Codable {
    let identifier: String
    let owner: User
    let postType: UserPostType
    let thumbImage: URL
    let postUrl: URL //video or photo with high resolution
    let caption: String?
//    let likes: [PostLike]
//    let comments: [PostComment]
    let createDate: Date
//    let taggedUsers: [String]
}

struct User: Codable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String
    let birthDate: Date
    let gender: Gender
    let counts: UserCount
    let joinDate: Date
    let profilePhoto: URL
}

struct UserCount: Codable {
    let followers: Int
    let following: Int
    let posts: Int
}

struct PostLike: Codable {
    let username: String
    let postIdentifier: String
}

struct CommentLike: Codable {
    let username: String
    let commentIdentifier: String
}

struct PostComment: Codable {
    let identifier: String
    let username: String
    let text: String
    let createDate: Date
    let likes: [CommentLike]
}

