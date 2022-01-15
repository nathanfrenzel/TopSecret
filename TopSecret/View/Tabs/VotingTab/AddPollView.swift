//
//  AddPollView.swift
//  TopSecret
//
//  Created by Bruce Blake on 10/6/21.
//

import SwiftUI

struct AddPollView: View {
    @EnvironmentObject var userVM: UserViewModel
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var pollVM : PollViewModel
    @State var question = ""
    @State var selectedGroup : Group = Group()
    @State var pollTypeChoice : Int = 0
    @State var completionTypeChoice: Int = 0
    @State var selectedHour: Int = 0
    @State var selectedMinute: Int = 0
    @State var selectedDays: Int = 0
    @State var selectedVisibility: Int = 0
    var pollTypes = ["Two Choices","Three Choices","Four Choices","Free Response"]
    var completionType = ["All Users Voted","Countdown"]
    var visibleToType = ["All","Select"]
    
    var body: some View {
        ZStack(alignment: .topLeading){
            Color("Background")
            
            VStack{
                
                
                
                //Poll Picker
                VStack(alignment: .leading){
                    
                    HStack{
                        Text("Poll Type:").bold()
                        Spacer()
                        HStack{
                            Button(action:{
                                pollTypeChoice -= 1
                            },label:{
                                Image(systemName: "chevron.left")
                            }).disabled(pollTypeChoice == 0).font(.title3)
                            
                            Text("\(pollTypes[pollTypeChoice])").bold()
                            
                            
                            Button(action:{
                                pollTypeChoice += 1
                            },label:{
                                Image(systemName: "chevron.right")
                            }).disabled(pollTypeChoice == 3).font(.title3)
                        }.padding(.trailing)
                    }.padding(.leading,5)
                    
                    //poll cell types
                    switch pollTypeChoice {
                    case 0:
                        PollCellTwoChoices()
                    case 1:
                        PollCellThreeChoices()
                    case 2:
                        PollCellFourChoices()
                    case 3:
                        PollCellFreeResponse()
                    default:
                        Text("Hello World!")
                    }
                }.padding().padding(.top,40)
                
                                
                HStack{
                    Text("Completion Type:").bold().padding(.leading)
                    
                    Spacer()
                    
                    HStack{
                        Button(action:{
                            withAnimation(.easeIn) {
                                self.completionTypeChoice -= 1
                            }
                        },label:{
                            Image(systemName: "chevron.left")
                        }).disabled(self.completionTypeChoice == 0)
                        
                        Text("\(completionType[completionTypeChoice])")
                        
                        Button(action:{
                            withAnimation(.easeIn) {
                                self.completionTypeChoice += 1
                            }
                            
                        },label:{
                            Image(systemName: "chevron.right")
                        }).disabled(self.completionTypeChoice == 1)
                    }.padding(.trailing)
                    
                }
                
                if self.completionTypeChoice == 1 {
                    
                    HStack{
                        Text("Poll Duration:").bold()
                        Spacer()
                    }.padding(.vertical,5)
                }
                
                
                HStack{
                    Text("Group:").bold()
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            
                            ForEach(userVM.groups , id: \.id){ group in
                                HStack{
                                    
                                    
                                    Button(action:{
                                        if self.selectedGroup.id != group.id {
                                            withAnimation(.easeOut){
                                                selectedGroup = group
                                            }
                                        }
                                    },label:{
                                        Text(group.groupName).foregroundColor(selectedGroup.id == group.id ? .red : .white)
                                    }).padding(.horizontal,10).padding(.vertical,5).foregroundColor(FOREGROUNDCOLOR)
                                }.background(RoundedRectangle(cornerRadius: 15).fill(Color("AccentColor")))
                                
                            }
                        }
                    }
                }.padding(.leading)
                
                
                VStack{
                if selectedGroup.memberAmount != 0 {
                    
                    HStack{
                        Text("Who can see:").foregroundColor(FOREGROUNDCOLOR)
                        Picker("Options",selection: $selectedVisibility){
                            ForEach(0..<visibleToType.count){ index in
                                Text(self.visibleToType[index]).tag(index)
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                    }.padding(.leading)
                    
                }
                
                
                
                //starts off with initalized group
                if selectedVisibility != 0 {
                    ScrollView{
                        VStack{
                            ForEach(selectedGroup.users ?? [], id: \.self){ userID in
                                Button(action:{
                                    
                                },label:{
                                    Text("\(userID ?? "")").foregroundColor(FOREGROUNDCOLOR)
                                })
                            }
                        }.background(Color("Color"))
                    }.padding(.horizontal)
                }
            }.animation(.easeOut, value: selectedVisibility)
                
                
                
                Button(action: {
                    //TODO
                }, label: {
                    Text("Create Poll")   .foregroundColor(Color("Foreground"))
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width/1.5).background(Color("AccentColor")).cornerRadius(15)
                }).padding()
                
                
                
                
                
                
                //end main vstack
            }
            
            HStack{
                Button(action:{
                    presentationMode.wrappedValue.dismiss()
                },label:{
                    Text("<")
                })
                
                Spacer()
                
                Text("Create Poll").font(.title3)
                
                Spacer()
            }.padding(.top).padding(.leading,10)
            
        }.edgesIgnoringSafeArea(.all).navigationBarHidden(true)
    }
}


