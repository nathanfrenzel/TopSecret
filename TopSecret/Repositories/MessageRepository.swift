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
    @Published var pinnedMessage : PinnedMessageModel = PinnedMessageModel()
    @Published var scrollToBottom = 0 //used for scrolling based on published changes
    
    func readAllMessages(chatID: String, chatType: String, userID: String){
        
        if chatType == "groupChat"{ COLLECTION_CHAT.document(chatID).collection("Messages").order(by: "timeStamp",descending: false).addSnapshotListener { (snapshot, err) in
            
            if err != nil {
                print(err!.localizedDescription)
                return
            }

            self.messages = snapshot!.documents.map{ snapshot -> Message in
                    let name = snapshot.get("name") as? String ?? ""
                    let nameColor = snapshot.get("nameColor") as! String
                    let text = snapshot.get("text") as? String ?? ""
                    let timeStamp = snapshot.get("timeStamp") as? Timestamp ?? Timestamp()
                    let id = snapshot.get("id") as? String ?? ""
                    let profilePicture = snapshot.get("profilePicture") as? String ?? ""
                    let imageURL = snapshot.get("imageURL") as? String ?? ""
                    let messageType = snapshot.get("messageType") as? String ?? ""
                    
                    
                return Message(dictionary: ["name":name, "text":text,"timeStamp":timeStamp,"id":id, "nameColor":nameColor,"profilePicture":profilePicture,"imageURL":imageURL,"messageType":messageType])
                }

        }
        }
        else if chatType == "personal"{
            COLLECTION_PERSONAL_CHAT.document(chatID).collection("Messages").order(by: "timeStamp",descending: false).addSnapshotListener { (snapshot, err) in
                
                if err != nil {
                    print(err!.localizedDescription)
                    return
                }

                self.messages = snapshot!.documents.map{ snapshot -> Message in
                        let name = snapshot.get("name") as? String ?? ""
                        let nameColor = snapshot.get("nameColor") as! String
                        let text = snapshot.get("text") as? String ?? ""
                        let timeStamp = snapshot.get("timeStamp") as? Timestamp ?? Timestamp()
                        let id = snapshot.get("id") as? String ?? ""
                        let profilePicture = snapshot.get("profilePicture") as? String ?? ""
                        let imageURL = snapshot.get("imageURL") as? String ?? ""
                        let messageType = snapshot.get("messageType") as? String ?? ""
                        
                        
                    return Message(dictionary: ["name":name, "text":text,"timeStamp":timeStamp,"id":id, "nameColor":nameColor,"profilePicture":profilePicture,"imageURL":imageURL,"messageType":messageType])
                    }

            }
        }
    }
    
    func getPinnedMessage(chatID: String){
        COLLECTION_CHAT.document(chatID).addSnapshotListener { (snapshot, err) in
            if err != nil {
                print(err!.localizedDescription)
                return
            }
            
            let pinnedMessage = snapshot?.get("pinnedMessage")
            
            COLLECTION_CHAT.document(chatID).collection("Messages").whereField("id", isEqualTo: pinnedMessage as Any).getDocuments { (querySnapshot, err) in
                if err != nil {
                    print(err!.localizedDescription)
                    return
                }
                
                for document in querySnapshot!.documents{
                    let data = document.data()
                    let message = data["text"] as? String ?? ""
                    let timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
                    let profilePicture = data["profilePicture"] as? String ?? ""
                    let name = data["name"] as? String ?? ""
                    let id = data["id"] as? String ?? ""
                    
                    self.pinnedMessage = PinnedMessageModel(id: id, message: message, name: name, userProfilePicture: profilePicture, timestamp: timeStamp, pinnedTime: "4")
                    
                }
              
            }
        }
    }
    
    func pinMessage(chatID: String, messageID: String, userID: String){
        COLLECTION_CHAT.document(chatID).updateData(["pinnedMessage":messageID])
    }
    
    func readLastMessage() -> Message{
        return messages.last ?? Message()
    }
    
    
    func sendGroupChatTextMessage(text: String, user: User, timeStamp: Timestamp, nameColor: String, messageID: String,messageType: String, chat: ChatModel, chatType: String){
            COLLECTION_CHAT.document(chat.id).collection("Messages").document(messageID).setData(["text":text,"name":user.nickName ?? "","timeStamp":timeStamp, "nameColor":nameColor, "id":messageID,"profilePicture":user.profilePicture ?? "","messageType":messageType])
        
            
           
         
    }
    
    func sendPersonalTextMessage(text: String, user: User, timeStamp: Timestamp, nameColor: String, messageID: String, messageType: String, chat: ChatModel, chatType: String){
        
        //user 1
        COLLECTION_PERSONAL_CHAT.document(chat.id).collection("Messages").document(messageID).setData(["text":text,"name":user.nickName ?? "","timeStamp":timeStamp, "nameColor":nameColor, "id":messageID,"profilePicture":user.profilePicture ?? "","messageType":messageType])
        
   
    
 
    self.scrollToBottom += 1
    }
    
    
    
    func sendImageMessage(name: String, timeStamp: Timestamp, nameColor: String, messageID: String, profilePicture: String, messageType: String,chatID: String, imageURL: UIImage){
        COLLECTION_CHAT.document(chatID).collection("Messages").document(messageID).setData(["name":name,"timeStamp":timeStamp, "nameColor":nameColor, "id":messageID,"profilePicture":profilePicture,"messageType":messageType,"imageURL":""])
        persistImageToStorage(image: imageURL, chatID: chatID, messageID: messageID)
        self.scrollToBottom += 1
         
    }
    
    func sendDeletedMessage(name: String, timeStamp: Timestamp, nameColor:String, messageID: String, messageType: String, chatID: String){
        COLLECTION_CHAT.document(chatID).collection("Messages").document(messageID).setData(
            //this is the message
            ["name":name,"timeStamp":timeStamp,"nameColor":nameColor,"id":messageID,"messageType":messageType]
        )
        
        self.scrollToBottom += 1
    }
    
    
    
    
    
    
    func deleteMessage(chatID: String, message: Message){
        COLLECTION_CHAT.document(chatID).collection("Messages").document(message.id).delete { (err) in
            if err != nil {
                print("ERROR DELETING MESSAGE, ERROR CODE: \(String(describing: err?.localizedDescription))")
                return
            }
            
            self.sendDeletedMessage(name: message.name ?? "", timeStamp: message.timeStamp ?? Timestamp(), nameColor: message.nameColor ?? "", messageID: message.id, messageType: "deletedMessage", chatID: chatID)
            
        }
        
        
    }
    
    func persistImageToStorage(image: UIImage, chatID: String, messageID: String) {
       let fileName = "images/\(chatID)"
        let ref = Storage.storage().reference(withPath: fileName)
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { (metadata, err) in
            if err != nil{
                print("ERROR")
                return
            }
               ref.downloadURL { (url, err) in
                if err != nil{
                    print("ERROR: Failed to retreive download URL")
                    return
                }
                print("Successfully stored image in database")
                let imageURL = url?.absoluteString ?? ""
                COLLECTION_CHAT.document(chatID).collection("Messages").document(messageID).updateData(["imageURL":imageURL])
            }
        }
      
    }
   
    
    
}
