//
//  MessageRepository.swift
//  TopSecret
//
//  Created by Bruce Blake on 11/10/21.
//

import Foundation
import Combine
import Firebase
import SwiftUI


class MessageRepository : ObservableObject {
    
    @Published var messages : [Message] = []
    
    
    func readAllMessages(chatID: String){
        
        self.messages = []
        COLLECTION_CHAT.document(chatID).collection("Messages").order(by: "timeStamp",descending: false).addSnapshotListener { (snapshot, err) in
            
            if err != nil {
                print(err!.localizedDescription)
                return
            }
            
            for doc in snapshot!.documentChanges {
                
                
                // adding when data is added
                
                if doc.type == .added {
                    
                    let username = doc.document.get("username") as! String
                    let nameColor = doc.document.get("nameColor") as! String
                    let text = doc.document.get("text") as! String
                    let timeStamp = doc.document.get("timeStamp") as? Timestamp ?? Timestamp()
                    let id = doc.document.get("id") as? String ?? ""
                    let profilePicture = doc.document.get("profilePicture") as? String ?? ""
                    
                    
                    self.messages.append(Message(dictionary: ["username":username, "text":text,"timeStamp":timeStamp,"id":id, "nameColor":nameColor,"profilePicture":profilePicture]))
                    
                    
                }
                
            }
            
            
        }
    }
    
    func readLastMessage() -> Message{
        return messages.last ?? Message()
    }
    
    
    func sendMessage(message: Message,chatID: String){
        COLLECTION_CHAT.document(chatID).collection("Messages").document(message.id).setData(["text":message.text!,"username":message.username!,"timeStamp":message.timeStamp!, "nameColor":message.nameColor!, "id":message.id,"profilePicture":message.profilePicture!])
            
         
    }
    
    
}
