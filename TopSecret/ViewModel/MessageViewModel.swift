//
//  MessageViewModel.swift
//  TopSecret
//
//  Created by Bruce Blake on 11/10/21.
//

import Foundation
import Firebase
import Combine
import SwiftUI

class MessageViewModel : ObservableObject {
    @Published var messages : [Message] = []
    
    @Published var messageRepository = MessageRepository()
    private var cancellables : Set<AnyCancellable> = []
    
    init(){
        messageRepository.$messages
            .assign(to: \.messages, on: self)
            .store(in: &cancellables)
    }
    
    func readAllMessages(chatID: String){
        messageRepository.readAllMessages(chatID: chatID)
    }
    
    func sendMessage(message: Message, chatID: String){
        messageRepository.sendMessage(message: message, chatID: chatID)
    }
    
    
    
}
