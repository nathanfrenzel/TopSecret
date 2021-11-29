//
//  GroupChatCell.swift
//  TopSecret
//
//  Created by Bruce Blake on 11/26/21.
//

import SwiftUI

struct GroupChatCell: View {
    var membersActive : Int
    var message: Message
    var body: some View {
        ZStack{
            Color("Background")
            VStack{
                Text("Chat")
                    .fontWeight(.bold)
                Text("@\(message.username ?? "") : \(message.text ?? "")")
                
                Text("\(membersActive) members active")
                
            }
        }
    }
}

//struct GroupChatCell_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupChatCell()
//    }
//}
