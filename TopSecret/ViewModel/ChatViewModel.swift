//
//  ChatViewModel.swift
//  TopSecret
//
//  Created by nathan frenzel on 9/9/21.
//

import Foundation
import Firebase
import SwiftUI
import Combine


class ChatViewModel : ObservableObject {
    @Published var userList : [User] = []
    @Published var usersTypingList : [User] = []
    @Published var usersIdlingList : [User] = []
    @Published var group : Group = Group()
    var colors: [String] = ["green","red","blue","orange","purple","teal"]
    @EnvironmentObject var userVM: UserViewModel
    @ObservedObject var chatRepository = ChatRepository()
    
    private var cancellables : Set<AnyCancellable> = []
    
    init(){
        chatRepository.$userList
            .assign(to: \.userList, on: self)
            .store(in: &cancellables)
        chatRepository.$usersTypingList
            .assign(to: \.usersTypingList, on: self)
            .store(in: &cancellables)
        chatRepository.$usersIdlingList
            .assign(to: \.usersIdlingList, on: self)
            .store(in: &cancellables)
        chatRepository.$group
            .assign(to: \.group, on: self)
            .store(in: &cancellables)
    }
    
    func startTyping(userID: String, chatID: String){
        chatRepository.startTyping(userID: userID, chatID: chatID)
    }
  
    func stopTyping(userID: String, chatID: String){
        chatRepository.stopTyping(userID: userID, chatID: chatID)
    }
    
    func getUsersTypingList(chatID: String){
        chatRepository.getUsersTypingList(chatID: chatID)
    }
    
    func getUsersIdlingList(chatID: String){
        chatRepository.getUsersIdlingList(chatID: chatID)
    }
    
    func getUsers(userID: String){
        chatRepository.getUsers(userID: userID)
    }
    
    func openChat(userID: String, chatID: String){
        chatRepository.openChat(userID: userID, chatID: chatID)
    }
    
    func exitChat(userID: String, chatID: String){
        chatRepository.exitChat(userID: userID, chatID: chatID)
    }
    
    func getGroup(groupID: String){
        chatRepository.getGroup(groupID: groupID)
    }

    func joinChat(chatID: String, userID: String){
        chatRepository.joinChat(chatID: chatID, userID: userID)
    }
   
    func createGroupChat(name: String, userID: String, groupID: String){
        chatRepository.createGroupChat(name: name, userID: userID, groupID: groupID)
    }
    
    func pickColor(chatID: String, picker: Int){
        chatRepository.pickColor(chatID: chatID, picker: picker)
    }
    
    func leaveChat(chatID: String, userID: String){
        chatRepository.leaveChat(chatID: chatID, userID: userID)
    }
    
//    func listen(){
//        COLLECTION_CHAT.whereField("users", arrayContains: userVM.user?.id ?? " ").addSnapshotListener { (snapshot, err) in
//            if err != nil{
//                print("Error")
//                return
//            }
//            for doc in snapshot!.documentChanges{
//                if doc.type == .removed{
//                    COLLECTION_CHAT.whereField("users", arrayContains: self.userVM.user?.id ?? " ").getDocuments { (snapshot, err) in
//                        guard let documents = snapshot?.documents else{
//                            print("No documents")
//                            return
//                        }
//
//                        self.userVM.user?.chats = documents.map{ (queryDocumentSnapshot) -> ChatModel in
//                            let data = queryDocumentSnapshot.data()
//
//
//                            let chat = ChatModel(dictionary: data)
//
//
//
//
//
//                            return chat
//
//                        }
//
//                    }
//
//                    print("New Chat!")
//                }
//                if doc.type == .modified{
//                    self.userVM.user?.chats = []
//
//                    COLLECTION_CHAT.whereField("users", arrayContains: self.userVM.user?.id ?? " ").getDocuments { [self] (snapshot, err) in
//                            if err != nil {
//                                print("Error")
//                                return
//                            }
//                            guard let documents = snapshot?.documents else{
//                                print("No documents")
//                                return
//                            }
//
//                            for document in documents{
//                                let data = document.data()
//                                userVM.user?.chats.append(ChatModel(dictionary: data))
//                            }
//
//                        }
//
//                    print("Chat Gone!")
//                }
//
//            }
//        }
//    }
//
    
    
}



