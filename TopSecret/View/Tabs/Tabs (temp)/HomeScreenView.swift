//
//  HomeScreenView.swift
//  TopSecret
//
//  Created by nathan frenzel on 8/31/21.
//

import SwiftUI

struct HomeScreenView: View {
    
    @EnvironmentObject var vm : UserAuthViewModel
    @State var settingsOpen: Bool = false
    @State var showCreateGroupView: Bool = false

    
    var body: some View {
            ZStack{
                Color(.black)
                VStack{
                    HStack(spacing: 20){
                        Button(action: { self.settingsOpen.toggle() }, label: {
                                Image("Hamburger_icon")
                                .resizable()
                                .frame(width: 32, height: 32)
                        }).sheet(isPresented: $settingsOpen, content: {
                            SettingsMenuView()
                        }).padding(.leading,20)
                        Spacer()
                        
                        Button(action:{
                            
                        }, label:{
                            Image("FinishedIcon")
                                .resizable()
                                .frame(width: 64, height: 64)
                        })
                       Spacer()
                        Button(action: {
                            showCreateGroupView.toggle()
                        }, label: {
                            Image(systemName: "person.3.fill")
                                .resizable()
                                .frame(width: 32, height: 32)
                        })            .sheet(isPresented: $showCreateGroupView, content: {
                            CreateGroupView(goBack: $showCreateGroupView)
                        })
.padding(.trailing,20)
                    }.padding(.top,50)
                    Spacer()
                    Text("Welcome: \(vm.user?.username ?? "")")
                    
                }
            }.navigationBarHidden(true)
            .edgesIgnoringSafeArea(.all)
            
          
           
            
           
         
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView().preferredColorScheme(.dark).environmentObject(UserAuthViewModel())
    }
}
