//
//  EventView.swift
//  TopSecret
//
//  Created by nathan frenzel on 8/31/21.
//

import SwiftUI

struct ScheduleView: View {
    
    @EnvironmentObject var userVM: UserViewModel
    
    @State var showCreateEvent: Bool = false
    @State var currentDate: Date = Date()
    
    @State private var options = ["Calendar","Events List"]
    
    @State var selectedIndex = 0
    
    var body: some View {
        ZStack{
            Color("Background")
            VStack{
                HStack{
                    
                    Button(action:{
                        
                    },label:{
                        Text("[]")
                    }).padding(.leading,20)
                    
                    Spacer()
                    
                    Text("Events").font(.largeTitle).fontWeight(.bold)
                    Spacer()
                    
                    Button(action:{
                        showCreateEvent.toggle()
                    },label:{
                        Image(systemName: "plus.circle")
                    }).sheet(isPresented: $showCreateEvent, content: {
                        CreateEventView()
                    }).padding(.trailing,20)
                    
                }.padding(.top,50)
                
                VStack{
                    
                    Picker("Options",selection: $selectedIndex){
                        ForEach(0..<options.count){ index in
                            Text(self.options[index]).tag(index)
                        }
                    }.pickerStyle(SegmentedPickerStyle()).padding()
                    //List of groups
                    if selectedIndex == 0 {
                        ScrollView {
                            CustomDatePicker(currentDate: $currentDate).padding(.top)

                        }.padding(.horizontal)
                    }else{
                        ScrollView{
                            ForEach(userVM.events, id: \.id) { event in
                                EventListCell(eventName: event.eventName ?? "", eventLocation: event.eventLocation ?? "", eventTime: event.eventTime ?? Date())
                            }
                        }
                        
                    }
                    
                }
                
                
                Spacer()
            }
        }.edgesIgnoringSafeArea(.all).navigationBarHidden(true)
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
