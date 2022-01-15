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
    var message: Message
    var chatID: String
    
    var body: some View {
        
           if message.messageType == "text" {
        
            HStack{
                WebImage(url: URL(string: message.profilePicture ?? ""))
                    .resizable()
                    .scaledToFill()
                    .frame(width:50,height:50)
                    .clipShape(Circle())
                    .padding()
                VStack(alignment: .leading){
                    HStack{
                        Text("\(message.name ?? "")").foregroundColor(Color(message.nameColor ?? ""))
                        Text("*")
                        Text("\(message.timeStamp?.dateValue() ?? Date(), style: .time)")
                        Spacer()
                        Menu(content:{
                            Button(action:{
                                messageVM.deleteMessage(chatID: chatID, message: message)
                            },label:{
                                Text("Delete")
                            })
                            
                            Button(action:{
                                
                            },label:{
                                Text("Edit")
                            })
                            
                            Button(action:{
                                messageVM.pinMessage(chatID: chatID, messageID: message.id, userID: userVM.user?.id ?? "")
                            },label:{
                                Text("Pin")
                            })
                        },label:{
                            Text("---")
                        }).padding(.trailing,10)
                        
                    }
                    
                    Text("\(message.text ?? "")")
                    
                    
                }
                
            }
           }
           else if message.messageType == "image"{
            HStack{
                WebImage(url: URL(string: message.profilePicture ?? ""))
                    .resizable()
                    .scaledToFill()
                    .frame(width:50,height:50)
                    .clipShape(Circle())
                    .padding()
                VStack(alignment: .leading){
                    HStack{
                        Text("\(message.name ?? "")").foregroundColor(Color(message.nameColor ?? ""))
                        Text("•")
                        Text("\(message.timeStamp?.dateValue() ?? Date(), style: .time)")
                        Spacer()
                        Menu(content:{
                            Button(action:{
                                messageVM.deleteMessage(chatID: chatID, message: message)
                            },label:{
                                Text("Delete")
                            })
                            
                            Button(action:{
                                
                            },label:{
                                Text("Edit")
                            })
                            
                            Button(action:{
                                messageVM.pinMessage(chatID: chatID, messageID: message.id, userID: userVM.user?.id ?? "")
                            },label:{
                                Text("Pin")
                            })
                        },label:{
                            Text("---")
                        }).padding(.trailing,10)
                        
                    }
                    
                    WebImage(url: URL(string: message.imageURL ?? ""))
                        .resizable().scaledToFit().frame(width:100, height: 100)
                    
                    
                }
                
            }
            
           }else if message.messageType == "deletedMessage"{
            HStack(spacing: 5){
                Text("\(message.name ?? "")").foregroundColor(Color(message.nameColor ?? ""))
                Text("deleted a chat!").foregroundColor(.gray)
            }
           }
            
      
        
        
        
        
        
        
        }
        
        
        
        
    
}

//struct MessageCell_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageCell()
//    }
//}
