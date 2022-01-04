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
                        
                        HStack{
                             NavigationLink(
                                destination: UserProfilePage(user: userVM.user ?? User()),
                                label: {
                                    WebImage(url: URL(string: userVM.user?.profilePicture ?? ""))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width:40,height:40)
                                        .clipShape(Circle())
                                })
                           
                            
                            Button(action:{
                                //TODO
                                self.settingsOpen.toggle()
                            },label:{
                                ZStack{
                                    Circle().foregroundColor(Color("Color")).frame(width: 40, height: 40)
                                    
                                    Image(systemName: "gear")
                                        .resizable()
                                        .frame(width: 24, height: 24).foregroundColor(Color("Foreground"))
                                    
                                    
                                }
                            }).sheet(isPresented: $settingsOpen, content: {
                                SettingsMenuView()
                            })
                            
                            
                        }.padding(.leading,20)
                     
                        Spacer()
                        
                        Button(action:{
                            userVM.fetchUserGroups()
                        }, label:{
                            Image("FinishedIcon")
                                .resizable()
                                .frame(width: 64, height: 64)
                        })
                        Spacer()
                        HStack(spacing:10){
                            
                          
                            
                           
                               
                                
                                NavigationLink(
                                    destination: SearchView(),
                                    label: {
                                        ZStack{
                                            Circle().foregroundColor(Color("Color")).frame(width: 40, height: 40)
                                            Image(systemName: "magnifyingglass")
                                                .resizable()
                                                .frame(width: 16, height: 16).foregroundColor(Color("Foreground"))
                                            
                                        }
                                    })
                                
                                
                                
                                 
                            
                            Button(action: {
                                showCreateGroupView.toggle()
                            }, label: {
                                ZStack{
                                    Circle().foregroundColor(Color("Color")).frame(width: 40, height: 40)
                                    Image(systemName: "person.3.fill")
                                        .resizable()
                                        .frame(width: 24, height: 16).foregroundColor(Color("Foreground"))
                                    
                                }
                                
                                
                                
                            })            .sheet(isPresented: $showCreateGroupView, content: {
                                CreateGroupView(goBack: $showCreateGroupView)
                            })
                            
                            
                            
                            
                        }.padding(.trailing,20)
                        
                        
                    }.padding(.top,40)
                    //main content
                    VStack{
                        
                        Picker("Options",selection: $selectedIndex){
                            ForEach(0..<options.count){ index in
                                Text(self.options[index]).tag(index)
                            }
                        }.pickerStyle(SegmentedPickerStyle()).padding()
                        //List of groups
                        if selectedIndex == 0 {
                            ScrollView {
                                if !userVM.groups.isEmpty{
                                    LazyVGrid(columns: gridItems, spacing: 30) {
                                        ForEach(userVM.groups) { group in
                                            NavigationLink(
                                                destination: GroupHomeScreenView(group: group),
                                                label: {
                                                    HomescreenGroupCell(group: group)
                                                })
                                            
                                        }
                                        
                                    }
                                }else{
                                    Text("You are not in any groups!")
                                }
                            }.padding(.horizontal)
                        }else{
                            ScrollView{
                                Text("Notifications")
                            }
                            
                        }
                        
                    }
                }
            }
        }.edgesIgnoringSafeArea(.all).navigationBarHidden(true)
        
        
        
        
        
        
    }
}
struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView().preferredColorScheme(.dark).environmentObject(UserViewModel())
    }
}

