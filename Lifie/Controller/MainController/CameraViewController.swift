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

/// CameraViewController: enable users to post, support photo now but haven't implemented video
class CameraViewController: UIViewController {
    
    // MARK: - private fields
    
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
    
    var currentUser: User?
    
    // MARK: - life cycle
    
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
        setCurrentUser()
        navigationItem.title = "New Post"
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
    
    // MARK: - initialization
    
    func configureTapGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapElseWhere))
        view.addGestureRecognizer(tap)
    }
    
    // MARK: - actions
    
    //This method is called when tapping outside of UITextFields to close keyboard
    @objc func didTapElseWhere() {
        dismissKeyboard()
    }
    
    @objc func didTapImagePickButton() {
        let actionSheet = UIAlertController(title: "Post Actions",
                                            message: "Choose a picture",
                                            preferredStyle: .actionSheet)
//        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { (_) in
//            
//        }))
        actionSheet.addAction(UIAlertAction(title: "Choose From Library", style: .default, handler: { (_) in
            self.presentImageViewController()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        actionSheet.popoverPresentationController?.sourceView = view
        actionSheet.popoverPresentationController?.sourceRect = view.bounds
        
        present(actionSheet, animated: true)
    }
    
    @objc func didTapShareButton() {
        dismissKeyboard()
        guard let profileImg = selectedImage, let imageData = profileImg.jpegData(compressionQuality: 0.1) else {
            return
        }
        let photoIdString = NSUUID().uuidString
        StorageManager.shared.uploadImage(imageData: imageData, to: "/posts/\(photoIdString)") { (success, url) in
            // if post image is added to storage successfully
            guard success, let url = url, let user = self.currentUser else {
                return
            }
            let post = UserPost(identifier: "", owner: user, postType: .photo, thumbImage: URL(string: "https://www.google.com")!, postUrl: url, caption: self.textField.text, createDate: Date())
            DatabaseManager.shared.sendDataToDatabase(model: post) { completion in
                if completion {
                    // if post is added to database successfully
                    self.clearInputs()
                    self.tabBarController?.selectedIndex = 0
                }
            }
        }
    }
    
    // MARK: - helper functions
    
    func setCurrentUser() {
        currentUser = DatabaseManager.shared.getCurrrentUserFromDefaults()
    }
    
    // enable shareButton only if users have selected image
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
    
    func clearInputs() {
        self.textField.text = ""
        self.imagePickButton.setImage(UIImage(systemName: "camera", withConfiguration: Constants.buttonConfig), for: .normal)
        self.selectedImage = nil
        postCheck()
    }
}

// MARK: - TextField input
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

// MARK: - ImagePicker for user to choose image from library, haven't implemented taking photos
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
