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
        case failToDownload
    }
    
    // MARK: Public functions
    
    public func downloadImage(with reference: String, completion: @escaping (Result<URL, StorageManagerError>) -> Void) {
        ref.child(reference).downloadURL { (url, error) in
            guard let url = url, error == nil else {
                completion(.failure(.failToDownload))
                return
            }
            completion(.success(url))
        }
    }
}
