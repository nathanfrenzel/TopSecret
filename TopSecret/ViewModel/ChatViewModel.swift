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
    var colors: [String] = ["green","red","blue","orange"]
    @EnvironmentObject var userVM: UserViewModel
    @Published var chatRepository = ChatRepository()
    
    private var cancellables : Set<AnyCancellable> = []
    
    init(){
        chatRepository.$userList
            .assign(to: \.userList, on: self)
            .store(in: &cancellables)
    }
    
  
    func getUsers(userID: String){
        chatRepository.getUsers(userID: userID)
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



