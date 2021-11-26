//
//  ValidationModel.swift
//  TopSecret
//
//  Created by Bruce Blake on 11/22/21.
//

import Foundation
import Combine
import SwiftUI



enum ValidationError {
    case usernameTooShort
    case usernameAlreadyTaken
    case emailNotValid
    case emailAlreadyTaken
    case passwordTooShort
    case passwordNotStrongEnough
    case valid
}
