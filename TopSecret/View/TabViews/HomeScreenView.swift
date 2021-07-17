//
//  HomeScreenView.swift
//  TopSecret
//
//  Created by Bruce Blake on 4/3/21.
//

import SwiftUI

struct HomeScreenView: View {
    @ObservedObject var viewModel = HomeScreenViewModel()
    @EnvironmentObject var userAuthViewModel : UserAuthViewModel
    
    var body: some View {
        ZStack{
            VStack{
                Text("Posts")
                
                Text("Polls")
                
                Text("Events")
                
                Text("And more Penis")
            }
        }
    }
}






