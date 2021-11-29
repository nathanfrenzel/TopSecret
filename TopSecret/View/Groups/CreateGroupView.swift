//
//  CreateGroupView.swift
//  TopSecret
//
//  Created by Bruce Blake on 8/31/21.
//

import SwiftUI

struct CreateGroupView: View {
    
    @EnvironmentObject var userVM : UserViewModel
    @Environment(\.presentationMode) var presentationMode
    @StateObject var groupVM = GroupViewModel()
    @State var groupName: String = ""
    @State var memberLimit: Int = 0
    @State var publicID : String = ""
    @State var joinPublicID : String = ""
    @State var isShowingPhotoPicker:Bool = false
    @State var avatarImage = UIImage(named: "Icon")!

    @Binding var goBack: Bool
    
    var body: some View {
        ZStack{
        VStack{
            
            CustomTextField(text: $groupName, placeholder: "Group Name", isSecure: false, hasSymbol: false,symbol: "phone").padding(.horizontal,20)
            
            CustomTextField(text: $publicID, placeholder: "Public ID", isSecure: false, hasSymbol: false,symbol: "phone").padding(.horizontal,20)
            
            
            Button(action:{
                isShowingPhotoPicker.toggle()
            },label:{
                Image(uiImage: avatarImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width:45,height:45)
                    .clipShape(Circle())
                    .padding()
            })
            
            Button(action:{
                groupVM.createGroup(groupName: groupName, memberLimit: memberLimit, dateCreated: Date(), publicID: publicID, userID: userVM.user?.id ?? "",image: avatarImage)
                presentationMode.wrappedValue.dismiss()
            },label:{
                Text("Create Group")
                    
            }).background(Color.red)
            
          
            
            
        
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
        }
        .fullScreenCover(isPresented: $isShowingPhotoPicker, content: {
            ImagePicker(avatarImage: $avatarImage)
        })
        
        }.onAppear{
            self.groupVM.setupUserVM(userVM: userVM)
        }
    }
}

struct CreateGroupView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGroupView(goBack: .constant(false))
    }
}
