//
//  PollViewModel.swift
//  TopSecret
//
//  Created by Bruce Blake on 10/4/21.
//

import SwiftUI
import Firebase

class PollViewModel : ObservableObject{
    
    @EnvironmentObject var userVM: UserViewModel
    @Published var pollRepository = PollRepository()
    
    
    init(){
    }
    
    
    func createPoll(creator: String, question: String, group: Group){
        pollRepository.createPoll(creator: creator, question: question, group: group)
    }
    
    
    
    
    
    
}