struct PollCellTwoChoices : View {
    @State var question: String = ""
    @State var choice1: String = ""
    @State var choice2: String = ""
    var body: some View {
        VStack(spacing: 0){
            
            VStack{
                TextField("Question", text: $question).padding()
                Divider()
            }
            
            
            
            HStack(alignment: .center, spacing: 0){
                TextField("", text: $choice1).padding(.leading).placeholder(when: choice1.isEmpty, placeholder: { Text("CHOICE ONE").padding().foregroundColor(Color("AccentColor"))
                }).foregroundColor(Color("AccentColor")).padding(.leading,30)
                Divider()
                TextField("", text: $choice2).padding(.leading).placeholder(when: choice2.isEmpty, placeholder: { Text("CHOICE TWO").padding().foregroundColor(Color("AccentColor"))
                }).foregroundColor(Color("AccentColor")).padding(.leading,20)
            }
        }.frame(height: 200).background(Color("Color")).cornerRadius(16)
    }
}

struct PollCellThreeChoices : View {
    @State var question: String = ""
    @State var choice1: String = ""
    @State var choice2: String = ""
    @State var choice3: String = ""
    var body: some View {
        VStack{
            TextField("Question", text: $question).padding(.leading)
            Divider()
            VStack(alignment: .leading){
                TextField("", text: $choice1).padding(.leading).placeholder(when: choice1.isEmpty, placeholder: { Text("CHOICE ONE").padding(5).foregroundColor(Color("AccentColor"))
                }).foregroundColor(Color("AccentColor"))
                Divider()
                TextField("", text: $choice2).padding(.leading).placeholder(when: choice2.isEmpty, placeholder: { Text("CHOICE TWO").padding(5).foregroundColor(Color("AccentColor"))
                }).foregroundColor(Color("AccentColor"))
                Divider()
                TextField("", text: $choice3).padding(.leading).placeholder(when: choice3.isEmpty, placeholder: { Text("CHOICE THREE").padding(5).foregroundColor(Color("AccentColor"))
                }).foregroundColor(Color("AccentColor"))
            }
        }.frame(height: 200).background(Color("Color")).cornerRadius(16)
    }
}

struct PollCellFourChoices : View {
    @State var question: String = ""
    @State var choice1: String = ""
    @State var choice2: String = ""
    @State var choice3: String = ""
    @State var choice4: String = ""
    var body: some View {
        VStack(spacing: 0){
            
            
            TextField("Question", text: $question)
                .padding()
            
            Divider()
            
            VStack(spacing: 0){
                HStack(alignment: .center, spacing: 0){
                    
                    
                    
                    
                    TextField("", text: $choice1).placeholder(when: choice1.isEmpty, placeholder: { Text("CHOICE ONE").foregroundColor(Color("AccentColor"))
                    }).foregroundColor(Color("AccentColor")).padding(.leading,40)
                    
                    
                    
                    Divider().frame(maxHeight: .infinity)
                    
                    TextField("", text: $choice2).placeholder(when: choice2.isEmpty, placeholder: { Text("CHOICE TWO").foregroundColor(Color("AccentColor"))
                    }).foregroundColor(Color("AccentColor")).padding(.leading,40)
                    
                    
                }
                
                Divider().frame(maxWidth: .infinity)
                
                HStack(alignment: .center, spacing: 0){
                    
                    TextField("", text: $choice3).placeholder(when: choice3.isEmpty, placeholder: { Text("CHOICE THREE").foregroundColor(Color("AccentColor"))
                    }).foregroundColor(Color("AccentColor")).padding(.leading,40)
                    
                    
                    
                    Divider().frame(maxHeight: .infinity)
                    
                    TextField("", text: $choice4).placeholder(when: choice4.isEmpty, placeholder: { Text("CHOICE FOUR").foregroundColor(Color("AccentColor"))
                    }).foregroundColor(Color("AccentColor")).padding(.leading,40)
                    
                    
                }
            }
            
        }.frame(height: 200).background(Color("Color")).cornerRadius(16)
    }
}

struct PollCellFreeResponse : View {
    @State var question: String = ""
    var body: some View {
        VStack{
            TextField("Question", text: $question).padding()
            Divider()
            Spacer()
            Text("Response").padding()
            Spacer()
        }.frame(height: 200).background(Color("Color")).cornerRadius(16)
    }
}



struct AddPollView_Previews: PreviewProvider {
    static var previews: some View {
        AddPollView(pollVM:  PollViewModel(), pollTypeChoice: 2).environmentObject(UserViewModel()).colorScheme(.dark)
    }
}



extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment){
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
