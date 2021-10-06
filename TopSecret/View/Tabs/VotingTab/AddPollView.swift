//
//  AddPollView.swift
//  TopSecret
//
//  Created by Bruce Blake on 10/6/21.
//

import SwiftUI

struct AddPollView: View {
    var userVM : UserAuthViewModel
    @Environment(\.presentationMode) var presentationMode
    var pollVM : PollViewModel
    @State var selectedGroup : Group = Group()
    @State var question = ""
    
    var body: some View {
        ZStack{
            Color("Background")
            
            VStack{
                HStack{
                    Button(action:{
                        presentationMode.wrappedValue.dismiss()
                    },label:{
                        Text("Back").foregroundColor(Color("AccentColor"))
                    })
                    Spacer()
                }.padding(10)
                
                TextField("Question",text: $question)
                Text("Selected Group: \(selectedGroup.groupName )")
                ScrollView(showsIndicators: false){
                    if userVM.user?.groups.count == 0 {
                        Text("You have no groups to create a poll!")
                    }else{
                    ForEach(userVM.user?.groups ?? []){ group in
                        Button(action:{
                            selectedGroup = group
                        },label:{
                            Text(group.groupName )
                        })
                    }
                    }
                }
                Button(action:{
                    pollVM.createPoll(creator: userVM.user?.username ?? "", question: question, group: selectedGroup)
                    presentationMode.wrappedValue.dismiss()
                },label:{
                    Text("Create Poll")
                }).disabled(selectedGroup.groupName == "")
                Spacer()
            }
            
        }.onAppear{
            pollVM.setupUserVM(userVM)
            userVM.fetchGroups()
        }
    }
}

//struct AddPollView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddPollView(userVM: .shared, pollVM: )
//    }
//}
