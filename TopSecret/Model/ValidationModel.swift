//
//  ValidationModel.swift
//  TopSecret
//
//  Created by Bruce Blake on 11/22/21.
//

import Foundation
import Combine
import SwiftUI



enum UsernameValidationError {
    case usernameTooShort
    case usernameAlreadyTaken
    case emailNotValid
    case emailAlreadyTaken
    case valid
 
}


enum EmailValidationError {
    case emailNotValid
    case emailAlreadyTaken
    case valid
}

enum PasswordValidationError{
    case passwordTooShort
    case passwordNotStrongEnough
    case valid
}


