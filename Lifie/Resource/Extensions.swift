//
//  Extensions.swift
//  Lifie
//
//  Created by HAISONG MEI on 10/19/20.
//  Copyright © 2020 HAISONG MEI. All rights reserved.
//

import UIKit

//MARK: shorthands for UIViews
extension UIView {

    public var width: CGFloat {
        return frame.size.width
    }
    
    public var height: CGFloat {
        return frame.size.height
    }
    
    public var top: CGFloat {
        return frame.origin.y
    }
    
    public var bottom: CGFloat {
        return frame.origin.y + frame.size.height
    }
    
    public var left: CGFloat {
        return frame.origin.x
    }
    
    public var right: CGFloat {
        return frame.origin.x + frame.size.width
    }
}


extension String {
    func safeDatabaseKey() -> String {
        return self.replacingOccurrences(of: ".", with: "-").replacingOccurrences(of: "@", with: "-")
    }
}

extension UIAlertController {
    
    func presentInOwnWindow(animated: Bool, completion: (() -> Void)?) {

            let windowAlertPresentationController = WindowAlertPresentController(alert: self)
            windowAlertPresentationController.present(animated: animated, completion: completion)
        }

}
