//
//  AddContentView.swift
//  TopSecret
//
//  Created by nathan frenzel on 5/25/21.
//

import SwiftUI

struct AddContentView: View {
    @Binding var selectedTab: Int
    @Binding var isPresented: Bool
    @Binding var storedTab: Int
    @Binding var selectedOption: String
    @ObservedObject var viewModel: UploadPostViewModel
    
    init(isPresented: Binding<Bool>, selectedTab: Binding<Int>, storedTab: Binding<Int>, selectedOption: Binding<String>) {
        self._isPresented = isPresented
        self._selectedTab = selectedTab
        self.viewModel = UploadPostViewModel(isPresented: isPresented)
        self._selectedOption = selectedOption
        self._storedTab = storedTab
    }
    
    var body: some View {
        ZStack {
        
        }.fullScreenCover(isPresented: $isPresented, content: {
            FullScreenPostView(selectedTab: $selectedTab, isPresented: $isPresented, storedTab: $storedTab, selectedOption: selectedOption)
        })
    }
}
