//
//  CreateUsername.swift
//  TopSecret
//
//  Created by Bruce Blake on 8/31/21.
//

import SwiftUI

struct CreateUsername: View {
    
    @State var username: String = ""
    @State var isNext:Bool = false
    @EnvironmentObject var userAuthVM: UserViewModel
    @StateObject var registerValidation = RegisterValidationViewModel()

    
    var body: some View {
        VStack{
            Text("Create Your Username").foregroundColor(Color("Foreground")).font(.largeTitle).fontWeight(.bold).padding(.horizontal)
            
            Text("Create a unique username").font(.headline)
            
            Text("Remeber, you can only change your username once every two weeks").padding(.bottom,20).font(.footnote).foregroundColor(Color("Foreground").opacity(0.5)).padding(.horizontal,20).padding(.top,10)
            
            
            CustomTextField(text: $username, placeholder: "Username", isSecure: false, hasSymbol: true,symbol: "person").padding(.horizontal,20)
//            if registerValidation.usernameIsAvailable{
//                Text("Username is long enough!")
//            }else{
//                Text("Username is not long enough!")
//            }
            
            Button(action: {
                self.isNext.toggle()
               //TODO
                self.userAuthVM.username = username
            }, label: {
                Text("Next")
                    .foregroundColor(Color("Foreground"))
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width/1.5).background(Color("AccentColor")).cornerRadius(15)
            }).padding()
            
            NavigationLink(
                destination: EnterFullName(),
                isActive: $isNext,
                label: {
                    EmptyView()
                })
            
            Spacer()
        }.padding(.top,100)
    }
}

struct CreateUsername_Previews: PreviewProvider {
    static var previews: some View {
        CreateUsername().preferredColorScheme(.dark)
            .environmentObject(UserViewModel())
    }
}
