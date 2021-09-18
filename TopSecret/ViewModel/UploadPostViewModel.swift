//
//  UploadPostViewModel.swift
//  TopSecret
//
//  Created by nathan frenzel on 9/5/21.
//

import SwiftUI
import Firebase

class UploadPostViewModel: ObservableObject {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel = HomeScreenViewModel()
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    func uploadPost(caption: String, groupName: String) {
        guard let user =  UserAuthViewModel.shared.user else { return }
        let docRef = COLLECTION_POST.document()
        
        let data: [String: Any] = ["uid": user.id,
                                   "caption": caption,
                                   "fullname": user.fullname,
                                   "timestamp": Timestamp(date: Date()),
                                   "username": user.username,
                                   "groupname": groupName,
                                   "likes": 0,
                                   "id": docRef.documentID  ]
        
        docRef.setData(data) { _ in
            print("DEBUG: Successfully uploaded tweet..")
            self.isPresented = false
        }
    }
}


