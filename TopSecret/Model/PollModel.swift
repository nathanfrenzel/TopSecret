//
//  PollModel.swift
//  TopSecret
//
//  Created by Bruce Blake on 10/4/21.
//

import Firebase

struct PollModel : Identifiable {
    var id : String?
    var creator : String?
    var dateCreated : Timestamp?
    var question: String?
    var groupID : String?
    var groupName: String?
    var pollType: String?
    var totalUsers: Int?
    var usersAnswered: [String]?
    
   
    
    
    init(dictionary: [String:Any]){
        self.creator = dictionary["creator"] as? String ?? ""
        self.dateCreated = dictionary["dateCreated"] as? Timestamp ?? Timestamp()
        self.question = dictionary["question"] as? String ?? ""
        self.groupID = dictionary["groupID"] as? String ?? ""
        self.groupName = dictionary["groupName"] as? String ?? ""
        self.id = dictionary["id"] as? String ?? ""
        self.pollType = dictionary["pollType"] as? String ?? ""
        self.totalUsers = dictionary["totalUsers"] as? Int ?? 0
        self.usersAnswered = dictionary["usersAnswered"] as? [String] ?? []
    }
    
    init(){
        self.id = UUID().uuidString
    }
   
}
