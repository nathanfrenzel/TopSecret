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
    var chatVM = ChatViewModel()
    
    
    
    init(){
        listen()
    }
    
    func setupUserVM(_ userVM: UserAuthViewModel){
        self.userVM = userVM
        
    }
    
    func setupChatVM(_ chatVM: ChatViewModel){
        self.chatVM = chatVM
    }
    
    
    
    func listen(){
        COLLECTION_GROUP.addSnapshotListener { (snapshot, err) in
            if err != nil{
                print("Error")
                return
            }
            for doc in snapshot!.documentChanges{
                if doc.type == .removed{
                    self.userVM?.user?.groups = []
                    COLLECTION_GROUP.getDocuments { [self] (snapshot, err) in
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
                                userVM?.user?.groups.append(Group(dictionary: data))
                            }

                        }
                    
                    print("New Group!")
                }
                if doc.type == .modified{
                    self.userVM?.user?.groups = []

                    COLLECTION_GROUP.getDocuments { [self] (snapshot, err) in
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
                                userVM?.user?.groups.append(Group(dictionary: data))
                            }

                        }
                    
                    print("Group Gone!")
                }

            }
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
                chatVM.joinChat(chatID: group.chatID ?? " ", userID: userID)
                
                
            }
            
            
            
        }
        
       
    }
    

    func leaveGroup(groupID: String, userID: String){
        COLLECTION_GROUP.document(groupID).updateData(["memberAmount": FieldValue.increment(Int64(-1))])
        COLLECTION_GROUP.document(groupID).updateData(["users":FieldValue.arrayRemove([userID])])
        userVM?.fetchGroups()
        
        COLLECTION_GROUP.document(groupID).getDocument { (snapshot, err) in
            if err != nil{
                print("ERROR")
                return
            }
            let groupChatID = snapshot?.get("chatID") as? String ?? " "
            self.chatVM.leaveChat(chatID: groupChatID, userID: userID)

        }
        

        COLLECTION_GROUP.document(groupID).getDocument { (snapshot, err) in
            if err != nil{
                print("ERROR")
                return
            }
            let users = snapshot?.get("users") as? [String] ?? []
            
            if users.count <= 0{
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
    

    
    func createGroup(groupName: String, memberLimit: Int, dateCreated: Date, publicID: String){
        
        
        
        
        let data = ["groupName" : groupName,
                    "memberLimit" : memberLimit,
                    "publicID" : publicID,
                    "users" : [userVM?.user?.id] ,
                    "memberAmount": 1, "id":UUID().uuidString, "chatID": " "
        ] as [String:Any]
        
        let group = Group(dictionary: data)
        
        
        //adds group to db
        COLLECTION_GROUP.document(group.id).setData(data)
        
        
        
        let chatID = chatVM.createChat(name: group.groupName ?? "",userID: userVM?.user?.id ?? " ", groupID: group.id)
        COLLECTION_GROUP.document(group.id).updateData(["chatID":chatID ])


        
    
        
        
        
        
        
    }
    
    
    
    
    
    
    
}






