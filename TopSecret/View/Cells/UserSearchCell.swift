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
                HStack{
                    WebImage(url: URL(string: user.profilePicture ?? ""))
                        .resizable()
                        .scaledToFill()
                        .frame(width:60,height:60)
                        .clipShape(Circle())
                        .padding(.top,10)
                    
                    VStack(alignment: .leading){
                        
                        Text("\(user.nickName ?? "")").foregroundColor(Color("Foreground"))
                        
                        Text("@\(user.username ?? "")").font(.caption).foregroundColor(.gray)
                    }
                    Spacer()
                }.padding(.leading)
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
