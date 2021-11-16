//
//  CreateGroupView.swift
//  TopSecret
//
//  Created by Bruce Blake on 8/31/21.
//

import SwiftUI

struct CreateGroupView: View {
    
    @EnvironmentObject var userVM : UserViewModel
    @StateObject var groupVM = GroupViewModel()
    @State var groupName: String = ""
    @State var memberLimit: Int = 0
    @State var publicID : String = ""
    @State var joinPublicID : String = ""

    @Binding var goBack: Bool
    
    var body: some View {
        VStack{
            
            CustomTextField(text: $groupName, placeholder: "Group Name", isSecure: false, hasSymbol: false,symbol: "phone").padding(.horizontal,20)
            
            CustomTextField(text: $publicID, placeholder: "Public ID", isSecure: false, hasSymbol: false,symbol: "phone").padding(.horizontal,20)
            
            
            
            Button(action:{
                groupVM.createGroup(groupName: groupName, memberLimit: memberLimit, dateCreated: Date(), publicID: publicID, userID: userVM.user?.id ?? "")
       
            },label:{
                Text("Create Group")
            })
            
            Button(action:{
                self.goBack.toggle()
            },label:{
                Text("Back")
            })
        }
        Divider()
            
        VStack{
            Text("Join Group!")
            
            CustomTextField(text: $joinPublicID, placeholder: "Public ID", isSecure: false, hasSymbol: false,symbol: "phone").padding(.horizontal,20)
            
            Button(action:{
             
                groupVM.joinGroup(publicID: joinPublicID, userID: userVM.user?.id ?? "")
                userVM.fetchUserGroups()
                
            },label:{
                Text("Join Group")
            })
            
          
            
        }
        .onAppear{
            self.groupVM.setupUserVM(userVM: userVM)
        }
    }
}

//struct CreateGroupView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateGroupView()
//    }
//}
