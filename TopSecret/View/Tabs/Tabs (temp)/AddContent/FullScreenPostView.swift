//
//  FullScreenPostView.swift
//  TopSecret
//
//  Created by nathan frenzel on 9/5/21.
//

import SwiftUI

struct FullScreenPostView: View, KeyboardReadable {
    @ObservedObject var viewModel = UserAuthViewModel()
    @Binding var selectedTab: Int
    @Binding var isPresented: Bool
    @Binding var storedTab: Int
    @State var captionText: String = ""
    @State var selectedOption = PostFilterOptions.text
    @State private var isKeyboardVisible = false
    
    init(selectedTab: Binding<Int>, isPresented: Binding<Bool>, storedTab: Binding<Int>, selectedOption: String) {
        self._selectedTab = selectedTab
        self._isPresented = isPresented
        self._storedTab =  storedTab
    }
    
    private func dismissKeyboard() {
        if(isKeyboardVisible) {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        }
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    HStack(alignment: .top, spacing: 8) {
                        Text(viewModel.user?.username ?? "")
                            .font(.system(size: 15, weight: .bold))
                            .padding(.vertical, 12)
                            .padding(2)
                        
                        TextArea("What's Happening?", text: $captionText)
                            .onReceive(keyboardPublisher) { newIsKeyboardVisible in
                                print("Is Keyboard Visible?", newIsKeyboardVisible)
                                isKeyboardVisible = newIsKeyboardVisible
                            }
                            .font(.system(size: 15, weight: .semibold))

                    }.padding(.leading, geometry.size.width * 0.04)
                    .onTapGesture {
                        dismissKeyboard()
                    }.navigationBarTitle("Top Secret")
                    .navigationBarItems(leading: Button(action: { isPresented.toggle(); selectedTab = storedTab }, label: {
                        Text("Cancel")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .font(.system(size: 15, weight: .semibold))
                            .background(Color("TabBarColor"))
                            .foregroundColor(.white)
                            .cornerRadius(32)
                    }))
                    Spacer()
                   
                    ZStack(alignment:.bottom) {
                        RoundedRectangle(cornerSize: CGSize(width: 20,height: 10))
                            .ignoresSafeArea()
                            .foregroundColor(Color("TabBarColor"))
                        GeometryReader { maths in
                            PostViewFilterOptions(selectedOption: $selectedOption)
                                .frame(width: maths.size.width, height: maths.size.height * 0.6)
                                .padding(.top, isKeyboardVisible ? maths.size.height * 0.15 : maths.size.height * 0.225)
                        }.frame(width: geometry.size.width * 0.9)
                    }.frame(height: isKeyboardVisible ? geometry.size.height * 0.175 : geometry.size.height * 0.125)
                }
            }
        }
    }
}
