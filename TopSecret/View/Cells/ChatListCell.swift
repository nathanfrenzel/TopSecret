//
//  ChatListCell.swift
//  TopSecret
//
//  Created by Bruce Blake on 8/31/21.
//

import SwiftUI

struct ChatListCell: View {
    var chat : ChatModel
    var body: some View {
        HStack{
            VStack{
                //Profile Picture
                Circle()
                    .frame(width:50,height:50).foregroundColor(Color("AccentColor"))
            }.padding(.leading,10)
            
            VStack{
                HStack{
                    Text("\(chat.name ?? "")").fontWeight(.bold).foregroundColor(Color("Foreground"))
                    
              
            }.padding(.trailing,10)
        }
            Spacer()
    }
}
}
//struct ChatListCell_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatListCell(chat: ChatModel()).preferredColorScheme(.dark)
//    }
//}

