//
//  CreateGroupViewModel.swift
//  TopSecret
//
//  Created by Bruce Blake on 8/31/21.
//

import SwiftUI

import Firebase
import Combine



class GroupViewModel: ObservableObject {
    
    
    var userVM: UserViewModel?
    @ObservedObject var chatVM = ChatViewModel()
    @ObservedObject var groupRepository = GroupRepository()
    @Published var groupChat : ChatModel = ChatModel()
    @Published var usersProfilePictures : [String] = []
    @Published var groupProfileImage = ""

    
    private var cancellables : Set<AnyCancellable> = []

    
    init(){
        groupRepository.$usersProfilePictures
            .assign(to: \.usersProfilePictures, on: self)
            .store(in: &cancellables)
        groupRepository.$groupChat
            .assign(to: \.groupChat, on: self)
            .store(in: &cancellables)
        groupRepository.$groupProfileImage
            .assign(to: \.groupProfileImage, on: self)
            .store(in: &cancellables)
     
        
            
    }
    
    func changeMOTD(motd: String, groupID: String, userID: String){
        groupRepository.changeMOTD(motd: motd, groupID: groupID, userID: userID)
        
    }
    
    func getUsersProfilePictures(groupID: String){
        groupRepository.getUsersProfilePictures(groupID: groupID)
    }
    
    func getChat(chatID: String){
        groupRepository.getChat(chatID: chatID)
    }
    
    func setupUserVM(userVM: UserViewModel){
        self.userVM = userVM
    }
    
    
    func joinGroup(groupID: String, username: String){
        
        groupRepository.joinGroup(groupID: groupID, username: username)
        
        
    }
    
    
    func leaveGroup(groupID: String, userID: String){
        
        groupRepository.leaveGroup(groupID: groupID, userID: userID)
        
        
    }
    
    
    
    func createGroup(groupName: String, memberLimit: Int, dateCreated: Date, users: [String], image: UIImage){
        
        groupRepository.createGroup(groupName: groupName, memberLimit: memberLimit, dateCreated: dateCreated, users: users, image: image)
        
    }
    func createGroup(groupName: String, memberLimit: Int, dateCreated: Date, users: [String], image: UIImage, completion: @escaping (ChatModel) -> ()) -> (){
        
        groupRepository.createGroup(groupName: groupName, memberLimit: memberLimit, dateCreated: dateCreated, users: users, image: image) { chat in
            return completion(chat)
        }
        
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






