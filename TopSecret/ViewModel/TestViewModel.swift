//
//  TestViewModel.swift
//  TopSecret
//
//  Created by Bruce Blake on 9/14/21.
//

import Foundation
import Firebase

class TestViewModel: ObservableObject {
    @Published var testModels : [TestModel] = []
    
    func get(){
        Firestore.firestore().collection("test").addSnapshotListener { (querySnapshot, err) in
            if let err = err{
                print("Error")
                return
            }
                
            
        }
    }
    
    
    
}
