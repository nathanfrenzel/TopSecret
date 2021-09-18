//
//  ChatModel.swift
//  TopSecret
//
//  Created by Bruce Blake on 9/8/21.
//

import Foundation
import SwiftUI

struct ChatModel : Identifiable {
    var id: String
    var name: String?
    var memberAmount: Int?
    var users : [User.ID]?
    var dateCreated: Date?
    var messages : [Message] = [ ]
    var isPersonal: Bool 
    
    
    init(dictionary:[String:Any]){
        self.id = dictionary["id"] as? String ?? " "
        self.name = dictionary["name"] as? String ?? ""
        self.memberAmount = dictionary["memberAmount"] as? Int ?? 0
        self.users = dictionary["users"] as? [User.ID] ?? []
        self.dateCreated = dictionary["dateCreated"] as? Date ?? Date()
        self.messages = dictionary["messages"] as? [Message] ?? [ ]
        self.isPersonal = dictionary["isPersonal"] as? Bool ?? false
    }
    init(){
        self.id = UUID().uuidString
        self.isPersonal = false
    }
   
   
}
