//
//  ChatUsersIdlingCell.swift
//  TopSecret
//
//  Created by Bruce Blake on 12/5/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct ChatUsersIdlingCell: View {
    var userProfileURL : String
    
    var body: some View {
        HStack{
            WebImage(url: URL(string: userProfileURL))
                .resizable()
                .scaledToFill()
                .frame(width:30,height:30)
                .clipShape(Circle())            
        }
    }
}

//struct ChatUsersIdlingCell_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatUsersIdlingCell(userProfileURL: cock)
//    }
//}
