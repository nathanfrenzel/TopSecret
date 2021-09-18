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
    
    
    
    func readAllMessages(chatID: String){
        
        COLLECTION_CHAT.document(chatID).collection("Messages").addSnapshotListener { (snapshot, err) in
            
            if err != nil {
                print(err!.localizedDescription)
                return
            }
            
            for doc in snapshot!.documentChanges {
                
                
                // adding when data is added
                
                if doc.type == .added {
                    let username = doc.document.get("username") as! String
                    let text = doc.document.get("text") as! String
                    let timeStamp = doc.document.get("timeStamp") as? Date ?? Date()
                    let id = doc.document.documentID
                    
                    self.messages.append(Message(dictionary: ["username":username, "text":text,"timeStamp":timeStamp,"id":id]))
                    
                    
                }
                
            }
            
            
        }
    }
    
    func sendMessage(message: Message,chatID: String){
        COLLECTION_CHAT.document(chatID).collection("Messages").addDocument(data: ["text":message.text,"username":message.username,"timeStamp":message.timeStamp])
    }
    
    
    
    
    func createChat(isPersonal: Bool, chatName: String){
        
        let id = UUID().uuidString
        let data = ["isPersonal":isPersonal,"name":chatName,"memberAmount":1,"dateCreated":Date(),"users":[userVM?.user?.id],"id":id] as [String : Any]
        let chat = ChatModel(dictionary: data)
        COLLECTION_CHAT.document(id).setData(data){(err) in
            if let err = err{
                print("Error")
                return
            }
            
        }
    }
}



