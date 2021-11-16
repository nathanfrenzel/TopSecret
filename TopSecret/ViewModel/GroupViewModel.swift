//
//  CreateGroupViewModel.swift
//  TopSecret
//
//  Created by Bruce Blake on 8/31/21.
//

import SwiftUI

import Firebase


class GroupViewModel: ObservableObject {
    
    
    var userVM: UserViewModel?
    @ObservedObject var chatVM = ChatViewModel()
    @Published var groupRepository = GroupRepository()
    
    init(){
        
    }
    
    func setupUserVM(userVM: UserViewModel){
        self.userVM = userVM
    }
    
    
    func joinGroup(publicID: String, userID: String){
        
        groupRepository.joinGroup(publicID: publicID, userID: userID)
        
        
    }
    
    
    func leaveGroup(groupID: String, userID: String){
        
        groupRepository.leaveGroup(groupID: groupID, userID: userID)
        
        
    }
    
    
    
    func createGroup(groupName: String, memberLimit: Int, dateCreated: Date, publicID: String, userID: String){
        
        groupRepository.createGroup(groupName: groupName, memberLimit: memberLimit, dateCreated: dateCreated, publicID: publicID, userID: userID)
        
    }
    
//    func listen(){
//        COLLECTION_GROUP.whereField("users", arrayContains: userVM.user?.id ?? " ").addSnapshotListener { (snapshot, err) in
//            if err != nil{
//                print("Error")
//                return
//            }
//            for doc in snapshot!.documentChanges{
//                if doc.type == .removed{
//                    self.userVM.user?.groups = []
//                    self.userVM.fetchUserGroups()
//
//                    print("New Group!")
//                }
//                if doc.type == .modified{
//                    self.userVM.user?.groups = []
//
//                    COLLECTION_GROUP.whereField("users", arrayContains: self.userVM.user?.id ?? " ").getDocuments { [self] (snapshot, err) in
//                        if err != nil {
//                            print("Error")
//                            return
//                        }
//                        guard let documents = snapshot?.documents else{
//                            print("No documents")
//                            return
//                        }
//
//                        for document in documents{
//                            let data = document.data()
//                            userVM.user?.groups.append(Group(dictionary: data))
//                        }
//
//                    }
//
//                    print("Group Gone!")
//                }
//
//            }
//        }
//    }
    
    
  

    
}






