//
//  MessageListView.swift
//  TopSecret
//
//  Created by Bruce Blake on 8/31/21.
//

import SwiftUI

struct MessageListView: View {
    
    @State var selectedIndex = 0
    @State private var options = ["Groups","Friends"]
    @State var goNext: Bool = false
    @State var showAddChat = false
    @ObservedObject var groupVM = GroupViewModel()
    @EnvironmentObject var userVM : UserAuthViewModel
    var body: some View {
        
        
        
        ZStack{
            Color("Background")


            if userVM.user?.chats.count != 0{
                VStack{
                    VStack{
                        HStack{
                            Button(action:{
                                //TODO
                            },label:{
                                Image(systemName: "gear").resizable().frame(width: 32, height:32).accentColor(Color("AccentColor"))
                            }).padding(.leading,20)
                            Spacer()

                            Text("Messages").font(.largeTitle).fontWeight(.bold)

                            Spacer()
                            Button(action:{
                                //TODO
                                self.showAddChat.toggle()
                            },label:{
                                Image(systemName: "plus.message")
                            }).padding(.trailing,20)
                            .sheet(isPresented: $showAddChat, content: {
                                
                            })
                        }
                    }.padding(.top,50)
                    VStack{
                        Picker("Options",selection: $selectedIndex){
                            ForEach(0..<options.count){ index in
                                Text(self.options[index]).tag(index)
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                        Spacer()
                        ScrollView(showsIndicators: false){
                            ForEach(userVM.user?.chats ?? [], id: \.id){ chat in
                                NavigationLink(
                                    destination: ChatView(chat: chat),
                                    label: {
                                        ChatListCell(chat: chat)
                                    })
                            }

                            Button(action: {
                                userVM.fetchChats()
                            }, label: {
                                Text("Refresh")
                            })
                        }
                    }
                    .padding(.top,50)
                }
            }

            else{
                VStack{
                    VStack{
                        HStack{
                            Button(action:{
                                //TODO
                            },label:{
                                Image(systemName: "gear").resizable().frame(width: 32, height:32).accentColor(Color("AccentColor"))
                            }).padding(.leading,20)
                            Spacer()

                            Text("Messages").font(.largeTitle).fontWeight(.bold)

                            Spacer()
                            Button(action:{
                                //TODO
                            },label:{
                                Image(systemName: "plus.message")
                            }).padding(.trailing,20)
                        }
                    }.padding(.top,50)
                    Spacer()
                    Text("It looks like you don't have any chats!")
                        .padding(.top,50)
                    Spacer()
                }

            }

         

        }.edgesIgnoringSafeArea(.all)
        .onAppear{
            self.groupVM.setupUserVM(self.userVM)
        
        }
       

    }
}


struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView().preferredColorScheme(.dark)
    }
}

