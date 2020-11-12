//
//  AlertManager.swift
//  Lifie
//
//  Created by HAISONG MEI on 11/12/20.
//  Copyright © 2020 HAISONG MEI. All rights reserved.
//

import UIKit

func presentAlert(title: String, message: String){
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
    alert.presentInOwnWindow(animated: true) {
        print("Present Alert")
    }
}

func showErrorMessage(_ message: String) {
    let alertWindow = UIWindow(frame: UIScreen.main.bounds)
    alertWindow.rootViewController = UIViewController()

    let alertController = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: { _ in
        alertWindow.isHidden = true
    }))
    
    alertWindow.windowLevel = UIWindow.Level.alert + 1;
    alertWindow.makeKeyAndVisible()
    alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
}


