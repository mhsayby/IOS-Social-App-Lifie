//
//  StorageManager.swift
//  Lifie
//
//  Created by HAISONG MEI on 10/19/20.
//  Copyright © 2020 HAISONG MEI. All rights reserved.
//

import FirebaseStorage

public class StorageManager {
    
    static let shared  = StorageManager()
    
    private let bucket = Storage.storage().reference()
    
    // MARK: Public functions
    
    public func uploadPhotoPost(model: PhotoPost, completion: (Result<URL, Error>) -> Void)  {
        
    }
    
    public func downloadImage(with reference: String, completion: (Result<URL, Error>) -> Void) {
        
    }
}

public enum UserPostType {
    case photo, video
}

public struct PhotoPost {
    let postType: UserPostType
}
