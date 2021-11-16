//
//  GroupListCell.swift
//  TopSecret
//
//  Created by Bruce Blake on 9/23/21.
//

import SwiftUI

struct GroupListCell: View {
  
    var group: Group
    
    var body: some View {
       
        HStack(alignment: .firstTextBaseline){
                Circle()
                    .frame(width:50,height:50).foregroundColor(Color("AccentColor"))
            Text(group.groupName).foregroundColor(Color("Foreground"))
            Spacer()
            Text("\(group.memberAmount)").foregroundColor(Color("Foreground"))
        }.padding(.horizontal)
        
    }
}

//struct GroupListCell_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupListCell()
//    }
//}
