//
//  GroupUsersListCell.swift
//  TopSecret
//
//  Created by Bruce Blake on 9/24/21.
//

import SwiftUI
import SDWebImageSwiftUI


struct GroupUsersListCell: View {
    var user : User
    var isCurrentUser : Bool
    var nameColor : String
    var body: some View {
        ZStack{
            VStack{
            HStack{
                WebImage(url: URL(string: user.profilePicture ?? " "))
                    .resizable()
                    .scaledToFill()
                    .frame(width:30,height:30)
                    .clipShape(Circle())
                    .padding()
                VStack(alignment: .leading){
                    if isCurrentUser{
                    Text("\(user.fullname ?? "") \( "(Me)")").foregroundColor(Color(nameColor))
                    }else{
                        Text("\(user.fullname ?? "") ").foregroundColor(Color(nameColor))
                    }
                    Text("@\(user.username ?? "") ").foregroundColor(.gray).opacity(0.5)
                }
           
                Spacer()
                Button(action:{
                    
                },label:{
                    Text(">")
                }).padding(.trailing,30)
            }
            Divider()
            }
        }
    }
}

struct GroupUsersListCell_Previews: PreviewProvider {
    static var previews: some View {
        GroupUsersListCell(user: User(), isCurrentUser: false, nameColor: "red").preferredColorScheme(.dark)
    }
}
