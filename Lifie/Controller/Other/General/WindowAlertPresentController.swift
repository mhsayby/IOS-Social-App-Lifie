//
//  File.swift
//  Lifie
//
//  Created by HAISONG MEI on 11/12/20.
//  Copyright © 2020 HAISONG MEI. All rights reserved.
//

class WindowAlertPresentController: UIViewController {

    // MARK: - Properties

    private lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    private let alert: UIAlertController

    // MARK: - Initialization

    init(alert: UIAlertController) {

        self.alert = alert
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {

        fatalError("This initializer is not supported")
    }

    // MARK: - Presentation

    func present(animated: Bool, completion: (() -> Void)?) {

        window?.rootViewController = self
        window?.windowLevel = UIWindow.Level.alert + 1
        window?.makeKeyAndVisible()
        present(alert, animated: animated, completion: completion)
    }

    // MARK: - Overrides

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {

        super.dismiss(animated: flag) {
            self.window = nil
            completion?()
        }
    }
}
