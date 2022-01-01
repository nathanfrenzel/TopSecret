//
//   MessageModel.swift
//  TopSecret
//
//  Created by Bruce Blake on 9/5/21.
//

import Foundation
import SwiftUI
import Firebase


struct Message : Identifiable{
    var id: String
    var nameColor: String?
    var text : String?
    var timeStamp : Timestamp?
    var name : String?
    var profilePicture: String?
    
    
    init(dictionary: [String:Any]){
        self.text = dictionary["text"] as? String ?? " "
        self.timeStamp = dictionary["timeStamp"] as? Timestamp ?? Timestamp()
        self.name = dictionary["name"] as? String ?? " "
        self.profilePicture = dictionary["profilePicture"] as? String ?? " "
        self.id = dictionary["id"] as? String ?? " "
        self.nameColor = dictionary["nameColor"] as? String ?? " "
    }
    init(){
        self.id = UUID().uuidString
    }
  
    
   
    
}


