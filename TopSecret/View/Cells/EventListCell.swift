//
//  EventListCell.swift
//  TopSecret
//
//  Created by Bruce Blake on 1/2/22.
//

import SwiftUI

struct EventListCell: View {
    var eventName: String
    var eventLocation: String
    var eventTime: Date
    
    var body: some View {
        ZStack{
            Color("Background")
            VStack{
                HStack{
                    Text("\(eventName)")
                        .font(.caption)
                    Text("\(eventLocation)")
                        .font(.caption)
                }
            }
        }
    }
}
//
//struct EventListCell_Previews: PreviewProvider {
//    static var previews: some View {
//        EventListCell(eventName: "Kareoke", eventLocation: "Sebastian's House", eventDate: "January 14th", eventTime: "4:00 PM")
//    }
//}
