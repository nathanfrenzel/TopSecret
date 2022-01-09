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
    var memberAmount: Int = 1
    var users : [String] = []
    var usersTyping : [String] = []
    var usersIdling : [String] = []
    var dateCreated: Date?
    var messages : [Message] = [ ]
    var pinnedMessage : String? //key value pair of messageID and pinnedByUserID
    var chatNameColors : [String]?  //Colors
    var nextColor: Int? //index for colors
    var pickedColors: [String]? //Picked chat name colors
    var groupID : String?
    var chatType : String?
    
    
    
    init(dictionary:[String:Any]){
        self.id = dictionary["id"] as? String ?? " "
        self.name = dictionary["name"] as? String ?? " "
        self.memberAmount = dictionary["memberAmount"] as? Int ?? 1
        self.users = dictionary["users"] as? [String] ?? []
        self.usersTyping = dictionary["usersTyping"] as? [String] ?? []
        self.usersIdling = dictionary["usersIdling"] as? [String] ?? []
        self.dateCreated = dictionary["dateCreated"] as? Date ?? Date()
        self.messages = dictionary["messages"] as? [Message] ?? [ ]
        self.chatNameColors = dictionary["chatNameColors"] as? [String] ?? []
        self.nextColor = dictionary["nextColor"] as? Int ?? 0
        self.pickedColors = dictionary["pickedColors"] as? [String] ?? []
        self.pinnedMessage = dictionary["pinnedMessage"] as? String ?? ""
        self.groupID = dictionary["groupID"] as? String ?? " "
        self.chatType = dictionary["chatType"] as? String ?? ""
    }
    init(){
        self.id = UUID().uuidString
    }
   
   
}
