//
//  LoginViewModel.swift
//  TopSecret
//
//  Created by Bruce Blake on 8/18/21.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth


class UserAuthViewModel: ObservableObject {
    
    
    
    @Published var user: User?
    @Published var userSession: FirebaseAuth.User?
    @Published var email: String?
    @Published var password: String?
    @Published var username: String?
    @Published var fullName: String?
    @Published var birthday: Date?
    
    static let shared = UserAuthViewModel()
    
    init(){
        userSession = Auth.auth().currentUser
        fetchUser()
        
    }
    
    func registerUser(email: String, password: String, username: String, fullname: String, birthday: Date){
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
    
    func resetPassword(email: String){
        Auth.auth().sendPasswordReset(withEmail: email) { (err) in
            print("You have been sent an email to reset your password!")
        }
    }
    
    
    func signIn(withEmail email: String, password: String){
        
        Auth.auth().signIn(withEmail: email, password: password) { (result,err) in
            if let err = err {
                print("DEBUG: Failed to login: \(err.localizedDescription)")
                return
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
        COLLECTION_USER.document(uid).getDocument{ (snapshot, _) in
            guard let data = snapshot?.data() else {return}
            let user = User(dictionary: data)
            self.user = user
            print("Fetched User Data!")
        }
        
    }
    
    func fetchChats(){
        guard let uid = userSession?.uid  else{return}
        
        COLLECTION_CHAT.whereField("users", arrayContains: uid).getDocuments { (snapshot, err) in
            guard let documents = snapshot?.documents else{
                print("No documents")
                return
            }
            
            self.user?.chats = documents.map{ (queryDocumentSnapshot) -> ChatModel in
                let data = queryDocumentSnapshot.data()
               

                let chat = ChatModel(dictionary: data)
                
               
                print(chat.name ?? "no group")

                return chat

            }
            
        }
    }
    
    func fetchGroups(){
        guard let uid = userSession?.uid else {return}
        
        
        COLLECTION_GROUP.whereField("users", arrayContains: uid).getDocuments { (snapshot, err) in
            guard let documents = snapshot?.documents else{
                print("No documents")
                return
            }
            
            self.user?.groups = documents.map{ (queryDocumentSnapshot) -> Group in
                let data = queryDocumentSnapshot.data()
               

                let group = Group(dictionary: data)
                
                if group.memberAmount == 0{
                    COLLECTION_GROUP.document(group.id ?? "").delete() { err in
                        
                        if let err = err {
                            print("Unable to delete document")
                        }else{
                            print("sucessfully deleted document")
                        }
                        
                    }
                }

                return group
               

            }
            
        }
        

        
    }
}
