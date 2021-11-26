//
//  UserRepositiory.swift
//  TopSecret
//
//  Created by Bruce Blake on 11/9/21.
//

import Foundation
import Firebase
import Combine
import SwiftUI

class UserRepository : ObservableObject {
    
    
    @Published var user : User?
    @Published var userSession : FirebaseAuth.User?
    @Published var groups: [Group] = []
    @Published var chats: [ChatModel] = []
    @Published var polls: [PollModel] = []
    @Published var isConnected : Bool = false
    
    private var cancellables : Set<AnyCancellable> = []
    let store = Firestore.firestore()
    let path = "Users"
    
    init(){
        
        userSession = Auth.auth().currentUser
        fetchUser()
    }
    
    
    
    func listenToUserChats(){
        
        COLLECTION_CHAT.whereField("users", arrayContains: self.user?.id ?? " ").addSnapshotListener { (snapshot, err) in
            
            guard let source = snapshot?.metadata.isFromCache else{
                print("error")
                return
            }
            if source {
                self.isConnected = false
                print("You are not connected, your data may not be up to date!")
            }else{
                self.isConnected = true
                print("You are connected!")
            }
            
            guard let documents = snapshot?.documents else {
                print("No document!")
                return
            }
            
            self.chats = documents.map{ queryDocumentSnapshot -> ChatModel in
                let data = queryDocumentSnapshot.data()
                let chatNameColors = data["chatNameColors"] as? [String] ?? []
                let pickedColors = data["pickedColors"] as? [String] ?? []
                let name = data["name"] as? String ?? ""
                let dateCreated = data["dateCreated"] as? Timestamp ?? Timestamp()
                let memberAmount = data["memberAmount"] as? Int ?? 0
                let nextColor = data["nextColor"] as? Int ?? 0
                let users = data["users"] as? [User.ID] ?? []
                let id = data["id"] as? String ?? ""
                print("Fetched Chats!")
                
                return ChatModel(dictionary: ["chatNameColors":chatNameColors,"pickedColors":pickedColors,"name":name,"memberAmount":memberAmount,"dateCreated":dateCreated,"nextColor":nextColor,"users":users,"id":id])
                
                
            }
            
        }
        
    }
    
    func listenToUserGroups(){
        
        COLLECTION_GROUP.whereField("users", arrayContains: self.user?.id ?? " ").addSnapshotListener { (snapshot, err) in
            
         
            guard let source = snapshot?.metadata.isFromCache else{
                print("error")
                return
            }
            if source {
                self.isConnected = false
                print("You are not connected, your data may not be up to date!")
            }else{
                self.isConnected = true
                print("You are connected!")
            }
            
            guard let documents = snapshot?.documents else {
                print("No document!")
                return
            }
            self.groups = documents.map{ queryDocumentSnapshot -> Group in
                let data = queryDocumentSnapshot.data()
                let chatID = data["chatID"] as? String ?? ""
                let groupName = data["groupName"] as? String ?? ""
                let memberAmount = data["memberAmount"] as? Int ?? 0
                let memberLimit = data["memberLimit"] as? Int ?? 0
                let publicID = data["publicID"] as? String ?? ""
                let users = data["users"] as? [User.ID] ?? []
                let id = data["id"] as? String ?? ""
                print("Fetched Groups!")
                
                return Group(dictionary: ["chatID":chatID,"groupName":groupName,"memberAmount":memberAmount,"memberLimit":memberLimit,"publicID":publicID,"users":users,"id":id])
                
                
            }
            
        }
    }
    
