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
    var nickName: String?
    var birthday: Date?
    var bio: String?
    var profilePicture: String?
    var friendsList : [String]?
    


init(dictionary: [String:Any]) {
    self.id = dictionary["uid"] as? String ?? " "
    self.username = dictionary["username"] as? String ?? ""
    self.email = dictionary["email"] as? String ?? ""
    self.password = dictionary["password"] as? String ?? ""
    self.nickName = dictionary["nickName"] as? String ?? ""
    self.birthday = dictionary["birthday"] as? Date ?? Date()
    self.profilePicture = dictionary["profilePicture"] as? String ?? ""
    self.bio = dictionary["bio"] as? String ?? "This is my bio"
    self.friendsList = dictionary["friendsList"] as? [String] ?? []

 }

    init(){
        self.id = UUID().uuidString
    }
    
}
