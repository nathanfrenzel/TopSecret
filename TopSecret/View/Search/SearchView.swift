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
    @State var goToUserProfile: Bool = false
    @StateObject var searchRepository = SearchRepository()
    @EnvironmentObject var userVM : UserViewModel
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
                }.padding(.top,40)
                
                
                ScrollView(){
                    VStack(alignment: .leading){
                        VStack(alignment: .leading){
                            if !searchRepository.searchText.isEmpty{
                                Text("Users").fontWeight(.bold).foregroundColor(Color("Foreground")).padding(.leading)
                            }
                            VStack{
                                ForEach(searchRepository.returnedResults, id: \.id) { user in
                                    NavigationLink(
                                        destination: UserProfilePage(user: user, isCurrentUser: userVM.user?.id == user.id ?? ""),
                                        label: {
                                            UserSearchCell(user: user)
                                        })
                                }
                            }.background(Color("Color")).cornerRadius(12).padding(.horizontal)
                        }
                        
                        

                    }
                    
                    
                }
                Spacer()
            }
        }.edgesIgnoringSafeArea(.all).navigationBarHidden(true)
    }
}

//struct SearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchView()
//    }
//}
