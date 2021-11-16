//
//  ChatInfoView.swift
//  TopSecret
//
//  Created by Bruce Blake on 9/22/21.
//

import SwiftUI

struct ChatInfoView: View {
    var chat: ChatModel
    @ObservedObject var chatVM : ChatViewModel
    @ObservedObject var groupVM : GroupViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var messageNotificationsOn: Bool = false
    @State var pinnedMessageNotifactionsOn: Bool = false
    @EnvironmentObject var userVM : UserViewModel
    
    var body: some View {
        ZStack{
            Color("Background")
                VStack{
                    VStack{
                        Button("X"){
                            presentationMode.wrappedValue.dismiss()
                        }
                        
                        Text("\(chat.name!)")
                        
                    }.padding(.top,40)
                    VStack{
                        ZStack{
                            RoundedRectangle(cornerRadius: 20).foregroundColor(Color("LightBackground"))
                            VStack{
                                Text("\(chat.memberAmount) members")
                            ScrollView(showsIndicators: false){
                                ForEach(chatVM.userList, id: \.id){ user in
                                    GroupUsersListCell(user: user, isCurrentUser: user.id == userVM.user?.id, nameColor: chatVM.colors[chat.users.firstIndex(of: user.id) ?? 0])
                                }
                            }
                            }.padding()
                        }.padding(.horizontal,20)
                    }
                    VStack{
                        ZStack{
                            RoundedRectangle(cornerRadius: 20).foregroundColor(Color("LightBackground"))
                            VStack{
                                Text("Pinned Messages")
                            ScrollView(showsIndicators: false){
                               Text("Messages")
                            }
                            }.padding()
                        }.padding(.horizontal,20)
                    }
                    VStack{
                        ZStack{
                            RoundedRectangle(cornerRadius: 20).foregroundColor(Color("LightBackground"))
                            VStack{
                                Text("Notifications").padding(.top,5).font(.title)
                                Spacer()
                                HStack{
                                    Text("Messages")
                                    Spacer()
                                    Toggle(isOn: $messageNotificationsOn, label: {
                                        EmptyView()
                                    })
                                }
                                Divider()
                                HStack{
                                    Text("Pinned Messages")
                                    Spacer()
                                    Toggle(isOn: $pinnedMessageNotifactionsOn, label: {
                                        EmptyView()
                                    })
                                }
                                Spacer()
                            }.padding(.horizontal,20)
                        }.padding(.horizontal,20)
                    }
                    HStack{
                        Button(action:{
                            chatVM.leaveChat(chatID: chat.id, userID: userVM.user?.id ?? " ")
                          
                            presentationMode.wrappedValue.dismiss()
                        },label:{
                            Text("Leave Chat").foregroundColor(Color(.red))
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width/3).background(Color("LightBackground")).cornerRadius(15)
                        })
                        Button(action:{
                            
                        },label:{
                            Text("Leave Group").foregroundColor(Color(.red))
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width/3).background(Color("LightBackground")).cornerRadius(15)
                        })
                    }.padding()
                }.padding()
            
        }.edgesIgnoringSafeArea(.all)        .onAppear{
            for user in chat.users{
                self.chatVM.getUsers(userID: user ?? " ")
            }
        }
        
    }
}

//struct ChatInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatInfoView(chat: ChatModel())
//    }
//}
