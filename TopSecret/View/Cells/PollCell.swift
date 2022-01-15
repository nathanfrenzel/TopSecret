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
    
    //used for testing
    var name : String
    var groupName : String
    var dateCreated : Timestamp
    var question : String
    
    //actual
    var poll: PollModel
    
    var body: some View {
        ZStack{
            Color("Color")
            VStack(spacing: 45){
                PollInfoCell(poll: poll).padding(0)
                VStack{
                    switch poll.pollType {
                    case "Two Choices":
                        Text("2")
                    case "Three Choices":
                        Text("3")
                    case "Four Choices":
                        Text("4")
                    default:
                        Text("5")
                    }
                    Spacer()
                }
            }.frame(width: 350,height:150).background(RoundedRectangle(cornerRadius: 16).stroke(FOREGROUNDCOLOR,lineWidth: 3))
        }.edgesIgnoringSafeArea(.all).navigationBarHidden(true)
    }
}


struct PollCell_Previews: PreviewProvider {
    static var previews: some View {
        PollCell(name: "jesusnogs", groupName: "Laotians", dateCreated: Timestamp(), question: "Where should we skate today?", poll: PollModel()).preferredColorScheme(.dark)
    }
}
