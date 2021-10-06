//
//  PollCell.swift
//  TopSecret
//
//  Created by Bruce Blake on 10/4/21.
//

import SwiftUI
import Foundation
import Firebase

struct PollCell: View {
    var username : String
    var groupName : String
    var dateCreated : Timestamp
    var question : String
    @State var answered : Bool = false
    
    var body: some View {
       
        VStack{
            
            VStack{
                HStack(alignment: .center){
                    Text(groupName).foregroundColor(Color("Foreground")).fontWeight(.bold)
                    
                    Text("• @\(username)   ").foregroundColor(.gray)
                    
                    Text(dateCreated.dateValue(), style: .time).foregroundColor(.gray)
                }
                
                
                VStack{
                    Text(question).foregroundColor(Color("Foreground")).lineLimit(20)
                }
                .padding()
                if !answered{
                HStack(spacing: 10){
                    Button(action:{
                        self.answered.toggle()
                    },label:{
                        Text("Yes")
                    })
                    
                    Button(action:{
                        self.answered.toggle()
                    },label:{
                        Text("No")
                    })
                }.padding()
                }else{
                    HStack{
                        Text("This is the answer!")
                    }
            }
        
            }.padding().background(       RoundedRectangle(cornerRadius: 20).fill(Color("LightBackground"))).padding(.horizontal)
        }
    }
}

struct PollCell_Previews: PreviewProvider {
    static var previews: some View {
        PollCell(username: "jesusnogs", groupName: "Laotians", dateCreated: Timestamp(), question: "Where should we skate today?", answered: false).preferredColorScheme(.dark)
    }
}
