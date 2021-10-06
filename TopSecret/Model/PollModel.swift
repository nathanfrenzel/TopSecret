//
//  PollModel.swift
//  TopSecret
//
//  Created by Bruce Blake on 10/4/21.
//

import Firebase

struct PollModel : Identifiable {
    var id = UUID().uuidString
    var creator : String?
    var dateCreated : Timestamp?
    var question: String?
    var pollType: String?
    var groupID : String?
    var groupName: String?
    var answered: Bool?
    
    init(dictionary: [String:Any]){
        self.creator = dictionary["creator"] as? String ?? ""
        self.dateCreated = dictionary["dateCreated"] as? Timestamp ?? Timestamp()
        self.question = dictionary["question"] as? String ?? ""
        self.groupID = dictionary["groupID"] as? String ?? ""
        self.groupName = dictionary["groupName"] as? String ?? ""
        self.answered = dictionary["answered"] as? Bool ?? false
    }
    
    init(){
        self.creator = " "
        self.dateCreated = Timestamp()
        self.question = " "
        self.pollType = " "
        self.groupID = " "
        self.groupName = " "
        self.answered = false
    }
}
