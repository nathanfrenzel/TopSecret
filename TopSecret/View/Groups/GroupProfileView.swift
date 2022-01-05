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
    @State var openSettings = false

    
    
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
                            .frame(width:45,height:45)
                            .clipShape(Circle())
                            .padding()
                    Text("\(group.groupName)'s Profile").fontWeight(.bold).font(.headline)
                    }
                    
                    
                    
                    Button(action:{
                        //TODO
                        openSettings.toggle()
                    },label:{
                        Image(systemName: "gear")
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
                if selectedIndex == 0{
                    GroupGalleryView(group: group)
                }else if selectedIndex == 1{
                    Text("Hello World 1")
                }else if selectedIndex == 2{
                    Text("Hello World 2")
                }else{
                    Text("Hello World 3")
                }
            
                Spacer()
            }
            NavigationLink(destination: GroupSettingsView(), isActive: $openSettings, label:{ EmptyView()})
        }.edgesIgnoringSafeArea(.all).navigationBarHidden(true)
    }
}

struct GroupProfileView_Previews: PreviewProvider {
    static var previews: some View {
        GroupProfileView(group: Group()).colorScheme(.dark)
    }
}
