//
//  UserSearchCell.swift
//  TopSecret
//
//  Created by Bruce Blake on 1/3/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserSearchCell: View {
    var user: User
    var body: some View {
     
            VStack(alignment: .leading){
                HStack(alignment: .center){
                    WebImage(url: URL(string: user.profilePicture ?? ""))
                        .resizable()
                        .scaledToFill()
                        .frame(width:48,height:48)
                        .clipShape(Circle())
                        
                    
                    VStack(alignment: .leading){
                        
                        Text("\(user.nickName ?? "")").foregroundColor(Color("Foreground"))
                        

                        Text("\(user.username ?? "")").font(.subheadline).foregroundColor(.gray)
                    }
                    Spacer()
                }.padding([.leading,.vertical])
                Divider()
            }
        .edgesIgnoringSafeArea(.all)
    }
}

//struct UserSearchCell_Previews: PreviewProvider {
//    static var previews: some View {
//        UserSearchCell()
//    }
//}
