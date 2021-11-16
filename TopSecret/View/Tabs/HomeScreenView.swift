//
//  HomeScreenView.swift
//  TopSecret
//
//  Created by nathan frenzel on 8/31/21.
//

import SwiftUI

struct HomeScreenView: View {
    
    
    @EnvironmentObject var userVM : UserViewModel
    @StateObject var groupVM = GroupViewModel()
    @State var settingsOpen: Bool = false
    @State var isAnimated : Bool = false
    @State var showCreateGroupView: Bool = false
    
    var body: some View {

        ZStack{
            Color("Background")
            VStack{
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
                        
                        
                        //TOP SECRET ICON
                        
                        Button(action:{
                            userVM.listenToUserGroups()
                        }, label:{
                            Image("FinishedIcon")
                                .resizable()
                                .frame(width: 64, height: 64)
                        })
                        
                        Spacer()
                        Button(action: {
                            showCreateGroupView.toggle()
                        }, label: {
                            Image("addGroup")
                                .resizable()
                                .frame(width: 32, height: 32)
                        })            .sheet(isPresented: $showCreateGroupView, content: {
                            CreateGroupView(goBack: $showCreateGroupView)
                        })
                        .padding(.trailing,20)
                        
                    }.padding(.top,50)
                    Spacer()
                }
                
               

            }
            
            if userVM.groups.count != 0{
                Spacer()
                VStack(alignment: .leading){
                    ScrollView(showsIndicators: false){
                        ForEach(userVM.groups){ group in
                            NavigationLink(
                                destination: GroupProfileView(group: group),
                                label: {
                                    GroupListCell(group: group)
                                })
                           
                            Divider()
                        }
                    }
                }.padding(.top,120)
            }else{
                Text("It appears that you are not in any groups!")
            }
            
            
            
        }.edgesIgnoringSafeArea(.all).navigationBarHidden(true)
    }
    
    
    struct HomeScreenView_Previews: PreviewProvider {
        static var previews: some View {
            HomeScreenView().preferredColorScheme(.dark).environmentObject(UserViewModel())
        }
    }


}
