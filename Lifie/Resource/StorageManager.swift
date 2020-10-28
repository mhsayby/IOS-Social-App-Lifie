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
    
    public enum StorageManagerError: Error {
        case failToDownload
    }
    
    // MARK: Public functions
    
    public func uploadPhotoPost(model: PhotoPost, completion: @escaping (Result<URL, Error>) -> Void)  {
        
    }
    
    public func downloadImage(with reference: String, completion: @escaping (Result<URL, StorageManagerError>) -> Void) {
        bucket.child(reference).downloadURL { (url, error) in
            guard let url = url, error == nil else {
                completion(.failure(.failToDownload))
                return
            }
            completion(.success(url))
        }
    }
}

public enum UserPostType {
    case photo, video
}

public struct PhotoPost {
    let postType: UserPostType
}
