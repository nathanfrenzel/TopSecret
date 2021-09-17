//
//   MessageModel.swift
//  TopSecret
//
//  Created by Bruce Blake on 9/5/21.
//

import Foundation
import SwiftUI


struct Message : Identifiable{
    var id: String
    var text : String?
    var timeStamp : Date?
    var username : String?
    
    
    init(dictionary: [String:Any]){
        self.text = dictionary["text"] as? String ?? " "
        self.timeStamp = dictionary["timeStamp"] as? Date ?? Date()
        self.username = dictionary["username"] as? String ?? " "
        self.id = dictionary["id"] as? String ?? " "
    }
    init(){
        self.id = UUID().uuidString
    }
  
    
   
    
}


