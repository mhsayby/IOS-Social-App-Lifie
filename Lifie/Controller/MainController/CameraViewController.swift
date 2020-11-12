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
    }
    
    private let imagePickButton: UIButton = {
        let button = UIButton()
        let buttonConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .regular)
        button.setImage(UIImage(systemName: "camera", withConfiguration: buttonConfig), for: .normal)
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
    
    func configureTapGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapElseWhere))
        view.addGestureRecognizer(tap)
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
        if let profileImg = imagePickButton.currentImage, let imageData = profileImg.jpegData(compressionQuality: 0.1) {
            let photoIdString = NSUUID().uuidString
            print(photoIdString)
            let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("posts").child(photoIdString)
            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                if let error = error {
                    presentAlert(title: "Error", message: error.localizedDescription)
                    return
                }
                storageRef.downloadURL { url, error in
                    if let error = error {
                        presentAlert(title: "Error", message: error.localizedDescription)
                        return
                    }
                    if let url = url {
                        let post = UserPost(identifier: "", owner: testUser, postType: .photo, thumbImage: URL(string: "https://www.google.com")!, postUrl: url, caption: self.textField.text, createDate: Date())
                        DatabaseManager.shared.sendDataToDatabase(model: post)
                    }
                }
            })
        } else {
//            ProgressHUD.showError("Profile Image can't be empty")
        }
    }
    
    //This method is called when tapping outside of UITextFields to close keyboard
    @objc func didTapElseWhere() {
        view.endEditing(true)
    }
}

extension CameraViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        textField.textColor = .label
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
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
        } else if let initImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickButton.setImage(initImage, for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
}
