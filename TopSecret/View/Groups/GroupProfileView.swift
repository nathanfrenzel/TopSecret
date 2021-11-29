//
//  GroupProfileView.swift
//  TopSecret
//
//  Created by Bruce Blake on 11/26/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct GroupProfileView: View {
    
    var group: Group
    @Environment(\.presentationMode) var dismiss

    
    
    @State var selectedIndex = 0
    @State private var options = ["Gallery","Polls","Achievements","Plans"]
    
    var body: some View {
        ZStack{
            Color("Background")
            VStack{
                HStack(spacing:100){
                    Button(action:{
                        dismiss.wrappedValue.dismiss()
                    },label:{
                        Text("<")
                    }).padding(.leading)
                   
                    VStack{
                        WebImage(url: URL(string: group.groupProfileImage ?? ""))
                            .resizable()
                            .scaledToFill()
                            .frame(width:75,height:75)
                            .clipShape(Circle())
                            .padding()
                    Text("\(group.groupName)'s Profile").fontWeight(.bold).font(.headline)
                    }
                    
                    
                    
                    Button(action:{
                        //TODO
                    },label:{
                        Text("O")
                    }).padding(.trailing)
                }.padding(.top,50).padding(.bottom,20)
                //GALLERY
                //POLLS
                //ACHIEVEMENTS
                //PLANS
                Picker("Options",selection: $selectedIndex){
                    ForEach(0..<options.count){ index in
                        Text(self.options[index]).tag(index)
                    }
                }.pickerStyle(SegmentedPickerStyle()).padding(10)
                Spacer()
            }
        }.edgesIgnoringSafeArea(.all).navigationBarHidden(true)
    }
}

struct GroupProfileView_Previews: PreviewProvider {
    static var previews: some View {
        GroupProfileView(group: Group()).colorScheme(.dark)
    }
}
