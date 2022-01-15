//
//  CountDownPicker.swift
//  TopSecret
//
//  Created by Bruce Blake on 1/9/22.
//

import SwiftUI

struct CountDownPicker: View {
    var days = Array(0...7)
    var hours = Array(0...23)
    var min = Array(0...59)
    
    @Binding var selectedDays: Int
    @Binding var selectedHours: Int
    @Binding var selectedMins: Int
    var body: some View {
        GeometryReader { geometry in
            
            HStack {
                Picker(selection: $selectedDays, label: Text("days")) {
                    ForEach(0..<self.days.count) {
                        Text("\(self.days[$0]) days")
                            .bold()
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: geometry.size.width/3, height: 100, alignment: .center)
                .clipped()

                HStack {
                    Picker(selection: $selectedHours, label: Text("hours")) {
                        ForEach(0..<self.hours.count) {
                            Text("\(self.hours[$0]) hours")
                                .bold()
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: geometry.size.width/3, height: 100, alignment: .center)
                    .clipped()

                    
                    Picker(selection: self.$selectedMins, label: Text("min")) {
                        ForEach(0..<self.min.count) {
                            Text("\(self.min[$0]) mins")
                                .bold()
                        }
                    }
                    .frame(width: geometry.size.width/3, height: 100, alignment: .center)
                    .clipped()
                    .pickerStyle(WheelPickerStyle())
                    
                }
            }
            .offset(y: -100)
            .padding()
            .frame(width: .infinity, height: 140, alignment: .center)
        }
    }
}

//struct CountDownPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        CountDownPicker()
//    }
//}
