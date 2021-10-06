//
//  ChatViewModel.swift
//  TopSecret
//
//  Created by nathan frenzel on 9/9/21.
//

import Foundation
import Firebase
import SwiftUI


class ChatViewModel : ObservableObject {
    @Published var messages : [Message] = []
    @Published var userList : [User] = []
    var colors: [String] = ["green","red","blue","orange"]
    var userVM: UserAuthViewModel?
    
    
    init(){
        listen()
        
    }
    
    func setupUserVM(_ userVM: UserAuthViewModel){
        self.userVM = userVM
    }
    
    func listen(){
        COLLECTION_CHAT.addSnapshotListener { (snapshot, err) in
            if err != nil{
                print("Error")
                return
            }
            for doc in snapshot!.documentChanges{
                if doc.type == .removed{
                    self.userVM?.user?.chats = []
                    COLLECTION_CHAT.getDocuments { [self] (snapshot, err) in
                            if err != nil {
                                print("Error")
                                return
                            }
                            guard let documents = snapshot?.documents else{
                                print("No documents")
                                return
                            }
                            
                            for document in documents{
                                let data = document.data()
                                userVM?.user?.chats.append(ChatModel(dictionary: data))
                            }

                        }
                    
                    print("New Chat!")
                }
                if doc.type == .modified{
                    self.userVM?.user?.chats = []

                    COLLECTION_CHAT.getDocuments { [self] (snapshot, err) in
                            if err != nil {
                                print("Error")
                                return
                            }
                            guard let documents = snapshot?.documents else{
                                print("No documents")
                                return
                            }
                            
                            for document in documents{
                                let data = document.data()
                                userVM?.user?.chats.append(ChatModel(dictionary: data))
                            }

                        }
                    
                    print("Chat Gone!")
                }

            }
        }
    }
    
    func getUsers(userID: String){
        COLLECTION_USER.document(userID).getDocument { (snap, err) in
                if err != nil{
                    print("Error")
                    return
                }
                let username = snap?.get("username") as? String ?? " "
                let birthday = snap?.get("birthday") as? Date ?? Date()
                let fullName = snap?.get("fullname") as? String ?? " "
                let uid = snap?.get("uid") as? String ?? " "
                let email = snap?.get("email") as? String ?? " "
                
                
                
                self.userList.append(User(dictionary: ["username":username,"birthday":birthday,"fullname":fullName,"uid":uid,"email":email]))
            }
        
    }

    
    
    func readAllMessages(chatID: String){
        
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
                    let id = doc.document.documentID
                    
                    self.messages.append(Message(dictionary: ["username":username, "text":text,"timeStamp":timeStamp,"id":id, "nameColor":nameColor]))
                    
                    
                }
                
            }
            
            
        }
    }
    
    func sendMessage(message: Message,chatID: String){
        COLLECTION_CHAT.document(chatID).collection("Messages").addDocument(data: ["text":message.text,"username":message.username,"timeStamp":message.timeStamp, "nameColor":message.nameColor])
    }
    
    func pickColor(chatID: String,picker: Int) -> String{
        var choice = 0
        COLLECTION_CHAT.document(chatID).getDocument { (snapshot, err) in
            if let err = err{
                print("Error")
                return
            }
            let pickedColors = snapshot?.get("pickedColors") as? [String] ?? [""]
            var nextColor = snapshot?.get("nextColor") as? Int ?? 0
            print(pickedColors)
            
            
            if pickedColors.contains(self.colors[nextColor]){
                COLLECTION_CHAT.document(chatID).updateData(["nextColor":FieldValue.increment(Int64(1))])
                self.pickColor(chatID: chatID, picker: nextColor+1)
            }else{
                choice = nextColor
                COLLECTION_CHAT.document(chatID).updateData(["chatNameColors":FieldValue.arrayUnion([self.colors[nextColor]])])
                COLLECTION_CHAT.document(chatID).updateData(["pickedColors":FieldValue.arrayUnion([self.colors[nextColor]])])
                
            }
            
            
            
        }
        
        
        
        print("color is: \(self.colors[choice])")
        return self.colors[choice]
        
    }
    
    func leaveChat(chatID: String, userID: String){
        COLLECTION_CHAT.document(chatID).updateData(["memberAmount":FieldValue.increment(Int64(-1))])
        COLLECTION_CHAT.document(chatID).updateData(["users":FieldValue.arrayRemove([userID])])
        
        COLLECTION_CHAT.document(chatID).getDocument { (snapshot, err) in
            
            if err != nil {
                print("ERROR")
                return
            }
            
            let users = snapshot?.get("users") as? [String] ?? []
            
            if users.count <= 0 {
                COLLECTION_CHAT.document(chatID).delete() { err in
                    
                    if err != nil {
                        print("Unable to delete document")
                    }else{
                        print("sucessfully deleted document")
                    }
                    
                }
            }
            
            
            
            
            
        }
        
        
    }
    
    func joinChat(chatID: String, userID: String){
        
        COLLECTION_CHAT.document(chatID).updateData(["users":FieldValue.arrayUnion([userID])])
        COLLECTION_CHAT.document(chatID).updateData(["memberAmount":FieldValue.increment(Int64(1))])
        pickColor(chatID: chatID, picker: 0)
        
    }
    
    func createChat(name: String, userID: String, groupID: String) -> String{
        
        let id = UUID().uuidString
        
        
        let data = ["name": name,
                    "memberAmount":1,
                    "dateCreated":Date(),
                    "users":[userID], "id":id, "chatNameColors":[], "pickedColors":[], "nextColor":0, "groupID":groupID] as [String : Any]
        
        let chat = ChatModel(dictionary: data)
        
        COLLECTION_CHAT.document(chat.id).setData(data) { (err) in
            if err != nil{
                print("Error")
                return
            }
        }
        
        COLLECTION_CHAT.document(chat.id).updateData(["id":chat.id])
        pickColor(chatID: chat.id, picker: 0)
        
        return chat.id
        
    }
    func createChat(name: String, userID: String) -> String{
        
        let id = UUID().uuidString
        
        
        let data = ["name": name,
                    "memberAmount":1,
                    "dateCreated":Date(),
                    "users":[userID], "id":id, "chatNameColors":[], "pickedColors":[], "nextColor":0] as [String : Any]
        
        let chat = ChatModel(dictionary: data)
        
        COLLECTION_CHAT.document(chat.id).setData(data) { (err) in
            if err != nil{
                print("Error")
                return
            }
        }
        
        COLLECTION_CHAT.document(chat.id).updateData(["id":chat.id])
        pickColor(chatID: chat.id, picker: 0)
        
        return chat.id
        
    }
    
    
}



