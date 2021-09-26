//
//  HomeScreenView.swift
//  TopSecret
//
//  Created by Bruce Blake on 8/30/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm : UserAuthViewModel
    @State var isShowingNewPostView = true
    @State var selectedTab = 0
    @State var storedTab = 0
    @State var selectedOption: String = "Text"
    
    
    var body: some View {
        //if there is a user signed in then go to the Tab View else go to the register view
        if vm.userSession != nil {
            
            //I put your commented-out thing at the bottom of the file
            
            NavigationView {
                TabView(selection: $selectedTab) {
                    VotingView()
                        .tabItem {
                            Image(systemName: "checkmark")
                                .scaledToFill()
                                .foregroundColor(.gray)
                                .frame(width: 128, height: 128)
                        }.tag(2)
                        .onAppear { storedTab = 2 }
                    
                    MessageListView()
                        .tabItem {
                            Image(systemName: "message")
                                .scaledToFill()
                                .foregroundColor(.gray)
                                .frame(width: 128, height: 128)
                        }.tag(1)
                        .onAppear { storedTab = 1 }
                    
                    HomeScreenView(vm: _vm)
                        .tabItem {
                            Image(systemName: "house")
                                .scaledToFill()
                                .foregroundColor(.gray)
                                .frame(width: 128, height: 128)
                        }.tag(0)
                        .onAppear { storedTab = 0 }
                    
                    EventView()
                        .tabItem {
                            Image(systemName: "text.book.closed")
                                .scaledToFill()
                                .foregroundColor(.gray)
                                .frame(width: 128, height: 128)
                        }.tag(3)
                        .onAppear{storedTab = 3}
                    
                    AddContentView(isPresented: $isShowingNewPostView, selectedTab: $selectedTab, storedTab: $storedTab, selectedOption: $selectedOption)
                        .tabItem {
                            Image(systemName: "plus")
                                .scaledToFill()
                                .foregroundColor(.gray)
                                .frame(width: 128, height: 128)
                        }.tag(4)
                        .onAppear { isShowingNewPostView = true }
                    
                }.accentColor(Color("TabColor"))
                .background(Color("TabBarColor"))
            }
            
        } else {
            LoginView()
        }
    }
}

//            ZStack{
//                Color("Background")
//                ZStack{
//                    switch(selectedTab){
//                    case "checkmark":
//                        VotingView()
//                    case "message":
//                        MessageListView(isShowingTabs: $isShowingTabs)
//                    case "house":
//                        HomeScreenView()
//                    case "text.book.closed":
//                        EventView()
//                    case "plus":
//                        AddContentView()
//                    default:
//                        HomeScreenView()
//                    }
//                    if isShowingTabs{
//                        VStack{
//                            Spacer()
//                            Divider()
//                            HStack(spacing: 5){
//                                ForEach(tabs, id: \.self){ tab in
//                                    Button(action:{
//                                        selectedTab = tab
//                                    },label:{
//                                        Image(systemName: tab)
//                                            .scaledToFill()
//                                            .foregroundColor(.gray)
//                                            .frame(width: 64, height: 64)
//                                    })
//                                }
//                            }
//                        }
//                    }
//
//
//
//                }
//            }
