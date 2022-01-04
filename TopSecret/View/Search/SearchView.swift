//
//  SearchView.swift
//  TopSecret
//
//  Created by Bruce Blake on 1/1/22.
//

import SwiftUI
import Combine

struct SearchView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var _user : User = User()
    @State var goToUserProfile: Bool = false
    @StateObject var searchRepository = SearchRepository()
    var body: some View {
        ZStack{
            Color("Background")
            VStack{
                
                HStack(alignment: .center){
                    SearchBar(text: $searchRepository.searchText)
                        .padding(.top)
                    
                    Button(action:{
                        presentationMode.wrappedValue.dismiss()
                    },label:{
                        Text("Cancel").foregroundColor(.gray).fontWeight(.bold)
                    }).padding([.trailing,.top])
                }
                
                
                ScrollView(){
                    VStack(alignment: .leading){
                        VStack(alignment: .leading){
                            if !searchRepository.searchText.isEmpty{
                                Text("Users").fontWeight(.bold).foregroundColor(Color("Foreground")).padding(.leading)
                            }
                            VStack{
                                ForEach(searchRepository.returnedResults) { user in
                                    Button(action:{
                                        _user = user
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            self.goToUserProfile.toggle()
                                        }
                                    },label:{
                                        UserSearchCell(user: user)
                                    }).fullScreenCover(isPresented: $goToUserProfile, content: {
                                        UserProfilePage(user: _user)
                                    })
                                }
                            }.background(Color("Color")).cornerRadius(12).padding(.horizontal)
                        }
                        
                        
                        VStack(alignment: .leading){
                            if !searchRepository.searchText.isEmpty{
                                Text("Passwords").fontWeight(.bold).foregroundColor(Color("Foreground")).padding(.leading)
                            }
                            VStack{
                                ForEach(searchRepository.returnedResults) { user in
                                    Button(action:{
                                        _user = user
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            self.goToUserProfile.toggle()
                                        }
                                    },label:{
                                        UserSearchCell(user: user)
                                    }).fullScreenCover(isPresented: $goToUserProfile, content: {
                                        UserProfilePage(user: _user)
                                    })
                                }
                            }.background(Color("Color")).cornerRadius(12).padding(.horizontal)
                            
                        }
                        
                    }
                    
                    
                }
                Spacer()
            }
        }
    }
}

//struct SearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchView()
//    }
//}
