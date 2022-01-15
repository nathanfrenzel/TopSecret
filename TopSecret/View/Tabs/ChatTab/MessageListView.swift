//
//  MessageListView.swift
//  TopSecret
//
//  Created by Bruce Blake on 8/31/21.
//

import SwiftUI

struct MessageListView: View {
    
    @EnvironmentObject var userVM : UserViewModel
    @StateObject var chatVM  = ChatViewModel()
    @StateObject var messageVM = MessageViewModel()
    @StateObject var groupVM = GroupViewModel()

    
    @State var selectedIndex = 0
    @State private var options = ["Groups","Friends"]
    
 
    
    var body: some View {
        
      
        ZStack{
            
            Color("Background")
            
            VStack{
            VStack{
                VStack{
                    HStack{
                        Button(action:{
                            //TODO
                            userVM.fetchUserChats()
                        },label:{
                            Image(systemName: "gear").resizable().frame(width: 32, height:32).accentColor(Color("AccentColor"))
                        }).padding(.leading,20)
                        Spacer()
                        
                        Text("Messages").font(.largeTitle).fontWeight(.bold)
                        
                        Spacer()
                        
                        NavigationLink(
                            destination: AddChatView(chatVM: chatVM),
                            label: {
                                Image(systemName: "plus.message")
                            }).padding(.trailing)
                       
                        
                    }.foregroundColor(FOREGROUNDCOLOR)
                }.padding(.top,50)
                
            }
            VStack{
                
            
                if userVM.groupChats.count != 0 || userVM.personalChats.count != 0{
                VStack{
                    Picker("Options",selection: $selectedIndex){
                        ForEach(0..<options.count){ index in
                            Text(self.options[index]).tag(index)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    Spacer()
                    ScrollView(showsIndicators: false){
                        if selectedIndex == 0{
                            ForEach(userVM.groupChats, id: \.id){ chat in
                                    NavigationLink(
                                        destination: ChatView(uid: userVM.user?.id ?? " ", chat: chat),
                                        label: {
                                            ChatListCell(chat: chat)
                                        })
                                    
                                    Divider()
                                
                            }
                            
                        }else{
                            ForEach(userVM.personalChats, id: \.id){ chat in
                                let id = userVM.user?.id ?? ""
                               NavigationLink(
                                destination: PersonalChatView(chat: chat),
                                label: {
                                    Text("\(id == chat.users[0] ? chat.users[1] : chat.users[0])")
                                })
                                Divider()
                            }
                            
                        }
                        
                        Button(action: {
                            userVM.fetchUserChats()
                            
                        }, label: {
                            Text("Refresh")
                        })
                        
                    }
                }
                .padding(.top,50)
            }
            
            else{
                VStack{
                  
                    Spacer()
                    Text("It looks like you don't have any chats!")
                        .padding(.top,50)
                    Spacer()
                }
                
            }
               

            
            }
            
        }
       
            
            
        }.navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
        
        
    }
}


struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView().preferredColorScheme(.dark)
    }
}

