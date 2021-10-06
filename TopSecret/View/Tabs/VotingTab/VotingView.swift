//
//  VotingView.swift
//  TopSecret
//
//  Created by nathan frenzel on 8/31/21.
//

import SwiftUI
import Firebase

struct VotingView: View {
    @EnvironmentObject var userVM: UserAuthViewModel
    @State var goToAddPoll : Bool = false
    @StateObject var pollVM = PollViewModel()
    var body: some View {
        ZStack{
            Color("Background")
            if userVM.user?.polls.count != 0{
                VStack{
                    HStack(spacing: 20){
                        Button(action: {  }, label: {
                            Image("Hamburger_icon")
                                .resizable()
                                .frame(width: 32, height: 32)
                        }).padding(.leading,20)
                        Spacer()
                        
                        Text("Voting").font(.largeTitle).fontWeight(.bold)
                        Spacer()
                        Button(action: {
                            self.goToAddPoll.toggle()
                        }, label: {
                            Text("+")
                        })
                        .padding(.trailing,20).sheet(isPresented: $goToAddPoll, content: {
                            AddPollView(userVM: userVM, pollVM: pollVM)
                        })

                        
                    }.padding(.top,50)
                    
                    
                    
                    
                    
                    ScrollView(showsIndicators: false){
                        ForEach(userVM.user?.polls ?? []){ poll in
                            PollCell(username: poll.creator ?? "", groupName: poll.groupName ?? "", dateCreated: poll.dateCreated ?? Timestamp(), question: poll.question ?? "")
                            
                        }
                    }
                }.padding()
            }else{
                VStack{
                    HStack(spacing: 20){
                        Button(action: {  }, label: {
                            Image("Hamburger_icon")
                                .resizable()
                                .frame(width: 32, height: 32)
                        }).padding(.leading,20)
                        Spacer()
                        
                        Text("Voting").font(.largeTitle).fontWeight(.bold)
                        Spacer()
                        Button(action: {
                            self.goToAddPoll.toggle()
                        }, label: {
                            Text("+")
                        })
                        .padding(.trailing,20).sheet(isPresented: $goToAddPoll, content: {
                            AddPollView(userVM: userVM, pollVM: pollVM)
                        })
                        
                    }.padding(.top,50)
                    Spacer()
                    
                    Text("It appears there are not polls!")
                    Spacer()
                }.padding()
              
            }
        }.edgesIgnoringSafeArea(.all).navigationBarHidden(true).onAppear{
            pollVM.setupUserVM(userVM)
        
        }
    }
}


struct VotingView_Previews: PreviewProvider {
    static var previews: some View {
        VotingView()
    }
}
