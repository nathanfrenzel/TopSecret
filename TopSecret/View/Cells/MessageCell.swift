//
//  MessageCell.swift
//  TopSecret
//
//  Created by Bruce Blake on 9/5/21.
//

import SwiftUI

struct MessageCell: View {
    var username: String
    var timeStamp: Date
    var text: String
    
    var body: some View {
        HStack{
            Circle()
                .frame(width:50,height:50).foregroundColor(Color("AccentColor"))
            VStack(alignment: .leading){
                HStack{
                    Text("\(username)")
                    Text("*")
                    Text("\(timeStamp, style: .time)")
                    Spacer()
                    Button(action:{
                        
                    },label:{
                        Text("---")
                    }).padding(.trailing,10)
                }
                Text("\(text)")
            }
        }
    }
}

//struct MessageCell_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageCell()
//    }
//}
