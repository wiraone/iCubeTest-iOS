//
//  ProfileInterface.swift
//  iCubeTest
//
//  Created by wirawan on 9/9/19.
//  Copyright © 2019 wirawan. All rights reserved.
//

import Foundation

protocol ProfileInterface {
    func validateEmail(user: User) -> Bool
    func validateUsername(user: User) -> Bool
    func getErrorMessage() -> String
}
