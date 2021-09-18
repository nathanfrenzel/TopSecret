//
//  CreateGroupViewModel.swift
//  TopSecret
//
//  Created by Bruce Blake on 8/31/21.
//

import SwiftUI

import Firebase


class GroupViewModel: ObservableObject {
    
    @Published var group : Group?
    @Published var groupChat : ChatModel?
    
    var userVM: UserAuthViewModel?
    
    
    
    init(){
        userVM?.fetchGroups()
    }
    
    func setupUserVM(_ userVM: UserAuthViewModel){
        self.userVM = userVM
        
    }
    
    func createChat(group: Group){
        
        
        
        let data = ["name": group.groupName ?? " ",
                    "memberAmount":group.memberAmount,
                    "dateCreated":Date(),
                    "users":[userVM?.user?.id], "id":UUID().uuidString] as [String : Any]
        
        let chat = ChatModel(dictionary: data)
        
        COLLECTION_CHAT.document(chat.id).setData(data) { (err) in
            if let err = err{
                print("Error")
                return
            }
        }
       
        COLLECTION_CHAT.document(chat.id).updateData(["id":chat.id])
        COLLECTION_GROUP.document(group.id).updateData(["chatID":chat.id])

     
        
    }
    func joinChat(chatID: String){
      
        COLLECTION_CHAT.document(chatID).updateData(["users":FieldValue.arrayUnion([userVM?.user?.id ?? ""])])
        
    }
    
    
    func joinGroup(publicID: String){
        
        
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
                document.reference.updateData(["users":FieldValue.arrayUnion([userVM?.user?.id ?? " "])])
                document.reference.updateData(["memberAmount": group.memberAmount+1])
                
                print("sucesfully added user to group")
                joinChat(chatID: group.chatID ?? " ")
                
                
            }
            
            
            
        }
        
       
    }
    
    func leaveGroup(){
        let groupQuery = COLLECTION_GROUP.whereField("users", arrayContains: userVM?.user?.id ?? "")
        
        groupQuery.getDocuments { [self]  (querySnapshot, err) in
            if let err = err {
                print("DEBUG: \(err.localizedDescription)")
                return
            }
            
            for document in querySnapshot!.documents{
                
                let group = Group(dictionary: document.data())
                
                
                //updates the list of users
                document.reference.updateData(["users":FieldValue.arrayRemove([userVM?.user?.id ?? " "])])
                document.reference.updateData(["memberAmount": group.memberAmount-1])
                
                print("sucesfully removed user from group")
                
                
            }
        }
        
        
        
        
    }
    
    
    func createGroup(groupName: String, memberLimit: Int, dateCreated: Date, publicID: String){
        
        
        
        
        let data = ["groupName" : groupName,
                    "memberLimit" : memberLimit,
                    "publicID" : publicID,
                    "users" : [userVM?.user?.id] ,
                    "memberAmount": group?.memberAmount ?? 0, "id":UUID().uuidString, "chatID": " "
        ] as [String:Any]
        
        let group = Group(dictionary: data)
        
        
        //adds group to db
        COLLECTION_GROUP.document(group.id).setData(data)
        COLLECTION_GROUP.document(group.id).updateData(["id":group.id])
        createChat(group: group)

        
        //adds user to group
        joinGroup(publicID: group.publicID ?? " ")
        
        
        
        
        
    }
    
    
    
    
    
    
    
}






