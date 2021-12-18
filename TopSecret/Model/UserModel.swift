//
//  UserModel.swift
//  TopSecret
//
//  Created by Bruce Blake on 4/3/21.
//

import Foundation
import SwiftUI

struct User : Identifiable, Hashable{
    var id : String?
    var username: String?
    var email: String?
    var password: String?
    var fullname: String?
    var birthday: Date?
    var profilePicture: String?
    


init(dictionary: [String:Any]) {
    self.id = dictionary["uid"] as? String ?? " "
    self.username = dictionary["username"] as? String ?? ""
    self.email = dictionary["email"] as? String ?? ""
    self.password = dictionary["password"] as? String ?? ""
    self.fullname = dictionary["fullname"] as? String ?? ""
    self.birthday = dictionary["birthday"] as? Date ?? Date()
    self.profilePicture = dictionary["profilePicture"] as? String ?? ""

 }

    init(){
        self.id = UUID().uuidString
    }
    
}
