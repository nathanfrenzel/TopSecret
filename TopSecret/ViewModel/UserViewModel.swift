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
    @Published var chats: [ChatModel] = []
    @Published var polls: [PollModel] = []
    @Published var events: [EventModel] = []
    @Published var isConnected : Bool = false

    
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
        userRepository.$chats
            .assign(to: \.chats, on: self)
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
    
    func persistImageToStorage(userID: String, image: UIImage){
        userRepository.persistImageToStorage(userID: userID, image: image)
    }
}
