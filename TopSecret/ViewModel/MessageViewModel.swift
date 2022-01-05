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
    @Published var pinnedMessage : PinnedMessageModel = PinnedMessageModel()

    
    
    @Published var messageRepository = MessageRepository()
    private var cancellables : Set<AnyCancellable> = []
    
    init(){
        messageRepository.$messages
            .assign(to: \.messages, on: self)
            .store(in: &cancellables)
        messageRepository.$pinnedMessage
            .assign(to: \.pinnedMessage, on: self)
            .store(in: &cancellables)
        
    }
    
    func readLastMessage() -> Message{
        return messageRepository.readLastMessage()
    }
    
    func readAllMessages(chatID: String){
        messageRepository.readAllMessages(chatID: chatID)
    }
    
    func sendMessage(message: Message, chatID: String){
        messageRepository.sendMessage(message: message, chatID: chatID)
    }
    
    func deleteMessage(chatID: String, messageID: String){
        messageRepository.deleteMessage(chatID: chatID, messageID: messageID)
    }
    
    func getPinnedMessage(chatID: String){
        messageRepository.getPinnedMessage(chatID: chatID)
    }
    
    func pinMessage(chatID: String, messageID: String, userID: String){
        messageRepository.pinMessage(chatID: chatID, messageID: messageID, userID: userID)
    }
    
    
    
}
