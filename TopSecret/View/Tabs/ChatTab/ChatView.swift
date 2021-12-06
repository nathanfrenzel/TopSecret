//
//  ChatView.swift
//  TopSecret
//
//  Created by Bruce Blake on 8/31/21.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI
struct ChatView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userVM : UserViewModel
    
    @StateObject var chatVM = ChatViewModel()
    @StateObject var messageVM = MessageViewModel()
    @StateObject var groupVM = GroupViewModel()
    
    @State var value: CGFloat = 0
    @State var text = ""
    @State var infoScreen: Bool = false
    @State var showOverlay: Bool = false

    var uid: String
    var chat: ChatModel
   

    
    var body: some View {
        
        
        ZStack(alignment: .topLeading){
            Color("Background")
            Button(action:{
                chatVM.exitChat(userID: uid, chatID: chat.id)
                presentationMode.wrappedValue.dismiss()
            },label:{
                Text("Back")
            }).padding().padding(.top,30)
            
            ZStack{
            VStack{
                
                  
                    HStack{
                       Spacer()
                       
                        VStack{
                            WebImage(url: URL(string: chatVM.group.groupProfileImage ?? ""))
                                .resizable()
                                .scaledToFill()
                                .frame(width:75,height:75)
                                .clipShape(Circle())
                                .padding()
                            Text("\(chat.name ?? "")")
                            Text("\(chat.memberAmount) members").foregroundColor(.gray).opacity(0.5)
                        }.padding(.leading,10)

                          Spacer()
                        
                         Button(action:{
                             infoScreen.toggle()
                         },label:{
                             Text("Info")
                         }).fullScreenCover(isPresented: $infoScreen, content: {
                            ChatInfoView(chat: chat, chatVM: chatVM, groupVM: groupVM)
                         }).padding(.trailing,20).padding(.top,20)
                        
                    }.padding(.top,20)
                    Divider()
                
                ScrollView(showsIndicators: false){
                    ForEach(messageVM.messages){ message in
                        MessageCell(username: message.username ?? "", profilePicture: message.profilePicture ?? "", timeStamp: message.timeStamp ?? Timestamp(), nameColor: message.nameColor ?? "red", showOverlay: $showOverlay, text: message.text ?? "")
                    }
                    
                }
               
                VStack{
                    HStack{
                        Spacer()
                        ForEach(chatVM.usersIdlingList){ user in
                            ChatUsersIdlingCell(userProfileURL: user.profilePicture!)
                        }
                    }.padding(.bottom,5)
                    HStack{
                        Button(action:{
                            
                        },label:{
                            Text("Image")
                        })
                        Spacer()
                        Button(action:{
                            
                        },label:{
                            Text("Poll")
                        })
                        Spacer()
                        Button(action:{
                            
                        },label:{
                            Text("Countdown")
                        })
                    }.padding(.horizontal)
                    Divider()
                HStack{
                   
                    TextField("message", text: $text)
                    Button(action:{
                        
                        messageVM.sendMessage(message: Message(dictionary: ["text":text,"username":userVM.user?.username ?? "","timeStamp":Date(), "nameColor":chatVM.colors[chat.users.firstIndex(of: uid) ?? 0], "id":UUID().uuidString,"profilePicture":userVM.user?.profilePicture ?? ""]), chatID: chat.id)
                        
                        text = ""
                        
                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (noti) in
                            let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                            let height = value.height
                            self.value = height
                        }
                        
                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
                       
                            self.value = 0
                        }
                  
                    },label:{
                        Text("Send")
                    }).disabled(text == "")
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
                if showOverlay {
                    
                    MessagePopup(isPresented: showOverlay)
                }
            }
            
        }
        .onAppear{
            
            messageVM.readAllMessages(chatID: chat.id )
            chatVM.getGroup(groupID: chat.groupID ?? "")
            chatVM.openChat(userID: uid, chatID: chat.id)
            chatVM.getUsersIdlingList(chatID: chat.id)
            
        }.edgesIgnoringSafeArea(.all)
    }
}

//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView(chat: ChatModel())
//    }
//}
