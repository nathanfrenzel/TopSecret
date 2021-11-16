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
        let data = ["creator":creator,"question":question,"dateCreated":Timestamp(),"id":id, "groupID":group.id, "groupName":group.groupName ] as [String : Any]
        COLLECTION_GROUP.document(group.id).collection("Polls").document(id).setData(data) { (err) in
            if err != nil {
                print("ERROR")
                return
            }
            
        }
 
    }

}
