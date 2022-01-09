//
//  UserViewModel.swift
//  TopSecret
//
//  Created by Bruce Blake on 11/9/21.
//

import Foundation
import Firebase
import SwiftUI
import Combine


class UserViewModel : ObservableObject {
    

    @Published var user : User?
    @Published var userSession : FirebaseAuth.User?
    @Published var userRepository = UserRepository()
    @Published var loginErrorMessage = ""
    @Published var email = ""
    @Published var username = ""
    @Published var nickName = ""
    @Published var password = ""
    @Published var birthday = Date()
    @Published var userProfileImage : UIImage = UIImage()
    @Published var groups: [Group] = []
    @Published var groupChats: [ChatModel] = []
    @Published var personalChats: [ChatModel] = []
    @Published var polls: [PollModel] = []
    @Published var events: [EventModel] = []
    @Published var isConnected : Bool = false
    @Published var firestoreListener : [ListenerRegistration] = []

    
    private var cancellables : Set<AnyCancellable> = []
    
    init(){
        userRepository.$user
            .assign(to: \.user, on: self)
            .store(in: &cancellables)
        userRepository.$userSession
            .assign(to: \.userSession, on: self)
            .store(in: &cancellables)
        userRepository.$groups
            .assign(to: \.groups, on: self)
            .store(in: &cancellables)
        userRepository.$groupChats
            .assign(to: \.groupChats, on: self)
            .store(in: &cancellables)
        userRepository.$polls
            .assign(to: \.polls, on: self)
            .store(in: &cancellables)
        userRepository.$events
            .assign(to: \.events, on: self)
            .store(in: &cancellables)
        userRepository.$isConnected
            .assign(to: \.isConnected, on: self)
            .store(in: &cancellables)
        userRepository.$loginErrorMessage
            .assign(to: \.loginErrorMessage, on: self)
            .store(in: &cancellables)
        userRepository.$firestoreListener
            .assign(to: \.firestoreListener, on: self)
            .store(in: &cancellables)
        userRepository.$personalChats
            .assign(to: \.personalChats, on: self)
            .store(in: &cancellables)
        
        
     
    }
    
    func fetchUserChats(){
        userRepository.fetchUserChats()
    }
    
    func fetchUserGroups() {
        userRepository.fetchUserGroups()
    }
    
    func fetchUserPolls() {
        userRepository.fetchUserPolls()
    }
    
    func fetchAll(){
        userRepository.fetchAll()
    }
    
    func listenToUserGroups(){
        userRepository.listenToUserGroups(uid: userSession!.uid)
    }
    func listenToUserChats(){
        userRepository.listenToUserChats(uid: userSession!.uid)
    }
    
    func listenToUserPolls(){
        userRepository.listenToUserPolls(uid: userSession!.uid)
    }
    func listenToUserEvents(){
        userRepository.listenToUserEvents(uid: userSession!.uid)
    }
    
    func listenToUserFriends(){
        userRepository.listenToUserFriends(uid: userSession!.uid)
    }
    func listenToAll(uid: String){
        userRepository.listenToAll(uid: uid)
    }
    
    func createUser(email: String, password: String, username: String, nickName: String, birthday: Date,image: UIImage){
        userRepository.createUser(email: email, password: password, username: username, nickName: nickName, birthday: birthday, image: image)
    }
    
    func resetPassword(email: String){
        userRepository.resetPassword(email: email)
    }
    
    
    func signIn(withEmail email: String, password: String){
        
        userRepository.signIn(withEmail: email, password: password)
        
    }
    
    func signOut(){
        userRepository.signOut()
    }
    
    func fetchUser(){
        userRepository.fetchUser()
    }
    
    func fetchUser(userID: String, completion: @escaping (User) -> ()) -> (){
        COLLECTION_USER.document(userID).getDocument { (snapshot, err) in
            if err != nil {
                print("ERROR")
                return
            }
            let data = snapshot!.data()
            
            return completion(User(dictionary: data!))
        }
    }
    
  
    
    func getUserFriendsList(user: User, completion: @escaping ([User]) -> () ) -> (){
        if !user.friendsList!.isEmpty{
           COLLECTION_USER.whereField("uid", in: user.friendsList ?? []).addSnapshotListener{ (snapshot, err) in
                if err != nil {
                    print("ERROR")
                    return
                }
                guard let documents = snapshot?.documents else {
                    print("No documents!")
                    return
                    
                }
            
          
                return completion(documents.map { (queryDocumentSnapshot) -> User in
                    let data = queryDocumentSnapshot.data()
                    return User(dictionary: data)
                })
                
                
                
            }
            
       


        }else{
            print("User has no friends!")
        }
     
        
    }
    
   
   
    
  
    
    func persistImageToStorage(userID: String, image: UIImage){
        userRepository.persistImageToStorage(userID: userID, image: image)
    }
    
    func addFriend(userID: String, friendID: String){
        userRepository.addFriend(friendID: friendID, userID: userID)
    }
    
    func removeFriend(userID: String, friendID: String){
        userRepository.removeFriend(friendID: friendID, userID: userID)
    }
    
    func changeBio(userID: String, bio: String){
        userRepository.changeBio(userID: userID, bio: bio)
    }
}
