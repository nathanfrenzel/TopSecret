//
//  CreatePassword.swift
//  TopSecret
//
//  Created by Bruce Blake on 8/31/21.
//

import SwiftUI

struct CreatePassword: View {
    @State var password: String = ""
    @EnvironmentObject var userVM : UserViewModel
    
    var body: some View {
        VStack{
            Text("Create A Password").foregroundColor(Color("Foreground")).font(.largeTitle).fontWeight(.bold).padding(.horizontal)
            
            Text("Make sure your password is secure").font(.headline).padding(.bottom,30)
            
         
            
            
            CustomTextField(text: $password, placeholder: "Password", isSecure: true, hasSymbol: true ,symbol: "lock").padding(.horizontal,20)
            
        
            
            
            
            Button(action: {
                userVM.createUser(email: userVM.email ?? "", password: password, username: userVM.username ?? "", fullname: userVM.fullName ?? "", birthday: userVM.birthday ?? Date())
                
            }, label: {
                Text("Create Account")
                    .foregroundColor(Color("Foreground"))
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width/1.5).background(Color("AccentColor")).cornerRadius(15)
            }).padding()
            
           
            
            Spacer()
        }.padding(.top,100)
    }
}

struct CreatePassword_Previews: PreviewProvider {
    static var previews: some View {
        CreatePassword().preferredColorScheme(.dark).environmentObject(UserViewModel())
    }
}
