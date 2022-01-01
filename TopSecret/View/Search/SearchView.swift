//
//  SearchView.swift
//  TopSecret
//
//  Created by Bruce Blake on 1/1/22.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var text : String = ""
    var body: some View {
        ZStack{
            Color("Background")
            VStack{
                SearchBar(text: $text)
                    .padding(.top,20)
                Spacer()
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
