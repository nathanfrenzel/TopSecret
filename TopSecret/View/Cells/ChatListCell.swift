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
                    Text("@").foregroundColor(Color("AccentColor"))
                    Spacer()
                    Text("\(chat.memberAmount ?? 0) members").padding(.trailing,15).foregroundColor(Color.gray).font(.footnote)
              
            }.padding(.trailing,10)
        }
    }
}
}
//struct ChatListCell_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatListCell(chat: ChatModel()).preferredColorScheme(.dark)
//    }
//}

