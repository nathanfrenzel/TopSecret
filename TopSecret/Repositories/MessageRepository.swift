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
            
                
            self.messages = snapshot!.documents.map{ snapshot -> Message in
                let name = snapshot.get("name") as? String ?? ""
                    let nameColor = snapshot.get("nameColor") as! String
                    let text = snapshot.get("text") as! String
                    let timeStamp = snapshot.get("timeStamp") as? Timestamp ?? Timestamp()
                    let id = snapshot.get("id") as? String ?? ""
                let profilePicture = snapshot.get("profilePicture") as? String ?? ""
                    
                    
                    return Message(dictionary: ["name":name, "text":text,"timeStamp":timeStamp,"id":id, "nameColor":nameColor,"profilePicture":profilePicture])
                }
                
                
            
                
            
            
            
        }
    }
    
    func readLastMessage() -> Message{
        return messages.last ?? Message()
    }
    
    
    func sendMessage(message: Message,chatID: String){
        COLLECTION_CHAT.document(chatID).collection("Messages").document(message.id).setData(["text":message.text!,"name":message.name!,"timeStamp":message.timeStamp!, "nameColor":message.nameColor!, "id":message.id,"profilePicture":message.profilePicture!])
            
         
    }
    
   
    
    
}
