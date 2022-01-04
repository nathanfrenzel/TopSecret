//
//  UserProfilePage.swift
//  TopSecret
//
//  Created by Bruce Blake on 1/3/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserProfilePage: View {
    var user: User
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
                    
                    HStack(spacing: 10){
                        Button(action:{
                            
                        },label:{
                            Image(systemName: userVM.user?.id == user.id ?? "" ? "pencil.circle.fill" : "bubble.left.fill").resizable().frame(width: 32, height: 32)
                        })
                        Button(action:{
                            
                        },label:{
                            Image(systemName: "info.circle.fill").resizable().frame(width: 32, height: 32)
                        })
                    }
                }.padding(.top,50).padding(.horizontal)
                
                VStack(spacing: 10){
                    HStack{
                        WebImage(url: URL(string: user.profilePicture ?? ""))
                            .resizable()
                            .scaledToFill()
                            .frame(width:60,height:60)
                            .clipShape(Circle())
                        
                        if userVM.user?.id != user.id ?? "" {
                            Button(action:{
                                //TODO
                            },label:{
                                Text("Add Friend?")
                            })
                        }
                    }
                    
                    
                    HStack{
                        Text("@\(user.username ?? "")").foregroundColor(.gray).font(.caption)
                            
                        Text("\(user.nickName ?? "")").fontWeight(.bold)
                    }
                   
                        
                    
                    
                   
                    
                        Text("\(user.bio ?? "This is my bio")")

                    
                }
                Divider()
                HStack{
                    
                    Picker("Options",selection: $selectedIndex){
                        ForEach(0..<options.count){ index in
                            Text(self.options[index]).tag(index)
                        }
                    }.pickerStyle(SegmentedPickerStyle()).padding()
                    //List of groups
                    if selectedIndex == 0 {
                       
                    }else if selectedIndex == 1{
                        //Groups
                        
                    }else {
                        //Friends
                    }
                }
                Spacer()
            }
        }.edgesIgnoringSafeArea(.all).navigationBarHidden(true)
    }
}

struct UserProfilePage_Previews: PreviewProvider {
    static var previews: some View {
        UserProfilePage(user: User())
    }
}
