//
//  GroupRepository.swift
//  TopSecret
//
//  Created by Bruce Blake on 11/10/21.
//

import Foundation
import Combine
import SwiftUI
import Firebase

class GroupRepository : ObservableObject {
    
    @ObservedObject var chatRepository = ChatRepository()
    @ObservedObject var pollRepository = PollRepository()
    @ObservedObject var userRepository = UserRepository()
    @Published var groupChat : ChatModel = ChatModel()
    
    
    
    func getChat(chatID: String){
        COLLECTION_CHAT.document(chatID).getDocument { (snapshot, err) in
            if err != nil{
                print("ERROR")
                return
            }
            let data = snapshot!.data()
            self.groupChat = ChatModel(dictionary: data!)
        }
    }
    
    func joinGroup(publicID: String, userID: String){
        
        
        //this finds the group in group list and adds user to its user list
        
        let groupQuery = COLLECTION_GROUP.whereField("publicID", isEqualTo: publicID)

        groupQuery.getDocuments { [self]  (querySnapshot, err) in
            if let err = err {
                print("DEBUG: \(err.localizedDescription)")
                return
            }
            if querySnapshot!.documents.count == 0 {
                print("unable to find group with code: \(publicID)")
                return
            }
            
            for document in querySnapshot!.documents{
                
                let group = Group(dictionary: document.data())
                
                //updates the list of users
                document.reference.updateData(["users":FieldValue.arrayUnion([userID])])
                document.reference.updateData(["memberAmount": FieldValue.increment(Int64(1))])
                
                print("sucesfully added user to group")
                chatRepository.joinChat(chatID: group.chatID ?? " ", userID: userID)
                
                
            }
            
            
            
        }
        
       
    }
    
    func leaveGroup(groupID: String, userID: String){
        COLLECTION_GROUP.document(groupID).updateData(["memberAmount": FieldValue.increment(Int64(-1))])
        COLLECTION_GROUP.document(groupID).updateData(["users":FieldValue.arrayRemove([userID])])
        
        COLLECTION_GROUP.document(groupID).getDocument { (snapshot, err) in
            if err != nil{
                print("ERROR")
                return
            }
            let groupChatID = snapshot?.get("chatID") as? String ?? " "
            self.chatRepository.leaveChat(chatID: groupChatID, userID: userID)
            
            let users = snapshot?.get("users") as? [String] ?? []
            
            if users.count <= 0{

                
                COLLECTION_GROUP.document(groupID).collection("Polls").getDocuments { (snapshot, err) in
                    for document in snapshot!.documents{
                        let pollID = document.get("id") as! String
                        COLLECTION_GROUP.document(groupID).collection("Polls").document(pollID).delete()
                    }
                }
                COLLECTION_GROUP.document(groupID).delete() { err in
                    
                    if err != nil {
                        print("Unable to delete document")
                    }else{
                        print("sucessfully deleted document")
                    }
                    
                }
            }
        }
        

        

    }
    
    func createGroup(groupName: String, memberLimit: Int, dateCreated: Date, publicID: String, userID: String){
        
        
        let id = UUID().uuidString
        
       

        let data = ["groupName" : groupName,
                    "memberLimit" : memberLimit,
                    "publicID" : publicID,
                    "users" : [userID] ,
                    "memberAmount": 1, "id":id, "chatID": " ", "dateCreated":Timestamp()
        ] as [String:Any]
                
        COLLECTION_GROUP.document(id).setData(data) { (err) in
            if err != nil {
                print("ERROR \(err!.localizedDescription)")
                return
            }
        }
        userRepository.fetchUserChats()
        chatRepository.createGroupChat(name: groupName, userID: userID, groupID: id)
        
    }
}