    func listenToUserPolls(){
        for group in self.groups{
            COLLECTION_GROUP.document(group.id).collection("Polls").order(by: "dateCreated",descending: true).addSnapshotListener { (snapshot, err) in
                
                guard let source = snapshot?.metadata.isFromCache else{
                    print("error")
                    return
                }
                if source {
                    self.isConnected = false
                    print("You are not connected, your data may not be up to date!")
                }else{
                    self.isConnected = true
                    print("You are connected!")
                }
                
                
                guard let documents = snapshot?.documents else {
                    print("No document!")
                    return
                }
                self.polls = documents.map{ queryDocumentSnapshot -> PollModel in
                    let data = queryDocumentSnapshot.data()
                    let question = data["question"] as? String ?? ""
                    let creator = data["creator"] as? String ?? ""
                    let dateCreated = data["dateCreated"] as? Timestamp ?? Timestamp()
                    let groupID = data["groupID"] as? String ?? ""
                    let groupName = data["groupName"] as? String ?? ""
                    let id = data["id"] as? String ?? ""
                    print("Fetched Polls!")
                    
                    return PollModel(dictionary: ["question":question,"creator":creator,"dateCreated":dateCreated,"groupID":groupID,"groupName":groupName,"id":id])
                    
                    
                }
                
            }
        }
        
        
        
        
    }
    
    
    func listenToAll(){
        listenToUserChats()
        listenToUserGroups()
        listenToUserPolls()
    }
    
    func fetchUserChats(){
        //TODO
    }
    
    func fetchUserGroups(){
        //TODO
        COLLECTION_GROUP.whereField("users", arrayContains: user?.id ?? "").getDocuments { (snapshot, err) in
            if err != nil {
                print("ERROR \(err!.localizedDescription)")
                return
            }
            for document in snapshot!.documents {
                let source = document.metadata.isFromCache
                if source{
                    print("You are offline!")
                }else{
                    print("You are online!")
                }
            }
            
            guard let documents = snapshot?.documents else {
                print("No document!")
                return
            }
            
            self.groups = documents.map{ queryDocumentSnapshot -> Group in
                let data = queryDocumentSnapshot.data()
                let chatID = data["chatID"] as? String ?? ""
                let groupName = data["groupName"] as? String ?? ""
                let memberAmount = data["memberAmount"] as? Int ?? 0
                let memberLimit = data["memberLimit"] as? Int ?? 0
                let publicID = data["publicID"] as? String ?? ""
                let users = data["users"] as? [User.ID] ?? []
                let id = data["id"] as? String ?? ""
                print("Fetched Groups!")
                
                print("Fetched User Groups!")

                return Group(dictionary: ["chatID":chatID,"groupName":groupName,"memberAmount":memberAmount,"memberLimit":memberLimit,"publicID":publicID,"users":users,"id":id])
                
            }
            
            
            
        }
    }
    func fetchUserPolls(){
        //TODO
    }
    func fetchAll(){
        fetchUserChats()
        fetchUserGroups()
        fetchUserPolls()
    }
    
    
    
    func createUser(email: String, password: String, username: String, fullname: String, birthday: Date){
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            if let err = err{
                print("DEBUG: ERROR: \(err.localizedDescription)")
                return
            }
            
            guard let user = result?.user else {return}
            
            let data = ["email": email,
                        "username": username,
                        "fullname": fullname,
                        "uid": user.uid,
                        "birthday": birthday,
                        
            ] as [String : Any]
            COLLECTION_USER.document(user.uid).setData(data){ _ in
                self.userSession = user
                self.fetchUser()
                print("DEBUG: Succesfully uploaded user data!")
            }
            
            Auth.auth().currentUser?.sendEmailVerification(completion: { (err) in
                
            })
            
            
            
        }
    }
    
    
    func signIn(withEmail email: String, password: String){
        
        Auth.auth().signIn(withEmail: email, password: password) { (result,err) in
            
            if let x = err {
                  let error = x as NSError
                  switch error.code {
                  case AuthErrorCode.networkError.rawValue:
                      print("There was a network error dumbass")
                  default:
                      print("unknown error: \(error.localizedDescription)")
                  }
            }else{
                print("You are connected")
            }
            
            self.userSession = result?.user
            self.fetchUser()
            
        }
        
    }
    
    func signOut(){
        userSession = nil
        try? Auth.auth().signOut()
    }
    
    func fetchUser(){
        guard let uid = userSession?.uid else {return}
        
        store.collection(path).document(uid).getDocument { (snapshot, _) in
            guard let data = snapshot?.data() else {return}
            let user = User(dictionary: data)
            self.user = user
        }
    }
    
    func resetPassword(email: String){
        Auth.auth().sendPasswordReset(withEmail: email) { (err) in
            print("You have been sent an email to reset your password!")
        }
    }
    
}
