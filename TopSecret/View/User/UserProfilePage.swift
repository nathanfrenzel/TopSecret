//
//  UserProfilePage.swift
//  TopSecret
//
//  Created by Bruce Blake on 1/3/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserProfilePage: View {
    @State var user: User
    @State var goToUserInfoPage : Bool = false
    @State var settingsOpen: Bool = false
    @State var showEditProfile: Bool = false
    @State var goToPersonalChat: Bool = false
    @State var personalChat: ChatModel = ChatModel()
    
    @StateObject var chatVM = ChatViewModel()
    @EnvironmentObject var userVM: UserViewModel
    @Environment(\.presentationMode) var presentationMode
    
    
    @State private var options = ["Gallery","Groups","Friends"]
    
    @State var selectedIndex = 0
    
    var body: some View {
        ZStack{
            Color("Background")
            VStack{
                HStack(alignment: .center,spacing:35){
                    Button(action:{
                        presentationMode.wrappedValue.dismiss()
                    },label:{
                        ZStack{
                        Circle().foregroundColor(Color("Color")).frame(width: 32, height: 32)
                        
                            Image(systemName: "chevron.left")
                            .font(.title3).foregroundColor(FOREGROUNDCOLOR)
                        }
                    }).padding(.leading)
                    
                    Spacer()
                    
                    Button(action:{
                        
                    },label:{
                      
                        Text("\(user.nickName ?? "") ").fontWeight(.bold).font(.subheadline).lineLimit(1).foregroundColor(FOREGROUNDCOLOR)
                            
                          
                      
                    }).padding(.trailing)
                  
                    

                    
                    HStack(spacing: 15){
                        
                        if userVM.user?.id == user.id ?? "" {
                            Button(action:{
                                self.showEditProfile.toggle()
                            },label:{
                                ZStack{
                                    Circle().foregroundColor(Color("Color")).frame(width: 32, height: 32)
                                    
                                    
                                    Image(systemName: "pencil.circle").resizable().frame(width: 16, height: 16).foregroundColor(Color("Foreground"))
                                }
                            }).sheet(isPresented: $showEditProfile, content: {
                               UserEditProfilePageView()
                            })
                        }else{
                            Button(action:{
                                
                                
                                chatVM.createPersonalChat(user1: userVM.user?.id ?? "", user2: user.id ?? "") { personalChat in
                                    self.personalChat = personalChat
                                    self.goToPersonalChat.toggle()
                                }
                                

                                

                                
                                
                                
                                
                            },label:{
                                ZStack{
                                    Circle().foregroundColor(Color("Color")).frame(width: 32, height: 32)
                                    
                                    
                                    Image(systemName: "bubble.left").resizable().frame(width: 16, height: 16).foregroundColor(Color("Foreground"))
                                }

                            })
                            
                         
                        }
                        
                       
                        if userVM.user?.id == user.id ?? "" {
                            Button(action:{
                                //TODO
                                self.settingsOpen.toggle()
                            },label:{
                                ZStack{
                                    Circle().foregroundColor(Color("Color")).frame(width: 32, height: 32)
                                    
                                    Image(systemName: "gear")
                                        .resizable()
                                        .frame(width: 16, height: 16).foregroundColor(Color("Foreground"))
                                    
                                    
                                }
                            }).sheet(isPresented: $settingsOpen, content: {
                                SettingsMenuView()
                            })
                        }else{
                            Button(action:{
                                self.goToUserInfoPage.toggle()
                            },label:{
                                ZStack{
                                    Circle().foregroundColor(Color("Color")).frame(width: 40, height: 40)
                                    
                                    
                                    Image(systemName: "info.circle").resizable().frame(width: 24, height: 24).foregroundColor(Color("Foreground"))
                                }
                            })
                            .sheet(isPresented: $goToUserInfoPage, content: {
                                let _friendsList = userVM.user?.friendsList ?? []
                                
                                UserInfoView(user: user, isFriends: _friendsList.contains(user.id ?? ""))
                            })
                        }
                    }
                }.padding(.trailing).padding(.top,40)
                ScrollView{
                VStack(spacing: 10){
                    
                    WebImage(url: URL(string: user.profilePicture ?? ""))
                        .resizable()
                        .scaledToFill()
                        .frame(width:80,height:80)
                        .clipShape(Circle())
                    
                       
                    
                    
                    HStack{
                        
                        Text("@\(user.username ?? "")").foregroundColor(.gray).font(.caption)
                        
                        
                    
                        
                        
                            var friendsList = userVM.user?.friendsList ?? []
                        if userVM.user?.id != user.id ?? ""{
                             if friendsList.contains(user.id ?? ""){
                            
                                Text("Friends").foregroundColor(.gray).font(.caption)
                             }else{
                                Button(action:{
                                    //TODO
                                    userVM.addFriend(userID: userVM.user?.id ?? "", friendID: user.id ?? "")
                                   
                                },label:{
                                    Text("Add Friend?").font(.caption2)
                                })
                             }
                        
                        }
                    }
                  
                    
                    
                    
                  
                    
                    
                    
                    
                    
                    
                    Text("\(user.bio ?? "")")
                    
                    
                }
                Divider()
                VStack{
                    Picker("Options",selection: $selectedIndex){
                        ForEach(0..<options.count){ index in
                            Text(self.options[index]).tag(index)
                        }
                    }.pickerStyle(SegmentedPickerStyle()).padding()
                    //List of groups
                    if selectedIndex == 0 {
                        VStack{
                            
                        }
                    }else if selectedIndex == 1{
                        //Groups
                        VStack{
                            
                        }
                    }else {
                        
                        
                        //Friends
                        VStack{
                            
                            UserFriendsListView(user: user)
                            
                            
                        }
                        
                    }
                        
                    
                }
                Spacer()
            }
                NavigationLink(
                    destination: PersonalChatView(goBack: $goToPersonalChat, chat: self.personalChat, user2: user),
                    isActive: $goToPersonalChat,
                    label: {
                        EmptyView()
                    })
        }
        }.edgesIgnoringSafeArea(.all).navigationBarHidden(true)
        
        
    }
}


struct UserProfilePage_Previews: PreviewProvider {
    static var previews: some View {
        UserProfilePage(user: User(dictionary: ["username":"bj_lao","nickName":"camilo","bio":"16","profilePicture":"https://firebasestorage.googleapis.com/v0/b/top-secret-dcb43.appspot.com/o/userProfileImages%2FdEUxJX1gXZcYViXUyLJTr0wf5RM2?alt=media&token=68acfeed-0dfb-496e-9929-82bdf70b1e80"]), personalChat: ChatModel()).environmentObject(UserViewModel()).colorScheme(.dark)
    }
}
