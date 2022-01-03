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
    @Published var loginErrorMessage = ""
    @Published var userSession : FirebaseAuth.User?
    @Published var profilePicture : UIImage = UIImage()
    @Published var groups: [Group] = []
    @Published var chats: [ChatModel] = []
    @Published var polls: [PollModel] = []
    @Published var events: [EventModel] = []
    @Published var isConnected : Bool = false
    
    private var cancellables : Set<AnyCancellable> = []
    let store = Firestore.firestore()
    let path = "Users"
    
    init(){
        
        userSession = Auth.auth().currentUser
        fetchUser()
        if userSession != nil{
            self.listenToAll(uid: userSession!.uid)
        }
        
    }
    
    func persistImageToStorage(userID: String, image: UIImage) {
       let fileName = "userProfileImages/\(userID)"
        let ref = Storage.storage().reference(withPath: fileName)
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { (metadata, err) in
            if err != nil{
                print("ERROR")
                return
            }
               ref.downloadURL { (url, err) in
                if err != nil{
                    print("ERROR: Failed to retreive download URL")
                    return
                }
                print("Successfully stored image in database")
                let imageURL = url?.absoluteString ?? ""
                COLLECTION_USER.document(userID).updateData(["profilePicture":imageURL])
            }
        }
      
    }
    
    func listenToUserChats(uid: String){
        
        
        COLLECTION_CHAT.whereField("users", arrayContains: uid).addSnapshotListener { (snapshot, err) in
            
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
                let groupID = data["groupID"] as? String ?? " "
                print("Fetched Chats!")
                
                return ChatModel(dictionary: ["chatNameColors":chatNameColors,"pickedColors":pickedColors,"name":name,"memberAmount":memberAmount,"dateCreated":dateCreated,"nextColor":nextColor,"users":users,"id":id,"groupID":groupID])
                
                
            }
            
        }
        
    }
    
    func listenToUserGroups(uid: String){
        
        COLLECTION_GROUP.whereField("users", arrayContains: uid).addSnapshotListener { (snapshot, err) in
            
         
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
                    let groupProfileImage = data["groupProfileImage"] as? String ?? ""
                    let motd = data["motd"] as? String ?? "Welcome to the group!"
                    let quoteOfTheDay = data["quoteOfTheDay"] as? String ?? ""
                    let pinnedMessage = data["pinnedMessage"] as? String ?? ""
                    print("Fetched Groups!")
                    

                    return Group(dictionary: ["chatID":chatID,"groupName":groupName,"memberAmount":memberAmount,"memberLimit":memberLimit,"publicID":publicID,"users":users,"id":id, "groupProfileImage":groupProfileImage,"motd":motd,"quoteOfTheDay":quoteOfTheDay,"pinnedMessage":pinnedMessage])
                    
                }

            
            
        }
    }
    
    func listenToUserPolls(uid: String){
        
        COLLECTION_POLLS.whereField("users", arrayContains: uid).order(by: "dateCreated",descending: true).addSnapshotListener { (snapshot, err) in
                
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
                    let users = data["users"] as? [String] ?? []
                    let id = data["id"] as? String ?? ""
                    print("Fetched Polls!")
                    
                    return PollModel(dictionary: ["question":question,"creator":creator,"dateCreated":dateCreated,"groupID":groupID,"groupName":groupName,"id":id,"users":users])
                    
                    
                }
                
        }
        
        
        
        
        
    }
    
    func listenToUserEvents(uid: String){
        
        COLLECTION_EVENTS.whereField("usersVisibleTo", arrayContains: uid).addSnapshotListener { (snapshot, err) in
                
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
                self.events = documents.map{ queryDocumentSnapshot -> EventModel in
                    let data = queryDocumentSnapshot.data()
                    let eventName = data["eventName"] as? String ?? ""
                    let eventLocation = data["eventLocation"] as? String ?? ""
                    let eventTime = data["eventTime"] as? Date ?? Date()
                    let usersVisibleTo = data["usersVisibleTo"] as? [String] ?? []
                    let id = data["id"] as? String ?? ""
                    print("Fetched Events!")
                    
                    return EventModel(dictionary: ["eventName":eventName,"eventLocation":eventLocation, "eventTime":eventTime, "usersVisibleTo":usersVisibleTo,"id":id])
                    
                    
                }
                
        }
        
        
        
        
        
    }
    
    
    func listenToAll(uid: String){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.listenToUserChats(uid: uid)
            self.listenToUserGroups(uid: uid)
            self.listenToUserPolls(uid: uid)
            self.listenToUserEvents(uid: uid)
        }
       
    }
    
    func fetchUserChats(){
        //TODO
        COLLECTION_CHAT.whereField("users", arrayContains: user?.id ?? "").getDocuments { (snapshot, err) in
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
            
            self.chats = documents.map{ queryDocumentSnapshot -> ChatModel in
                let data = queryDocumentSnapshot.data()
         

                
                

                return ChatModel(dictionary: data)
                
            }
            
            print("Fetched User Chats!")

            
        }
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
                let groupProfileImage = data["groupProfileImage"] as? String ?? ""
                let motd = data["motd"] as? String ?? "Welcome to the group!"
                let quoteOfTheDay = data["quoteOfTheDay"] as? String ?? ""

                
                

                return Group(dictionary: ["chatID":chatID,"groupName":groupName,"memberAmount":memberAmount,"memberLimit":memberLimit,"publicID":publicID,"users":users,"id":id,"groupProfileImage":groupProfileImage,"motd":motd,"quoteOfTheDay":quoteOfTheDay])
                
            }
            
            print("Fetched User Groups!")

            
        }
    }
    func fetchUserPolls(){
        //TODO
        //TODO
        COLLECTION_POLLS.whereField("users", arrayContains: user?.id ?? "").getDocuments { (snapshot, err) in
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
            
            self.polls = documents.map{ queryDocumentSnapshot -> PollModel in
                let data = queryDocumentSnapshot.data()
         

                
                

                return PollModel(dictionary: data)
                
            }
            
            print("Fetched User Polls!")

            
        }
    }
    
    func fetchUserEvents(){
        //TODO
        //TODO
        COLLECTION_EVENTS.whereField("usersVisibleTo", arrayContains: user?.id ?? "").getDocuments { (snapshot, err) in
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
            
            self.events = documents.map{ queryDocumentSnapshot -> EventModel in
                let data = queryDocumentSnapshot.data()
         

                
                

                return EventModel(dictionary: data)
                
            }
            
            print("Fetched User Events!")

            
        }
    }
    func fetchAll(){
        fetchUserChats()
        fetchUserGroups()
        fetchUserPolls()
        fetchUserEvents()
    }
    
    
    
    func createUser(email: String, password: String, username: String, nickName: String, birthday: Date, image:UIImage){
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            if let err = err{
                print("DEBUG: ERROR: \(err.localizedDescription)")
                return
            }
            
            guard let user = result?.user else {return}
            
            let data = ["email": email,
                        "username": username,
                        "nickName": nickName,
                        "uid": user.uid,
                        "birthday": birthday,"profilePicture":"", "friendsList": []
                        
            ] as [String : Any]
            
            COLLECTION_USER.document(user.uid).setData(data)
            
            
            self.persistImageToStorage(userID: user.uid, image: image)
            
            self.listenToAll(uid: user.uid)
            print("DEBUG: Succesfully uploaded user data!")

            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.userSession = user
                self.fetchUser()
            }
            Auth.auth().currentUser?.sendEmailVerification(completion: { (err) in
                
            })
            
            
        }
    }
    
    
    func signIn(withEmail email: String, password: String){
        
        Auth.auth().signIn(withEmail: email, password: password) { [self] (result,err) in
            
            if let x = err {
                  let error = x as NSError
                  switch error.code {
                  case AuthErrorCode.networkError.rawValue:
                      loginErrorMessage = "There was a network error"
                  case AuthErrorCode.internalError.rawValue:
                      loginErrorMessage = "There was an internal error"
                  case AuthErrorCode.invalidEmail.rawValue:
                        loginErrorMessage = "This email address is invalid"
                  case AuthErrorCode.missingEmail.rawValue:
                        loginErrorMessage = "You must include an email address"
                  case AuthErrorCode.rejectedCredential.rawValue:
                    loginErrorMessage = "The email or password is incorrect"
                    
                  default:
                      loginErrorMessage = "loves"
                  }
            }else{
                print("You are connected")
            }
            
            self.userSession = result?.user
            self.fetchUser()
            self.listenToAll(uid: userSession!.uid)
        }
        
    }
    
    func signOut(){
        userSession = nil
        self.loginErrorMessage = ""
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
