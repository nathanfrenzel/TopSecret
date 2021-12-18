//
//  HomeScreenView.swift
//  TopSecret
//
//  Created by nathan frenzel on 8/31/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeScreenView: View {
    
    
    @EnvironmentObject var userVM : UserViewModel
    
    private let gridItems = [GridItem(.flexible())]
    @State private var options = ["Groups","Notifications"]

    @State var selectedIndex = 0

    
    @State var showCreateGroupView : Bool = false
    @State var settingsOpen : Bool = false
    
    var body: some View {
        
        
        ZStack{
            Color("Background")
            
            VStack{
                VStack{
                HStack(spacing: 20){
                    Button(action: { self.settingsOpen.toggle() }, label: {
                        WebImage(url: URL(string: userVM.user?.profilePicture ?? ""))
                            .resizable()
                            .scaledToFill()
                            .frame(width:35,height:35)
                            .clipShape(Circle())
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
                    
                }.padding(.top,40)
                    //main content
                    VStack{
                      
                        Picker("Options",selection: $selectedIndex){
                            ForEach(0..<options.count){ index in
                                Text(self.options[index]).tag(index)
                            }
                        }.pickerStyle(SegmentedPickerStyle()).padding()
                        //List of groups
                        ScrollView {
                            LazyVGrid(columns: gridItems, spacing: 30) {
                                ForEach(userVM.groups) { group in
                                    NavigationLink(
                                        destination: GroupHomeScreenView(group: group),
                                        label: {
                                            HomescreenGroupCell(group: group)
                                        })
                                    
                                }
                                
                            }
                        }.padding(.horizontal)
                       
                        
                    }
                }
            }
        }.edgesIgnoringSafeArea(.all).navigationBarHidden(true).onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                userVM.fetchUserGroups()
            }
        }
        
        
        
        
        
        
    }
}
    struct HomeScreenView_Previews: PreviewProvider {
        static var previews: some View {
            HomeScreenView().preferredColorScheme(.dark).environmentObject(UserViewModel())
        }
    }

