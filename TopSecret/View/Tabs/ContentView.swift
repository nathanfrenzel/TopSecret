//
//  HomeScreenView.swift
//  TopSecret
//
//  Created by Bruce Blake on 8/30/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userVM : UserViewModel
    @StateObject var pollVM = PollViewModel()
    @State var isShowingNewPostView = true
    @State var selectedTab = 0
    @State var storedTab = 0
    @State var selectedOption: String = "Text"

    
    var body: some View {
        
        //if there is a user signed in then go to the Tab View else go to the register view
        if userVM.userSession != nil {
            
            
            
            NavigationView {
                TabView(selection: $selectedTab) {
                    VotingView().onAppear { storedTab = 2
                    }
                        .tabItem {
                            Image(systemName: "checkmark")
                                .scaledToFill()
                                .foregroundColor(.gray)
                                .frame(width: 128, height: 128)
                        }.tag(2)
                        
                    
                    MessageListView()
                        .tabItem {
                            Image(systemName: "message")
                                .scaledToFill()
                                .foregroundColor(.gray)
                                .frame(width: 128, height: 128)
                        }.tag(1)
                        .onAppear { storedTab = 1
                            
                        }
                    
                    HomeScreenView()
                        .tabItem {
                            Image(systemName: "house")
                                .scaledToFill()
                                .foregroundColor(.gray)
                                .frame(width: 128, height: 128)
                        }.tag(0)
                        .onAppear { storedTab = 0
                        }
                    
                    ScheduleView()
                        .tabItem {
                            Image(systemName: "text.book.closed")
                                .scaledToFill()
                                .foregroundColor(.gray)
                                .frame(width: 128, height: 128)
                        }.tag(3)
                        .onAppear{storedTab = 3
                            
                        }
                    MapView()
                        .tabItem {
                            Image(systemName: "map")
                                .scaledToFill()
                                .foregroundColor(.gray)
                                .frame(width: 128, height: 128)
                        }.tag(4)
                       
                    
                }
            }
            
        }else {
            LoginView()
        }
    }
}

