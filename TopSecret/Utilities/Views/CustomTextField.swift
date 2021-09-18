//
//  CustomTextField.swift
//  TopSecret
//
//  Created by Bruce Blake on 8/4/21.
//

import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    var placeholder: String
    var isSecure: Bool
    var hasSymbol: Bool
    var symbol: String
    var numbersOnly: Bool = false
    var body: some View {
        ZStack{
            
            VStack{
                HStack(){
                    if(hasSymbol){
                    Image(systemName: symbol).padding(.leading,15)
                    }
                    
                    if isSecure {
                        
                        if numbersOnly {
                            SecureField(placeholder, text: $text).autocapitalization(.none).padding(.vertical).padding(.leading,15).keyboardType(.numberPad)
                        }else{
                            SecureField(placeholder, text: $text).autocapitalization(.none).padding(.vertical).padding(.leading,15)
                        }
                        
                    }else{
                        if numbersOnly {
                            TextField(placeholder,text: $text).autocapitalization(.none).padding(.vertical).padding(.leading,15).keyboardType(.numberPad)
                        }else{
                            TextField(placeholder,text: $text).autocapitalization(.none).padding(.vertical).padding(.leading,15)
                        }
                    }
                    
                }.background(RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 2)).foregroundColor(Color("Foreground")).padding(.horizontal)
            }
        }
    }
}

//struct CustomTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomTextField(text: .constant( ""),placeholder: "Email", isSecure: false, hasSymbol: true,  symbol: "envelope").preferredColorScheme(.dark)
//    }
//}
