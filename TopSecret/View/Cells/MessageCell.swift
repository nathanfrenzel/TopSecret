//
//  MessageCell.swift
//  TopSecret
//
//  Created by Bruce Blake on 9/5/21.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct MessageCell: View {
    @StateObject var messageVM = MessageViewModel()
    @EnvironmentObject var userVM: UserViewModel
    var name: String
    var messageID: String
    var chatID: String
    var profilePicture: String
    var timeStamp: Timestamp
    var nameColor: String
    var text: String
    
    var body: some View {
        HStack{
            WebImage(url: URL(string: profilePicture))
                .resizable()
                .scaledToFill()
                .frame(width:50,height:50)
                .clipShape(Circle())
                .padding()
            VStack(alignment: .leading){
                HStack{
                    Text("\(name)").foregroundColor(Color(nameColor))
                    Text("*")
                    Text("\(timeStamp.dateValue(), style: .time)")
                    Spacer()
                    Menu(content:{
                        Button(action:{
                            messageVM.deleteMessage(chatID: chatID, messageID: messageID)
                        },label:{
                            Text("Delete")
                        })
                        
                        Button(action:{
                            
                        },label:{
                            Text("Edit")
                        })
                        
                        Button(action:{
                            messageVM.pinMessage(chatID: chatID, messageID: messageID, userID: userVM.user?.id ?? "")
                        },label:{
                            Text("Pin")
                        })
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
