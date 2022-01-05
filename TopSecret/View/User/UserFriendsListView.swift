//
//  UserFriendsListView.swift
//  TopSecret
//
//  Created by Bruce Blake on 1/4/22.
//

import SwiftUI

struct UserFriendsListView: View {
    @State var friendsList: [User] = []
    @EnvironmentObject var userVM: UserViewModel
    var body: some View {
        ScrollView(){
            VStack(alignment: .leading){
                   
                    VStack{
                        if self.friendsList.isEmpty{
                            Text("0 friends :(")
                        }else{
                            ForEach(friendsList, id: \.self) { user in
                                NavigationLink(
                                    destination: UserProfilePage(user: user),
                                    label: {
                                        UserSearchCell(user: user)
                                    })
                               
                            }
                        }
                       
                    }.background(Color("Color")).cornerRadius(12).padding(.horizontal)
                
                
                

            }
            
            
        }
    }
}

//struct UserFriendsListView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserFriendsListView()
//    }
//}
