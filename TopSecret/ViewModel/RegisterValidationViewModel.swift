//
//  RegisterValidationViewModel.swift
//  TopSecret
//
//  Created by Bruce Blake on 11/18/21.
//

import Foundation
import Combine
import Firebase
import SwiftUI

class RegisterValidationViewModel : ObservableObject {
    @Published var validationMessage : String = ""
    @Published var username = ""
    @Published var password = ""
    
    private var cancellables : Set<AnyCancellable> = []
    
    private static let predicatePassword = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z]).{6,}$")
    private static let predicateEmail = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}")
    
    init(){
        
        
        
    }
    
    func checkPassword(){
        isPasswordValidPublisher
            .receive(on: RunLoop.main)
            .map{ validationMessage in
                
                switch validationMessage {
                case .passwordNotStrongEnough:
                    return "Your password is not strong enough!"
                case .valid:
                    return "Valid!"
                default:
                   return "fuck"
                }
                
                
                
            }
            .assign(to: \.validationMessage, on: self)
            .store(in: &cancellables)
    }
    
    
    func checkIfUsernameAvailable(username: String) -> Bool{
        var isAvailable = false
        
        COLLECTION_USER.whereField("username", isEqualTo: username).getDocuments { snapshot, err in
            if let err = err {
                print("Error getting document: \(err.localizedDescription)")
            }else if(snapshot?.isEmpty)!{
                isAvailable = true
            }else{
                isAvailable = false
            }
        }
        return isAvailable
    }
    
    
    private var isUsernameAvailablePublisher: AnyPublisher<Bool,Never>{
        $username
            .removeDuplicates()
            .map { username in
                return self.checkIfUsernameAvailable(username: username)
            }
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
        
    }
    
    private var isUsernameLongEnoughPublisher: AnyPublisher<Bool,Never> {
        $username
            .removeDuplicates()
            .map { username in
                return username.count >= 4
            }
            .debounce(for: 0.4, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    
    
    private var isPasswordValidPublisher: AnyPublisher<ValidationError, Never> {
        $password
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { if Self.predicatePassword.evaluate(with: $0){
                return ValidationError.valid
            }else{return ValidationError.passwordNotStrongEnough}
            }
            .eraseToAnyPublisher()
    }
    
    
    
}
