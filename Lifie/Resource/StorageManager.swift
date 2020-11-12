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
    
    private let ref = Storage.storage().reference()
    
    public enum StorageManagerError: Error {
        case failToDownloadImage
        case failToStoreImage
    }
    
    // MARK: Public functions
    
    public func uploadPhotoPost(model: UserPost, completion: @escaping (Result<URL, Error>) -> Void)  {
        
    }
    
    public func uploadImage(imageData: Data, to path: String, completion: @escaping (Bool, URL?) -> Void) {
        let storageRef = ref.child(path)
        storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
            if let error = error {
                presentAlert(title: "Error", message: error.localizedDescription)
                completion(false, nil)
                return
            }
            storageRef.downloadURL { url, error in
                guard let url = url, error == nil else {
                    completion(false, nil)
                    return
                }
                completion(true, url)
                return
            }
        })
    }
    
    public func downloadImage(with reference: String, completion: @escaping (Result<URL, StorageManagerError>) -> Void) {
        ref.child(reference).downloadURL { (url, error) in
            guard let url = url, error == nil else {
                completion(.failure(.failToDownloadImage))
                return
            }
            completion(.success(url))
        }
    }
}
