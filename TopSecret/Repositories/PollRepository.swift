//
//  PollRepository.swift
//  TopSecret
//
//  Created by Bruce Blake on 11/10/21.
//

import Foundation
import Firebase
import Combine
import SwiftUI

class PollRepository : ObservableObject {
    
    
    func createPoll(creator: String, question: String, group: Group){
        let id = UUID().uuidString
        let data = ["creator":creator,"question":question,"dateCreated":Timestamp(),"id":id, "groupID":group.id, "groupName":group.groupName,"users":group.users ?? ""] as [String : Any]
        COLLECTION_POLLS.document(id).setData(data) { (err) in
            if err != nil {
                print("ERROR")
                return
            }
            
            print("Fetched User Polls")
        }
        
    }
    
//    func deletePoll(username: String, pollID: String, groupID: String){
//        COLLECTION_GROUP.document(groupID).collection("Polls").document(pollID).getDocument(completion: { (snapshot, err) in
//            if err != nil {
//                print("ERROR")
//                return
//            }
//            if snapshot?.get("creator") as! String == username {
//                COLLECTION_GROUP.document(groupID).collection("Polls").document(pollID).delete()
//            }
//        })
//    }
    
}
