//
//  HomescreenGroupCell.swift
//  TopSecret
//
//  Created by Bruce Blake on 11/22/21.
//

import Foundation
import SwiftUI


struct HomescreenGroupCell : View {
    
    var groupName: String
    var memberAmount: Int
    var motd : String
    
    var body : some View {
        ZStack{
            VStack(alignment: .leading){
              
                HStack(alignment: .top){
                   Spacer()
                    Text(groupName)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(FOREGROUNDCOLOR)
                        .padding(.top,4)
                        .padding()
                    Image("Icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 65,height:65)
                        .padding()
                    Spacer()
                }
                
                HStack(alignment: .center){
                    Text(motd)
                        .padding(.bottom,10)
                        .foregroundColor(BACKGROUNDCOLOR)
                }.padding(.leading)
                
                HStack{
                       
                           
                        Text("\(memberAmount) members")
                            .padding(.leading,15)
                            .padding(.bottom,10)
                            .foregroundColor(FOREGROUNDCOLOR)
                          
                }
                
              
            
            }
        }.background(Color.purple).cornerRadius(12).shadow(color: .purple, radius: 6, x: 0.0, y: 0.0)
    }
}




struct HomescreenGroupCell_Previews: PreviewProvider {
    static var previews: some View {
        HomescreenGroupCell(groupName: "Laotians", memberAmount: 24, motd: "Camilo is a furry")
    }
}
