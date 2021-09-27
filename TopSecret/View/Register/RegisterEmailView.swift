//
//  RegisterView.swift
//  TopSecret
//
//  Created by Bruce Blake on 8/4/21.
//

import SwiftUI

struct RegisterEmailView: View {
    @State var email = ""
    @State var isNext:Bool = false
    @State var usingEmail:Bool = true
    @EnvironmentObject var vm: UserAuthViewModel

    
    
    
    
    
    var body: some View {
        
        
        
        if usingEmail {
            ZStack {
                
                Color("Background")
                
                NavigationLink(
                    destination:CreateUsername(),             isActive: $isNext,
                    label: {
                        EmptyView()
                    })
                VStack{
                    
                    
                    
                    VStack{
                        Text("Enter Email").foregroundColor(Color("Foreground")).fontWeight(.bold).font(.largeTitle).padding(.bottom,10)
                        
                        CustomTextField(text: $email, placeholder: "Email", isSecure: false, hasSymbol: true,symbol: "envelope").padding(.horizontal,20)
                        
                        
                        
                        Button(action: {
                            self.isNext.toggle()
                            vm.email = email
                        }, label: {
                            Text("Next")
                                .foregroundColor(Color("Foreground"))
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width/1.5).background(Color("AccentColor")).cornerRadius(15)
                        }).padding()
                        
                        
                        Button(action:{
                            self.usingEmail.toggle()
                        },label:{Text("I want to use my phone number").font(.body)})
                        
                        
                    
                    }
                    
                    Spacer()
                    
                }.padding(.top,100)
                
            }.edgesIgnoringSafeArea(.all)
        }else{
            RegisterPhoneView(usingEmail: $usingEmail)
        }
    }
    
    
    struct RegisterEmailView_Previews: PreviewProvider {
        static var previews: some View {
            
            RegisterEmailView().preferredColorScheme(.dark).environmentObject(UserAuthViewModel())
            
        }
    }
    
}
