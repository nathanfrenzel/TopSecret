//
//  ChatView.swift
//  TopSecret
//
//  Created by Bruce Blake on 8/31/21.
//

import SwiftUI

struct ChatView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var groupVM = GroupViewModel()
    @EnvironmentObject var userVM : UserAuthViewModel
    @StateObject var messageVM  = ChatViewModel()
    var chat: ChatModel
    @State var text = ""
    
    var body: some View {
        
        ZStack{
            Color("Background")
            VStack{
                VStack{
                    HStack{
                        Button(action:{
                            presentationMode.wrappedValue.dismiss()
                        },label:{
                            Text("Back")
                        })
                        Text("\(chat.name ?? "")")
                        Spacer()
                    }.padding(.leading,20)
                    Divider()
                }.padding(.vertical,30)
                ScrollView(showsIndicators: false){
                    ForEach(messageVM.messages){ message in
                        MessageCell(username: message.username ?? "", timeStamp: message.timeStamp ?? Date(), text: message.text ?? "")
                    }
                }
                Divider()
                
                HStack{
                    TextField("message", text: $text)
                    Button(action:{
                        messageVM.sendMessage(message: Message(dictionary: ["text":text,"username":userVM.user?.username ?? "","timeStamp":Date()]), chatID: chat.id )
                        text = ""
                  
                    },label:{
                        Text("Send")
                    })
                }.padding().padding(.bottom,10)
                
                
            }.padding(.top,20)
            .navigationBarHidden(true)
            
            
        }
        .onAppear{self.groupVM.setupUserVM(self.userVM)
            self.messageVM.setupUserVM(self.userVM)
//            self.messageVM.loadMessages(chatID: chat.id ?? " ")
            self.messageVM.readAllMessages(chatID: chat.id )
            print("read messages")
            
        }.edgesIgnoringSafeArea(.all)
    }
}

//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView(chat: ChatModel(dictionary: ))
//    }
//}
