//
//  UIViewController+Alert.swift
//  iCubeTest
//
//  Created by wirawan on 9/9/19.
//  Copyright © 2019 wirawan. All rights reserved.
//

import UIKit
import Foundation

typealias confirmCallback = () -> Void
typealias cancelCallback = () -> Void

class CustomAlert {
    class func showAlert(title: String,
                         message: String,
                         parent: UIViewController,
                         confirmCallback: @escaping confirmCallback,
                         cancelCallback: @escaping cancelCallback) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            confirmCallback()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive) {
            UIAlertAction in
            cancelCallback()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        parent.present(alertController, animated: true, completion: nil)
    }
    
    class func showAlert(title: String,
                         message: String,
                         parent: UIViewController,
                         confirmCallback: @escaping confirmCallback) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            confirmCallback()
        }
        alertController.addAction(confirmAction)
        parent.present(alertController, animated: true, completion: nil)
    }
}

