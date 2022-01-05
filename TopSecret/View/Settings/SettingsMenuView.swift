//
//  SettingsMenuView.swift
//  TopSecret
//
//  Created by Bruce Blake on 9/4/21.
//

import SwiftUI

struct SettingsMenuView: View {
    @Environment(\.presentationMode) var dismiss
    @EnvironmentObject var userAuthVM: UserViewModel
    @State var logOut : String = "Log Out"
    var body: some View {
        ZStack{
            Color("Background")
            VStack(alignment: .leading){
                
                HStack(alignment: .center){
                    Button(action:{
                        dismiss.wrappedValue.dismiss()
                    },label:{
                        Text("Back").foregroundColor(FOREGROUNDCOLOR).font(.headline)
                    }).padding()
                    
                    Spacer()
                    
                    
                    Text("Settings").fontWeight(.bold).font(.title).padding(.trailing,30)
                    
                    Spacer()
                    
                }.padding(.top,30)
                
                ScrollView(){
                    VStack(alignment: .leading){
                        
                        VStack(alignment: .leading){
                            
                            Text("My Account").fontWeight(.bold).foregroundColor(Color("Foreground")).padding(.leading,25)
                            
                            VStack(alignment: .leading, spacing: 15){
                                SettingsButtonCell(text: "Blocked Accounts", includeDivider: true,  action:{
                                    //TODO
                                }).padding(.top,15)
                                SettingsButtonCell(text: "Color Preferences", includeDivider: true,  action:{
                                    //TODO
                                })
                                SettingsButtonCell(text: "Change Username", includeDivider: true,  action:{
                                    //TODO
                                })
                                
                                SettingsButtonCell(text: "Change Email", includeDivider: true, action:{
                                    //TODO
                                })
                                
                                SettingsButtonCell(text: "Change Password", includeDivider: true,  action:{
                                    //TODO
                                })
                                SettingsButtonCell(text: "Two Factor Authentification", includeDivider: false, action:{
                                    //TODO
                                }).padding(.bottom,15)
                                
                                
                                
                                
                            }.background(Color("Color")).cornerRadius(12).padding([.horizontal,.bottom])
                        }
                        
                    }
                    
                    
                    
                    
                    VStack(alignment: .leading){
                        VStack(alignment: .leading){
                            Text("Support").fontWeight(.bold).foregroundColor(Color("Foreground")).padding(.leading,25)
                            
                            VStack{
                                SettingsButtonCell(text: "Contact Us", includeDivider: true,  action:{
                                    //TODO
                                }).padding(.top,10)
                                
                                SettingsButtonCell(text: "Contact Us", includeDivider: false, action: {
                                    print("cock")
                                })
                                .padding(.bottom,15)
                            }.background(Color("Color")).cornerRadius(12).padding([.horizontal,.bottom])
                        }
                        
                        
                        
                    }
                    
                    
                    
                    VStack(alignment: .leading){
                        VStack(alignment: .leading){
                            Text("Account Actions").fontWeight(.bold).foregroundColor(Color("Foreground")).padding(.leading,25)
                            
                            VStack{
                                SettingsButtonCell(text: "Switch Accounts", includeDivider: true, action:{
                                    //TODO
                                }).padding(.top,10)
                                SettingsButtonCell(text: logOut, includeDivider: false, action:{
                                    self.dismiss.wrappedValue.dismiss()
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                        userAuthVM.signOut()
                                                    }
                                }).padding(.bottom,15)
                                
                            }.background(Color("Color")).cornerRadius(12).padding([.horizontal,.bottom])
                        }
                        
                        
                        
                    }
                    
                    
                }
                
                
            }
        }.edgesIgnoringSafeArea(.all).navigationBarHidden(true)
    }
}

struct SettingsMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsMenuView().colorScheme(.dark)
    }
}
