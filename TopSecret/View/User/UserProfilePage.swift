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
    @State var friendsList : [User] = []
    @State var goToUserInfoPage : Bool = false
    @EnvironmentObject var userVM: UserViewModel
    @Environment(\.presentationMode) var presentationMode

    
    @State private var options = ["Gallery","Groups","Friends"]
    
    @State var selectedIndex = 0
    
    var body: some View {
        ZStack{
            Color("Background")
            VStack{
                HStack{
                    Button(action:{
                        presentationMode.wrappedValue.dismiss()
                    },label:{
                        Text("<")
                            .font(.title2)
                    })
                    Spacer()
                    
                    HStack(spacing: 15){
                        Button(action:{
                            
                        },label:{
                            Image(systemName: userVM.user?.id == user.id ?? "" ? "pencil.circle" : "bubble.left").resizable().frame(width: 24, height: 24).foregroundColor(Color("Foreground"))
                        })
                        Button(action:{
                            self.goToUserInfoPage.toggle()
                        },label:{
                            Image(systemName: "info.circle").resizable().frame(width: 24, height: 24).foregroundColor(Color("Foreground"))
                        }).sheet(isPresented: $goToUserInfoPage, content: {
                            UserInfoView(user: user)
                        })
                    }.padding()
                }.padding(.horizontal).padding(.top,40)
                
                VStack(spacing: 10){
                    
                    
                        WebImage(url: URL(string: user.profilePicture ?? ""))
                            .resizable()
                            .scaledToFill()
                            .frame(width:60,height:60)
                            .clipShape(Circle())
                        
                       
                    
                    
                    
                        Text("@\(user.username ?? "")").foregroundColor(.gray).font(.caption)
                            
                    
                    
                    
                    HStack(alignment: .center){
                        
                        Text("\(user.nickName ?? "")").fontWeight(.bold)

                        
                        var friendsList = userVM.user?.friendsList ?? []
                        
                        if userVM.user?.id != user.id ?? "" && !friendsList.contains(user.id ?? ""){
                            Button(action:{
                                //TODO
                                userVM.addFriend(userID: userVM.user?.id ?? "", friendID: user.id ?? "")
                                
                            },label:{
                                Text("Add Friend?")
                            })
                        }else if friendsList.contains(user.id ?? ""){
                            Text("Friends").foregroundColor(.gray).font(.caption)
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
                            
                            UserFriendsListView(friendsList: self.friendsList)
                            
                           
                        }
                       
                    }
                }
                Spacer()
            }
        }.edgesIgnoringSafeArea(.all).navigationBarHidden(true).onAppear{
            self.friendsList.removeAll()
            for user in user.friendsList ?? [] {
                userVM.getUsersFriend(userID: user) { friend in
                    self.friendsList.append(friend)
                }

            }
        }
            
        
    }
}


struct UserProfilePage_Previews: PreviewProvider {
    static var previews: some View {
        UserProfilePage(user: User(dictionary: ["username":"bj_lao","nickName":"camilo","bio":"16","profilePicture":"https://firebasestorage.googleapis.com/v0/b/top-secret-dcb43.appspot.com/o/userProfileImages%2FdEUxJX1gXZcYViXUyLJTr0wf5RM2?alt=media&token=68acfeed-0dfb-496e-9929-82bdf70b1e80"])).environmentObject(UserViewModel()).colorScheme(.dark)
    }
}
