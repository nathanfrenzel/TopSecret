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
                        .font(.title)
                    
                    Spacer()
                    
                        NavigationLink(
                            destination: GroupProfileView(group: group),
                            label: {
                                Text("Group Profile")
                            }).padding(.trailing)
                    
                }.padding(.top,50)
                
                Divider()
                HStack{
                    Text("Countdown")
                    Text("4 hours until event!")
                }.padding(.vertical,20)
                Divider()
                HStack{
                    NavigationLink(
                        destination: ChatView(uid: userVM.user?.id ?? "", chat: groupVM.groupChat),
                        label: {
                            GroupChatCell(membersActive: 2,message: messageVM.readLastMessage())
                        })
                }.padding(.vertical,20)
                
                
                Text("Testing")
                
                Spacer()
                
            }
        }.edgesIgnoringSafeArea(.all).navigationBarHidden(true).onAppear{
            groupVM.getChat(chatID: group.chatID ?? "")
            messageVM.readAllMessages(chatID: group.chatID ?? "")
            
        }
    }
}

struct GroupHomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        GroupHomeScreenView(group: Group())
    }
}
