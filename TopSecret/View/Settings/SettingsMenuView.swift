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
    var body: some View {
        VStack{
            Button(action: {
                self.dismiss.wrappedValue.dismiss()
            }, label:{
                Text("Back")
            })
            
            Text("Settings!")
            
            Button(action: {
                self.dismiss.wrappedValue.dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    userAuthVM.signOut()
                }
            }, label:{
                Text("Sign Out")
            })
            
            
        }
    }
}

struct SettingsMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsMenuView()
    }
}
