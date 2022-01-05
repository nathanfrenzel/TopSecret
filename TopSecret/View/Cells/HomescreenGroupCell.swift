//
//  HomescreenGroupCell.swift
//  TopSecret
//
//  Created by Bruce Blake on 11/22/21.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI


struct HomescreenGroupCell : View {
    
    @StateObject var groupVM = GroupViewModel()
    
    var group: Group
    @State var profilePicturesCount = 0
    
    var body : some View {
        
        VStack(alignment: .leading){
            
            
            
            
                HStack{
                    Spacer()
                    
                    
                }.padding(50).background(WebImage(url: URL(string: group.groupProfileImage ?? "")).resizable().scaledToFill())
             
            
            HStack(alignment: .top){
                
                VStack(alignment: .leading,spacing:10){
                    Text(group.groupName).font(.headline).bold().foregroundColor(FOREGROUNDCOLOR)
                    
                    HStack{
                        Text(group.motd)
                            .lineLimit(1)
                    }.foregroundColor(FOREGROUNDCOLOR)
                    
                    HStack{
                        Text("\(group.memberAmount) \(group.memberAmount == 1 ? "member" : "members")").foregroundColor(FOREGROUNDCOLOR)
                      
                        
                    }
                }
                
                Spacer(minLength: 0)
            }.padding(10).background(Rectangle().foregroundColor(Color("Color")))
            
            
        }.cornerRadius(10).onAppear{
            groupVM.getUsersProfilePictures(groupID: group.id)
        }.shadow(color: Color("Color"),radius: 3, x: 1, y: 1)
    }
}




struct HomescreenGroupCell_Previews: PreviewProvider {
    static var previews: some View {
        HomescreenGroupCell(group: Group()).colorScheme(.dark)
    }
}
