//
//  GroupRepository.swift
//  TopSecret
//
//  Created by Bruce Blake on 11/10/21.
//

import Foundation
import Combine
import SwiftUI
import Firebase

class GroupRepository : ObservableObject {
    
    @ObservedObject var chatRepository = ChatRepository()
    @ObservedObject var pollRepository = PollRepository()
    @ObservedObject var userRepository = UserRepository()
    @Published var groupChat : ChatModel = ChatModel()
    @Published var usersProfilePictures : [String] = []
    @Published var groupProfileImage = ""
    
    
    func changeMOTD(motd: String, groupID: String, userID: String){
        COLLECTION_GROUP.document(groupID).updateData(["motd":motd])
    }
    
    
    func getUsersProfilePictures(groupID: String){
        self.usersProfilePictures = []
        COLLECTION_GROUP.document(groupID).getDocument { (snapshot, err) in
            if err != nil {
                print("ERROR")
                return
            }
            let data = snapshot!.data()
            
            let users = data?["users"] as? [String] ?? []
            
            for user in users{
                COLLECTION_USER.document(user).getDocument { (snapshot, err) in
                    if err != nil{
                        print("ERROR")
                        return
                    }
                    self.usersProfilePictures.append(snapshot?.get("profilePicture")as! String)
                }
            }
            
        }
    }
    
    
    
//
//    func pickQuoteOfTheDay(chatID: String){
//        COLLECTION_CHAT.document(chatID).collection("Messages").getDocuments { (snapshot, err) in
//            if err != nil {
//                print("ERROR")
//                return
//            }
//            for document in snapshot!.documents{
//                document.get("text")
//            }
//        }
//    }
    
    

    
    func getChat(chatID: String){
        COLLECTION_CHAT.document(chatID).getDocument { (snapshot, err) in
            if err != nil{
                print("ERROR")
                return
            }
            let data = snapshot!.data()
            self.groupChat = ChatModel(dictionary: data!)
        }
    }
    
    func inviteToGroup(userID: String, groupID: String){
        
    }
    
    func joinGroup(groupID: String, username: String){
        
        
        let userQuery = COLLECTION_USER.whereField("username", isEqualTo: username)
          
        userQuery.getDocuments { (snapshot, err) in
            if err != nil {
                print("ERROR")
                return
            }
            
            if snapshot!.documents.isEmpty {
                print("There are no usernames with this text!")
            }else{
                for document in snapshot!.documents{
                    print("Username: \(document.get("username") as? String ?? "")")
                }
            }
            
            for document in snapshot!.documents{
                let data = document.data()
                let id = data["uid"] as? String ?? ""
                COLLECTION_GROUP.document(groupID).updateData(["users":FieldValue.arrayUnion([id])])
                COLLECTION_GROUP.document(groupID).updateData(["memberAmount":FieldValue.increment(Int64(1))])
                
                
                COLLECTION_GROUP.document(groupID).getDocument { (snapshot, err) in
                    
                    let data = snapshot!.data()
                    let chatID = data?["chatID"] as? String ?? ""
                    
                    self.chatRepository.joinChat(chatID: chatID, userID: id)

                }
            }
        }
            
       

       
    }
    
    func leaveGroup(groupID: String, userID: String){
        COLLECTION_GROUP.document(groupID).updateData(["memberAmount": FieldValue.increment(Int64(-1))])
        COLLECTION_GROUP.document(groupID).updateData(["users":FieldValue.arrayRemove([userID])])
        
        COLLECTION_GROUP.document(groupID).getDocument { (snapshot, err) in
            if err != nil{
                print("ERROR")
                return
            }
            let groupChatID = snapshot?.get("chatID") as? String ?? " "
            self.chatRepository.leaveChat(chatID: groupChatID, userID: userID)
            
            let users = snapshot?.get("users") as? [String] ?? []
            
            if users.count <= 0{

                
                COLLECTION_GROUP.document(groupID).collection("Polls").getDocuments { (snapshot, err) in
                    for document in snapshot!.documents{
                        let pollID = document.get("id") as! String
                        COLLECTION_GROUP.document(groupID).collection("Polls").document(pollID).delete()
                    }
                }
                COLLECTION_GROUP.document(groupID).delete() { err in
                    
                    if err != nil {
                        print("Unable to delete document")
                    }else{
                        print("sucessfully deleted document")
                    }
                    
                }
            }
        }
        

        

    }
    
    func createGroup(groupName: String, memberLimit: Int, dateCreated: Date,userID: String, image: UIImage){
        
        
        let id = UUID().uuidString
        
       

        let data = ["groupName" : groupName,
                    "memberLimit" : memberLimit,
                    "users" : [userID] ,
                    "memberAmount": 1, "id":id, "chatID": " ", "dateCreated":Timestamp(), "groupProfileImage": " "
        ] as [String:Any]
                
        COLLECTION_GROUP.document(id).setData(data) { (err) in
            if err != nil {
                print("ERROR \(err!.localizedDescription)")
                return
            }
            self.persistImageToStorage(groupID: id,image: image)
        }
        userRepository.fetchUserChats()
        chatRepository.createGroupChat(name: groupName, userID: userID, groupID: id)
        
    }
    func persistImageToStorage(groupID: String, image: UIImage) {
       let fileName = "groupImages/\(groupID)"
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
                COLLECTION_GROUP.document(groupID).updateData(["groupProfileImage":imageURL])
            }
        }
      
    }
//    func loadGroupProfileImage(groupID: String){
//        COLLECTION_GROUP.document(groupID).getDocument { (snapshot, err) in
//            if err != nil {
//                print("ERROR")
//                return
//            }
//            let image = snapshot?.get("groupProfileImage") as! String
//        }
//    }
}
