//
//  AddChatView.swift
//  TopSecret
//
//  Created by Bruce Blake on 9/17/21.
//

import SwiftUI

struct AddChatView: View {
    @EnvironmentObject var userVM: UserViewModel

    
    @State var name: String = ""
    @Environment(\.presentationMode) var dismiss

    var chatVM : ChatViewModel
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
                
                
                Button(action:{
                 //TODO
                    userVM.fetchUserChats()
                },label:{
                    Text("Create Chat")
                })
            }
        }
    }
}

//struct AddChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddChatView()
//    }
//}
