//
//  ChatInfoView.swift
//  TopSecret
//
//  Created by Bruce Blake on 9/22/21.
//

import SwiftUI

struct ChatInfoView: View {
    var chat: ChatModel
    @ObservedObject var chatVM = ChatViewModel()
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userVM : UserAuthViewModel
    
    var body: some View {
        ZStack{
            Color("Background")
            VStack{
                VStack{
                Button("X"){
                    presentationMode.wrappedValue.dismiss()
                }
                
                Text("\(chat.name!)")
                    Text("\(chat.memberAmount) members")
                }.padding(.top,40)
                VStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 20).foregroundColor(.black)
                        ScrollView(showsIndicators: false){
                            ForEach(chatVM.userList, id: \.id){ user in
                                GroupUsersListCell(user: user, isCurrentUser: true, nameColor: chatVM.colors[chat.users.firstIndex(of: user.id) ?? 0])
                            }
                        }.padding()

                    }.padding(.horizontal,40)
                }
            }
        }.edgesIgnoringSafeArea(.all)        .onAppear{
            self.chatVM.setupUserVM(userVM)
            for user in chat.users{
                self.chatVM.getUsers(userID: user ?? " ")
            }
        }
        
    }
}

struct ChatInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ChatInfoView(chat: ChatModel())
    }
}
