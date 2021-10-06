//
//  GroupProfileView.swift
//  TopSecret
//
//  Created by Bruce Blake on 9/23/21.
//

import SwiftUI

struct GroupProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var groupVM = GroupViewModel()
    @StateObject var pollVM = PollViewModel()
    @State var question = ""
    @EnvironmentObject var userVM: UserAuthViewModel
    var group: Group
    var body: some View {
        ZStack{
            Color("Background")
            
            VStack{
                Spacer()
                Text(group.groupName ?? "").foregroundColor(Color("Foreground"))
                
                TextField("Question", text: $question)
                
                Button(action:{
                    pollVM.createPoll(creator: userVM.user?.username ?? "", question: question, group: group)
                },label:{
                    Text("Create Poll")
                })
                
            Button(action:{
                presentationMode.wrappedValue.dismiss()
            },label:{
                Text("Back")
            })
                Button(action:{
                    groupVM.leaveGroup(groupID: group.id,userID: userVM.user?.id ?? " ")
                    presentationMode.wrappedValue.dismiss()

                },label:{
                    Text("Leave Group")
                })
                Spacer()
            }
        }.edgesIgnoringSafeArea(.all).navigationBarHidden(true)
    }
}

//struct GroupProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupProfileView()
//    }
//}
