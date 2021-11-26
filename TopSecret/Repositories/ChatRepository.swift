//
//  ChatRepository.swift
//  TopSecret
//
//  Created by Bruce Blake on 11/10/21.
//

import Foundation
import Combine
import SwiftUI
import Firebase


class ChatRepository : ObservableObject {
    @Published var userList : [User] = []
    var colors: [String] = ["green","red","blue","orange"]

    func getUsers(userID: String){
        
        COLLECTION_USER.document(userID).getDocument { (snap, err) in
                if err != nil{
                    print("Error")
                    return
                }
            let data = snap!.data()
            self.userList.append(User(dictionary: data!))
//                let username = snap?.get("username") as? String ?? " "
//                let birthday = snap?.get("birthday") as? Date ?? Date()
//                let fullName = snap?.get("fullname") as? String ?? " "
//                let uid = snap?.get("uid") as? String ?? " "
//                let email = snap?.get("email") as? String ?? " "
//
//
//
//                self.userList.append(User(dictionary: ["username":username,"birthday":birthday,"fullname":fullName,"uid":uid,"email":email]))
            }
        
    }
    
   
    
    func createGroupChat(name: String, userID: String, groupID: String){
        
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
        
        COLLECTION_GROUP.document(groupID).updateData(["chatID": id])
        pickColor(chatID: chat.id, picker: 0)

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
                
                COLLECTION_CHAT.document(chatID).collection("Messages").getDocuments { (snapshot, err) in
                  
                    for document in snapshot!.documents{
                        let messageID = document.get("id") as! String
                        COLLECTION_CHAT.document(chatID).collection("Messages").document(messageID).delete()
                    }
                }
                
                COLLECTION_CHAT.document(chatID).delete() { err in
                    
                    if err != nil {
                        print("Unable to delete chat")
                    }else{
                        print("sucessfully deleted chat")
                    }
                    
                }
            }
            
            
            
            
            
        }
        
        
    }
    
    func pickColor(chatID: String,picker: Int) -> String{
        var choice = 0
        COLLECTION_CHAT.document(chatID).getDocument { (snapshot, err) in
            if err != nil{
                print("Error")
                return
            }
            let pickedColors = snapshot?.get("pickedColors") as? [String] ?? [""]
            var nextColor = snapshot?.get("nextColor") as? Int ?? 0
            
            
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
    
    func joinChat(chatID: String, userID: String){
        
        COLLECTION_CHAT.document(chatID).updateData(["users":FieldValue.arrayUnion([userID])])
        COLLECTION_CHAT.document(chatID).updateData(["memberAmount":FieldValue.increment(Int64(1))])
        pickColor(chatID: chatID, picker: 0)
        
    }
    
}
