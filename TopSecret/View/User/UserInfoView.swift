//
//  UserInfoView.swift
//  TopSecret
//
//  Created by Bruce Blake on 1/4/22.
//

import SwiftUI

struct UserInfoView: View {
    @State var user : User
    @State var isFriends : Bool = false
    @EnvironmentObject var userVM : UserViewModel
    var body: some View {
        ZStack{
            VStack{
                
                HStack(alignment: .center){
                    
                    
                    
                    
                    if !isFriends{
                        Button(action:{
                            //TODO
                            userVM.addFriend(userID: userVM.user?.id ?? "", friendID: user.id ?? "")
                            isFriends = true
                            
                        },label:{
                            Text("Add Friend?")
                        })
                    }else {
                        HStack{
                            Text("Friends").foregroundColor(.gray).font(.caption)
                            
                            Button(action:{
                                userVM.removeFriend(userID: userVM.user?.id ?? "", friendID: user.id ?? "")
                                isFriends = false
                            },label:{
                                Text("Remove Friend")
                            })
                        }
                        
                    }
                }
            }
        }
    }
}

//struct UserInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserInfoView()
//    }
//}
