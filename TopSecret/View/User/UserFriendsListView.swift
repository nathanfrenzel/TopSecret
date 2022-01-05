//
//  UserFriendsListView.swift
//  TopSecret
//
//  Created by Bruce Blake on 1/4/22.
//

import SwiftUI

struct UserFriendsListView: View {
    @State var friendsIDList: [String] = []
    @State var user: User
    @State var friendsList : [User] = []
    @EnvironmentObject var userVM: UserViewModel
    var body: some View {
        ScrollView(){
            VStack(alignment: .leading){
                   
                    VStack{
                        if self.friendsIDList.isEmpty{
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
            
            
        }.onAppear{
            userVM.getFriendsListString(userID: user.id ?? "") { list in
                self.friendsIDList = list
            }
            
            self.friendsList.removeAll()
            
            for user in friendsIDList {
                userVM.getUsersFriend(userID: user) { friend in
                    self.friendsList.append(friend)
                }
                
            }
        }
    }
}

//struct UserFriendsListView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserFriendsListView()
//    }
//}
