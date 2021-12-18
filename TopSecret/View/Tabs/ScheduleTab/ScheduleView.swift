//
//  EventView.swift
//  TopSecret
//
//  Created by nathan frenzel on 8/31/21.
//

import SwiftUI

struct ScheduleView: View {
    var body: some View {
        ZStack{
            Color("Background")
            VStack{
                Text("Event View")
            }
        }.edgesIgnoringSafeArea(.all)
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
