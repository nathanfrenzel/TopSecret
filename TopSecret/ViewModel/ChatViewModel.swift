//
//  ChatViewModel.swift
//  TopSecret
//
//  Created by nathan frenzel on 9/9/21.
//

import Foundation
import Firebase


class ChatViewModel : ObservableObject {
    @Published var messages : [Message] = []
    var userVM: UserAuthViewModel?
    
    
    init(){
        userVM?.fetchChats()
        
    }
    
    func setupUserVM(_ userVM: UserAuthViewModel){
        self.userVM = userVM
    }
    
    func loadMessages(chatID: String){
        COLLECTION_CHAT.document(chatID).collection("Messages").getDocuments { (querySnapshot, err) in
            if err != nil{
                print("Error")
                return
            }
            for document in querySnapshot!.documents{
                self.messages.append(Message(dictionary: document.data()))
            }
        }
    }
    
    func readAllMessages(chatID: String){
            
            COLLECTION_CHAT.document(chatID).collection("Messages").addSnapshotListener { (snapshot, err) in
                
                if err != nil {
                    print(err!.localizedDescription)
                    return
                }

                for doc in snapshot!.documentChanges {
                    
                    
                    // adding when data is added
                    
                    if doc.type == .added {
                        let username = doc.document.get("username") as? String ?? ""
                        let text = doc.document.get("text") as! String
                        let timeStamp = doc.document.get("timeStamp") as? Date ?? Date()
                        let id = doc.document.documentID
                        
                        self.messages.append(Message(dictionary: ["username":username, "text":text,"timeStamp":timeStamp,"id":id]))
                        
                        
                    }
                    
                }
                
            
        }
    }
    
    func sendMessage(message: Message,chatID: String){
        COLLECTION_CHAT.document(chatID).collection("Messages").addDocument(data: ["text":message.text,"username":message.username])
    }
}



