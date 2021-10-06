//
//  PollViewModel.swift
//  TopSecret
//
//  Created by Bruce Blake on 10/4/21.
//

import SwiftUI
import Firebase

class PollViewModel : ObservableObject{
    
    var userVM: UserAuthViewModel?
  
    func setupUserVM(_ userVM: UserAuthViewModel){
        self.userVM = userVM
    }
    
    init(){
        listen()
    }
    
    func listen(){
        COLLECTION_POLLS.addSnapshotListener { (snapshot, err) in
            if err != nil{
                print("Error")
                return
            }
            for doc in snapshot!.documentChanges{
                if doc.type == .removed {
                    self.userVM?.user?.polls = []
                    for group in self.userVM?.user?.groups ?? [] {
                        COLLECTION_POLLS.whereField("groupID", isEqualTo: group.id).getDocuments { [self] (snapshot, err) in
                            if err != nil {
                                print("Error")
                                return
                            }
                            guard let documents = snapshot?.documents else{
                                print("No documents")
                                return
                            }
                            
                            for document in documents{
                                let data = document.data()
                                userVM?.user?.polls.append(PollModel(dictionary: data))
                            }

                        }
                    }
                    print("New Poll!")
                }
                if doc.type == .modified {
                    self.userVM?.user?.polls = []
                    for group in self.userVM?.user?.groups ?? [] {
                        COLLECTION_POLLS.whereField("groupID", isEqualTo: group.id).getDocuments { [self] (snapshot, err) in
                            if err != nil {
                                print("Error")
                                return
                            }
                            guard let documents = snapshot?.documents else{
                                print("No documents")
                                return
                            }
                            
                            for document in documents{
                                let data = document.data()
                                userVM?.user?.polls.append(PollModel(dictionary: data))
                            }

                        }
                    }
                    print("New Poll!")
                }
               
            }
        }
    }
    
   
    
    func createPoll(creator: String, question: String, group: Group){
        let id = UUID().uuidString
        let data = ["creator":creator,"question":question,"dateCreated":Date(),"id":id, "groupID":group.id, "groupName":group.groupName ] as [String : Any]
        COLLECTION_POLLS.document(id).setData(data) { (err) in
            if err != nil {
                print("ERROR")
                return
            }
            
        }
        COLLECTION_GROUP.document(group.id).updateData(["polls":FieldValue.arrayUnion([id])])
    }
}
