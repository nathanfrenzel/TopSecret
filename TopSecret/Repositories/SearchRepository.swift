//
//  SearchRepository.swift
//  TopSecret
//
//  Created by Bruce Blake on 1/3/22.
//

import SwiftUI
import Foundation
import Combine



class SearchRepository : ObservableObject {
    @Published var searchText : String = ""
    @Published var results : [User] = []
    @Published var returnedResults : [User] = []
    
    
    
    private var cancellables = Set<AnyCancellable>()
    
    
    init(){
        
       getUsers()
        
    
        $searchText
            .combineLatest($results)
            .map(filterUsers)
            .sink { [weak self](returnedResults) in
                self?.returnedResults = returnedResults
            }
            .store(in: &cancellables)
            
    }
    
    
    private func filterUsers(text: String, results: [User]) -> [User]{
       
        
        let lowercasedText = text.lowercased()
        
        return results.filter {
            let username = $0.username ?? ""
            let email = $0.email ?? ""
            let nickName = $0.nickName ?? ""
            
            return username.lowercased().contains(lowercasedText)  || email.lowercased().contains(lowercasedText)  || nickName.lowercased().contains(lowercasedText)
        }
    }

    
    private func getUsers(){
        COLLECTION_USER.getDocuments { (snapshot, err) in
            if err != nil {
                print("ERROR")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No document!")
                return
            }
            
            self.results = documents.map({ (queryDocumentSnapshot) -> User in
                let data = queryDocumentSnapshot.data()
                let birthday = data["birthday"] as? Date ?? Date()
                let email = data["email"] as? String ?? ""
                let nickName = data["nickName"] as? String ?? ""
                let profilePicture = data["profilePicture"] as? String ?? ""
                let uid = data["uid"] as? String ?? ""
                let username = data["username"] as? String ?? ""
                
                return User(dictionary: data)
            })
        }
    }
    
}
