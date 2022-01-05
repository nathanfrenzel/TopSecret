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
    var name : String
    var groupName : String
    var dateCreated : Timestamp
    var question : String
    @State var answered : Bool = false
    
    var body: some View {
       
        VStack{
            
            VStack{
                HStack(alignment: .center){
                    Text(groupName).foregroundColor(Color("Foreground")).fontWeight(.bold)
                    
                    Text("• \(name)   ").foregroundColor(.gray)
                    
                    Text(dateCreated.dateValue(), style: .time).foregroundColor(.gray)
                }
                
                
                VStack{
                    Text(question).foregroundColor(Color("Foreground")).lineLimit(20)
                }
                .padding()
              
            }
            HStack{
                Spacer()
            }
        
        }.padding().background(       RoundedRectangle(cornerRadius: 20).fill(Color("Color"))).padding(.horizontal)
        }
    }


struct PollCell_Previews: PreviewProvider {
    static var previews: some View {
        PollCell(name: "jesusnogs", groupName: "Laotians", dateCreated: Timestamp(), question: "Where should we skate today?", answered: false).preferredColorScheme(.dark)
    }
}
