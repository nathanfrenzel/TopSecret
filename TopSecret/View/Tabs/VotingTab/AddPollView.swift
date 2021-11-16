//
//  AddPollView.swift
//  TopSecret
//
//  Created by Bruce Blake on 10/6/21.
//

import SwiftUI

struct AddPollView: View {
    @EnvironmentObject var userVM : UserViewModel
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var pollVM : PollViewModel
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
                    if userVM.groups.count == 0 {
                        Text("You have no groups to create a poll!")
                    }else{
                    ForEach(userVM.groups ?? []){ group in
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
            
        }
    }
}

//struct AddPollView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddPollView(userVM: .shared, pollVM: )
//    }
//}
