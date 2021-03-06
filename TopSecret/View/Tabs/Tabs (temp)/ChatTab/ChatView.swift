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
    var isPersonal: Bool 
    var messageVM: ChatViewModel
    var chat: ChatModel
    @State var value: CGFloat = 0
    @State var text = ""
    
    var body: some View {
        
        ZStack(alignment: .topLeading){
            Color("Background")
            Button(action:{
                presentationMode.wrappedValue.dismiss()
            },label:{
                Text("Back")
            }).padding().padding(.top,30)
            VStack{
                VStack{
                    HStack{
                       Spacer()
                        Text("\(chat.name ?? "")")
                        Spacer()
                    }
                    Divider()
                }.padding(.top,60)
                ScrollView(showsIndicators: false){
                    ForEach(messageVM.messages){ message in
                        MessageCell(username: message.username ?? "", timeStamp: message.timeStamp ?? Date(), text: message.text ?? "")
                    }
                }
               
                VStack{
                    Divider()
                HStack{
                   
                    TextField("message", text: $text)
                    Button(action:{
                        messageVM.sendMessage(message: Message(dictionary: ["text":text,"username":userVM.user?.username ?? "","timeStamp":Date()]), chatID: chat.id )
                        text = ""
                  
                    },label:{
                        Text("Send")
                    })
                }.padding()}.padding(.bottom,10).background(Color("Background"))
                .offset(y: -self.value)
                .animation(.spring())
                .onAppear{
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (noti) in
                        let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                        let height = value.height
                        self.value = height
                    }
                    
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
                   
                        self.value = 0
                    }
                }
                
                
            }.padding(.top,20)
            .navigationBarHidden(true)
            
            
        }
        .onAppear{self.groupVM.setupUserVM(self.userVM)
           
//            self.messageVM.loadMessages(chatID: chat.id ?? " ")
            messageVM.readAllMessages(chatID: chat.id )
            print("read messages")
            
        }.edgesIgnoringSafeArea(.all)
    }
}

//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView(chat: ChatModel(dictionary: ))
//    }
//}
