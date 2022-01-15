//
//  GroupProfileView.swift
//  TopSecret
//
//  Created by Bruce Blake on 9/23/21.
//

import SwiftUI

struct GroupHomeScreenView: View {
    
    @EnvironmentObject var userVM : UserViewModel
    @StateObject var groupVM = GroupViewModel()
    @StateObject var messageVM = MessageViewModel()
    @StateObject var searchRepository = SearchRepository()
    @State var _user: User = User()
    @State var openChat: Bool = false
    @State var goToUserProfile: Bool = false
    @State var text: String = ""
    
    var group : Group
    
    @Environment(\.presentationMode) var dismiss

    
    var body: some View {
        ZStack{
            Color("Background")
            VStack{
                HStack{
                    Button(action:{
                        dismiss.wrappedValue.dismiss()
                    },label:{
                        Text("Back")
                    }).padding(.leading)
                    
                    Spacer()
                    Text("\(group.groupName)")
                        .fontWeight(.bold)
                        .font(.title).lineLimit(1)
                    
                    Spacer()
                    
                        NavigationLink(
                            destination: GroupProfileView(group: group),
                            label: {
                                Image(systemName: "person.3.fill")
                            }).padding(.trailing)
                    
                }.padding(.top,50)
                
                Divider()
                HStack{
                    Text("Countdown")
                    Text("4 hours until event!")
                }
                Divider()
                HStack{
                    
                    Button(action:{
                        openChat.toggle()
                    },label:{
                        GroupChatCell(message: messageVM.readLastMessage(), chat: groupVM.groupChat)
                    })
                   
                
                }
                
                SearchBar(text: $searchRepository.searchText).padding()
                
                ScrollView(){
                    VStack(alignment: .leading){
                        VStack(alignment: .leading){
                            if !searchRepository.searchText.isEmpty{
                                Text("Users").fontWeight(.bold).foregroundColor(Color("Foreground")).padding(.leading)
                            }
                            VStack{
                                ForEach(searchRepository.returnedResults) { user in
                                    NavigationLink(
                                        destination: UserProfilePage(user: user, isCurrentUser: userVM.user?.id == user.id ?? ""),
                                        label: {
                                            UserSearchCell(user: user)
                                        })
                                }
                            }.background(Color("Color")).cornerRadius(12).padding(.horizontal)
                        }
                        
                        

                    }
                    
                    
                }
                
                Button(action:{
                    groupVM.joinGroup(groupID: group.id, username: searchRepository.searchText)
                },label:{
                    Text("Add User")
                })
                
                Spacer()
                
            }
            NavigationLink(destination: ChatView(uid: userVM.user?.id ?? "", chat: groupVM.groupChat), isActive: $openChat, label: {
                EmptyView()
            })
        }.edgesIgnoringSafeArea(.all).navigationBarHidden(true).onAppear{
            groupVM.getChat(chatID: group.chatID ?? "")
            messageVM.readAllMessages(chatID: group.chatID ?? "", userID: userVM.user?.id ?? "", chatType: "groupChat")
        }
    }
}

//struct GroupHomeScreenView_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupHomeScreenView(group: Group())
//    }
//}
