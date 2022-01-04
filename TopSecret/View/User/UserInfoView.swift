//
//  UserInfoView.swift
//  TopSecret
//
//  Created by Bruce Blake on 1/4/22.
//

import SwiftUI

struct UserInfoView: View {
    @State var user : User
    @EnvironmentObject var userVM : UserViewModel
    var body: some View {
        ZStack{
            VStack{
                
                
                    Button(action:{
                        userVM.removeFriend(userID: userVM.user?.id ?? "", friendID: user.id ?? "")
                    },label:{
                        Text("Remove Friend")
                    })
//                    Button(action:{
//                        userVM.addFriend(userID: userVM.user?.id ?? "", friendID: user.id ?? "")
//                    },label:{
//                        Text("Add Friend")
//                    })
//
            }
        }
    }
}

//struct UserInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserInfoView()
//    }
//}
