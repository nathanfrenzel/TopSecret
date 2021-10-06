//
//  MessageCell.swift
//  TopSecret
//
//  Created by Bruce Blake on 9/5/21.
//

import SwiftUI
import Firebase

struct MessageCell: View {
    var username: String
    var timeStamp: Timestamp
    var nameColor: String
    @Binding var showOverlay: Bool
    var text: String
    
    var body: some View {
        HStack{
            Circle()
                .frame(width:50,height:50).foregroundColor(Color("AccentColor"))
            VStack(alignment: .leading){
                HStack{
                    Text("\(username)").foregroundColor(Color(nameColor))
                    Text("*")
                    Text("\(timeStamp.dateValue(), style: .time)")
                    Spacer()
                    Button(action:{
                        self.showOverlay.toggle()
                    },label:{
                        Text("---")
                    }).padding(.trailing,10)
                }
                Text("\(text)")
            }
            .overlay(MessagePopup(isPresented: showOverlay), alignment: .topTrailing)
        }
        
        
    }
}

//struct MessageCell_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageCell()
//    }
//}
