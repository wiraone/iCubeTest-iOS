//
//  ProfilePresenter.swift
//  iCubeTest
//
//  Created by wirawan on 9/9/19.
//  Copyright © 2019 wirawan. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

class ProfilePresenter: ProfileInterface {
    private var errorMessage: String = ""
    
    init() {}
    
    func validateEmail(user: User) -> Bool {
        let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
       
        if testEmail.evaluate(with: user.email) == true {
            return true
        }
        else {
            errorMessage = "Email is required"
            return false
        }
    }
    
    func validateUsername(user: User) -> Bool {
        guard let name = user.name else {
            errorMessage = "Name is required"
            return false
        }
        
        if name.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count > 0 {
            return true
        }
        return false
    }
    
    func getErrorMessage() -> String {
        return errorMessage
    }
}

