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
    var answered: Bool?
    
    public enum pollType {
        case freeResponse
        case twoChoices
        case threeChoices
        case fourChoices           
    }
    
    
    init(dictionary: [String:Any]){
        self.creator = dictionary["creator"] as? String ?? ""
        self.dateCreated = dictionary["dateCreated"] as? Timestamp ?? Timestamp()
        self.question = dictionary["question"] as? String ?? ""
        self.groupID = dictionary["groupID"] as? String ?? ""
        self.groupName = dictionary["groupName"] as? String ?? ""
        self.answered = dictionary["answered"] as? Bool ?? false
        self.id = dictionary["id"] as? String ?? ""
    }
    
    init(){
        self.id = UUID().uuidString
    }
   
}
