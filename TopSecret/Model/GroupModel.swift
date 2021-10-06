//
//  GroupModel.swift
//  TopSecret
//
//  Created by Bruce Blake on 8/31/21.
//

import Foundation
import SwiftUI


struct Group: Identifiable{
    
    
    var groupName: String = ""
    var publicID: String?
    var id: String
    var dateCreated: Date?
    var memberAmount: Int = 0
    var memberLimit: Int?
    var users: [User.ID]?
    var polls : [PollModel]?
    var chatID: String?
    
    init(dictionary: [String:Any]){
        self.id = dictionary["id"] as? String ?? " "
        self.groupName = dictionary["groupName"] as? String ?? ""
        self.publicID = dictionary["publicID"] as? String ?? ""
        self.dateCreated = dictionary["dateCreated"] as? Date ?? Date()
        self.memberAmount = dictionary["memberAmount"] as? Int ?? 0
        self.memberLimit = dictionary["memberLimit"] as? Int ?? 0
        self.users = dictionary["users"] as? [User.ID] ?? []
        self.chatID = dictionary["chatID"] as? String ?? " "
        self.polls = dictionary["polls"] as? [PollModel] ?? []
      
    }
    init(){
        self.id = UUID().uuidString
    }
    
    
    
    
}
