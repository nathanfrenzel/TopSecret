//
//  PollInfoCell.swift
//  TopSecret
//
//  Created by Bruce Blake on 1/13/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct PollInfoCell: View {
    
  
    
    //actual 
    var poll: PollModel
    
    var body: some View {
        ZStack{
            Color("Color")
            VStack(spacing: 5){
                
                HStack(alignment: .center){
                    Text("\(poll.groupName ?? "")").bold().font(.headline)
                    Text("*")
                    Text("\(poll.creator ?? "")").foregroundColor(.gray).font(.footnote)
                    Spacer()
                    Button(action:{
                        
                    },label:{
                        Image(systemName: "info.circle").frame(width: 30, height: 30)
                    })
                }.padding(.horizontal, 5)
              
                HStack{
                    Text("5/7 users voted")
                    Spacer()
                    Text("1/13/22")
                }.padding(.horizontal, 5).padding(.bottom,5)
                
                
            }.background(Rectangle().stroke(FOREGROUNDCOLOR, lineWidth: 2))
        }.edgesIgnoringSafeArea(.all).navigationBarHidden(true).frame(width: 300, height: 25)
    }
}

struct PollInfoCell_Previews: PreviewProvider {
    static var previews: some View {
        PollInfoCell(poll: PollModel()).colorScheme(.dark)
    }
}

struct PollInfoCellTop : View {
    
    var body: some View {
        HStack{
            Text("4 hours left")
        }.background(RoundedRectangle(cornerRadius: 16).stroke(Color("AccentColor")))
    }
}
