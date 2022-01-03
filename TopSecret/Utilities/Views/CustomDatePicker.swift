//
//  CustomDatePicker.swift
//  TopSecret
//
//  Created by Bruce Blake on 1/2/22.
//

import SwiftUI

struct CustomDatePicker: View {
    @Binding var currentDate: Date
    
    @State var currentMonth: Int = 0
    
    let days: [String] = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
    var body: some View {
        VStack(){
            
            
            HStack(spacing: 20){
                
                VStack(alignment: .leading, spacing: 10){
                    Text(extraDate()[0])
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                    Text(extraDate()[1])
                        .font(.title)
                        .fontWeight(.bold)
                }.padding(.bottom,30)
                
                    Spacer(minLength: 0)
                    
                HStack{
                    Button(action:{
                        withAnimation{
                            currentMonth -= 1
                        }
                    },label:{
                        Image(systemName: "chevron.left")
                            .font(.title2)
                    })
                    
                    Button(action:{
                        withAnimation{
                            currentMonth += 1
                        }
                    },label:{
                        Image(systemName: "chevron.right")
                            .font(.title2)
                    })
                }
                 
                
            }.padding(.horizontal)
            
            HStack(spacing: 0){
                ForEach(days,id:\.self){ day in
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            LazyVGrid(columns: columns, spacing: 20){
                ForEach(extractDate()){ value in
                   CardView(value: value)
                }
            }
        }.onChange(of: currentMonth) { newValue in
            currentDate = getCurrentMonth()
        }.padding().background(Color("Color")).cornerRadius(20)
    }
    
    @ViewBuilder
    func CardView(value: DateValue) -> some View {
        VStack{
            if value.day != -1{
                Button(action:{
                    
                },label:{
                    Text("\(value.day)")
                        .font(.title3)
                        .bold()
                })
                
            }
        }
    }
    
    func extraDate()->[String]{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        
        let date = formatter.string(from: currentDate)
        
        return date.components(separatedBy: " ")
    }
    
    func getCurrentMonth()-> Date{
        let calendar = Calendar.current
        
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else{
            return Date()
        }
        
        return currentMonth
    }
    
    func extractDate()-> [DateValue] {
        let calendar = Calendar.current
        
        let currentMonth = getCurrentMonth()
        
        var days =  currentMonth.getAllDates().compactMap { date -> DateValue in
            let day = calendar.component(.day, from: date)
            
            return DateValue(day: day, date: date)
        }
        
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
}

//
//struct CustomDatePicker_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomDatePicker()
//    }
//}


extension Date{
    
    func getAllDates()-> [Date] {
        
        let calendar = Calendar.current
        
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
        let range = calendar.range(of: .day, in: .month, for: self)!
        return range.compactMap { (day) -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
}
