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
    @State var isShowingPhotoPicker:Bool = false
    @State var showImageSendView : Bool = false
    @State var avatarImage = UIImage(named: "Icon")!
    
    
    var uid: String
    var chat: ChatModel
    
    
    
    
    var body: some View {
        
        
        ZStack(alignment: .topLeading){
            Color("Background")
            
            
            ZStack{
                
                VStack{
                    
                    ScrollView(showsIndicators: false){
                        ScrollViewReader{ scrollViewProxy in
                            
                            VStack{
                                ForEach(messageVM.messages){ message in
                                    MessageCell(message: message, chatID: chat.id)
                                }
                                
                                HStack{Spacer()}.id("Empty")
                                
                            }.onReceive(messageVM.$scrollToBottom, perform: { _ in
                                withAnimation(.easeOut(duration: 0.5)) {
                                    scrollViewProxy.scrollTo("Empty", anchor: .bottom)
                                }
                            })
                            
                        }
                        
                        
                    }.padding(.top,50)
                    
                    VStack{
                        
                        Divider()
                        HStack{
                            
                            Button(action:{
                                self.isShowingPhotoPicker.toggle()
                            },label:{
                                ZStack{
                                    Circle().frame(width: 40, height: 40).foregroundColor(Color("Color"))
                                    Image(systemName: "photo.on.rectangle")
                                }
                            }).fullScreenCover(isPresented: $isShowingPhotoPicker, onDismiss: {
                                self.showImageSendView.toggle()
                            }, content: {
                                ImagePicker(avatarImage: $avatarImage, allowsEditing: false)
                                
                            })
                            
                            
                            TextField("message", text: $text).onChange(of: text, perform: { value in
                                if text == ""{
                                    chatVM.stopTyping(userID: uid, chatID: chat.id)
                                }else{
                                    chatVM.startTyping(userID: uid, chatID: chat.id)
                                }
                            }).padding(.vertical,10).padding(.leading,5).background(Color("Color")).cornerRadius(12).sheet(isPresented: $showImageSendView, content: {
                                ImageSendView(message: Message(dictionary: ["id":UUID().uuidString,"nameColor":chatVM.colors[chat.users.firstIndex(of: uid) ?? 0],"timeStamp":Timestamp(),"name":userVM.user?.nickName ?? "","profilePicture":userVM.user?.profilePicture ?? "","imageURL":"","messageType":"image"]), imageURL: avatarImage, chatID: chat.id)
                            })
                            
                            Button(action:{
                                
                                messageVM.sendTextMessage(text: text, name: userVM.user?.nickName ?? "", timeStamp: Timestamp(), nameColor: chatVM.colors[chat.users.firstIndex(of: uid) ?? 0], messageID: UUID().uuidString, profilePicture: userVM.user?.profilePicture ?? "", messageType: "text", chatID: chat.id)
                                
                                
                                
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
                        }.padding()
                        
                    }.padding(.bottom,10).background(Color("Background")).offset(y: -self.value)
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
                    
                }
                
                
            }.padding(.top,20)
            .navigationBarHidden(true)
            
            VStack{
                HStack{
                    
                    Spacer()
                    
                    Button(action:{
                        chatVM.exitChat(userID: uid, chatID: chat.id)
                        presentationMode.wrappedValue.dismiss()
                    },label:{
                        Text("Back")
                    })
                    
                    Text("Top Bar")
                    
                    Spacer()
                }.padding(.top,30)
                
                Divider()
            }.background(Color("Background")).padding(.bottom,50)
            
            
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear{
            
            messageVM.readAllMessages(chatID: chat.id )
            messageVM.getPinnedMessage(chatID: chat.id)
            chatVM.getGroup(groupID: chat.groupID ?? "")
            chatVM.openChat(userID: uid, chatID: chat.id)
            chatVM.getUsersIdlingList(chatID: chat.id)
            chatVM.getUsersTypingList(chatID: chat.id)
            
        }
    }
}



struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(uid: "", chat: ChatModel())
    }
}
