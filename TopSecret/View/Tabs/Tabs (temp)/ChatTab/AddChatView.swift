//
//  AddChatView.swift
//  TopSecret
//
//  Created by Bruce Blake on 9/17/21.
//

import SwiftUI

struct AddChatView: View {
    @State var name: String = ""
    @Environment(\.presentationMode) var dismiss

    @State var isPersonal: Bool = false
    @ObservedObject var chatVM = ChatViewModel()
    @EnvironmentObject var userVM: UserAuthViewModel
    var body: some View {
        ZStack{
            Color("Background")
            VStack{
                
                Button(action:{
                    dismiss.wrappedValue.dismiss()
                },label:{
                    Text("Back")
                })
                Spacer()
                TextField("name",text:$name)
                
            Toggle("isPersonal", isOn: $isPersonal)
                
                Button(action:{
                    chatVM.createChat(name: name, userID: userVM.user?.id ?? " ")
                    userVM.fetchChats()
                },label:{
                    Text("Create Chat")
                })
            }
        }.onAppear{
            self.chatVM.setupUserVM(userVM)
            
        }
    }
}

struct AddChatView_Previews: PreviewProvider {
    static var previews: some View {
        AddChatView()
    }
}
