//
//  CameraViewController.swift
//  Lifie
//
//  Created by HAISONG MEI on 10/15/20.
//  Copyright © 2020 HAISONG MEI. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class CameraViewController: UIViewController {
    
    struct Constants {
        static let cornerRadius: CGFloat = 10.0
        static let textFont = UIFont(name: "AppleSDGothicNeo-Medium", size: 20)
        static let buttonConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .regular)
    }
    
    private let imagePickButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "camera", withConfiguration: Constants.buttonConfig), for: .normal)
        button.layer.cornerRadius = 0.2
        button.layer.cornerRadius = Constants.cornerRadius
        button.layer.masksToBounds = true
        button.backgroundColor = .lightGray
        button.tintColor = .white
        return button
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .secondarySystemBackground
        textField.text = "Record your Lifie"
        textField.font = Constants.textFont
        textField.layer.cornerRadius = Constants.cornerRadius
        textField.textColor = .systemGray
        return textField
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setTitle("Share", for: .normal)
        button.layer.cornerRadius = Constants.cornerRadius
        button.layer.masksToBounds = true
        button.backgroundColor = .lightGray
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    var selectedImage: UIImage?
    
    // MARK: - View life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        postCheck()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setToolbarHidden(true, animated: false)
        view.addSubview(imagePickButton)
        view.addSubview(textField)
        view.addSubview(shareButton)
        imagePickButton.addTarget(self, action: #selector(didTapImagePickButton), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        textField.delegate = self
        configureTapGesture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size = (view.width - 30) / 3
        let top = CGFloat(100)
        let space = CGFloat(10)
        imagePickButton.frame = CGRect(x: space, y: top, width: size, height: size)
        textField.frame = CGRect(x: imagePickButton.right+space, y: top, width: size * 2, height: size)
        shareButton.frame = CGRect(x: space, y: textField.bottom + space, width: view.width - 2*space, height: size/2)
    }
    
    func postCheck() {
        if selectedImage != nil {
            shareButton.isEnabled = true
            shareButton.backgroundColor = .black
        }
        else {
            shareButton.isEnabled = false
            shareButton.backgroundColor = .systemGray
        }
    }
    
    func configureTapGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapElseWhere))
        view.addGestureRecognizer(tap)
    }
    
    //This method is called when tapping outside of UITextFields to close keyboard
    @objc func didTapElseWhere() {
        dismissKeyboard()
    }
    
    @objc func didTapImagePickButton() {
        let actionSheet = UIAlertController(title: "Post Actions", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Choose from library", style: .default, handler: { _ in
            self.presentImageViewController()
        }))
        actionSheet.addAction(UIAlertAction(title: "Take a photo", style: .default, handler: { _ in
            //
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
    
    @objc func didTapShareButton() {
//        let post = UserPost(identifier: "", owner: testUser, postType: .photo, thumbImage: URL(string: "https://www.google.com")!, postUrl: URL(string: "https://www.google.com")!, caption: nil, createDate: Date())
//        DatabaseManager.shared.uploadPhotoPost(model: testPost) { _ in
        dismissKeyboard()
        if let profileImg = selectedImage, let imageData = profileImg.jpegData(compressionQuality: 0.1) {
            let photoIdString = NSUUID().uuidString
            StorageManager.shared.uploadImage(imageData: imageData, to: "\(Config.STORAGE_ROOF_REF)/posts/\(photoIdString)") { (success, url) in
                if success, let url = url {
                    let post = UserPost(identifier: "", owner: testUser, postType: .photo, thumbImage: URL(string: "https://www.google.com")!, postUrl: url, caption: self.textField.text, createDate: Date())
                    DatabaseManager.shared.sendDataToDatabase(model: post) { completion in
                        if completion {
                            // if post is stored successfully
                            self.clearInputs()
                            self.tabBarController?.selectedIndex = 0
                        }
                    }
                }
            }
//            let photoIdString = NSUUID().uuidString
//            print(photoIdString)
//            let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("posts").child(photoIdString)
//            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
//                if let error = error {
//                    presentAlert(title: "Error", message: error.localizedDescription)
//                    return
//                }
//                storageRef.downloadURL { url, error in
//                    if let error = error {
//                        presentAlert(title: "Error", message: error.localizedDescription)
//                        return
//                    }
//                    if let url = url {
//                        let post = UserPost(identifier: "", owner: testUser, postType: .photo, thumbImage: URL(string: "https://www.google.com")!, postUrl: url, caption: self.textField.text, createDate: Date())
//                        DatabaseManager.shared.sendDataToDatabase(model: post) { completion in
//                            if completion {
//                                // if post is stored successfully
//                                self.clearInputs()
//                                self.tabBarController?.selectedIndex = 0
//                            }
//                        }
//                    }
//                }
//            })
        } else {
//            ProgressHUD.showError("Profile Image can't be empty")
        }
    }
    
    func clearInputs() {
        self.textField.text = ""
        self.imagePickButton.setImage(UIImage(systemName: "camera", withConfiguration: Constants.buttonConfig), for: .normal)
        self.selectedImage = nil
        postCheck()
    }
}

extension CameraViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        textField.textColor = .label
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
    
    func dismissKeyboard() {
        textField.resignFirstResponder()
        self.view.endEditing(true)
    }
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentImageViewController(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imagePickButton.setImage(editedImage, for: .normal)
            selectedImage = editedImage
        } else if let initImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickButton.setImage(initImage, for: .normal)
            selectedImage = initImage
        }
        dismiss(animated: true, completion: nil)
        postCheck()
    }
}
