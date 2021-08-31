//
//  LoginViewModel.swift
//  TopSecret
//
//  Created by Bruce Blake on 8/18/21.
//

import Foundation
import SwiftUI
import Firebase


class UserAuthViewModel: ObservableObject {

    @Published var user: User?
    @Published var userSession: FirebaseAuth.User?
    @Published var email: String?
    @Published var password: String?
    @Published var username: String?
    @Published var fullName: String?
    @Published var birthday: Date?
    
    
    init(){
        userSession = Auth.auth().currentUser
//        fetchUser()
        
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
                        "birthday": birthday] as [String : Any]
            COLLECTION_USER.document(user.uid).setData(data){ _ in
                self.userSession = user
                self.fetchUser()
                print("DEBUG: Succesfully uploaded user data!")
            }
            
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
    
}
