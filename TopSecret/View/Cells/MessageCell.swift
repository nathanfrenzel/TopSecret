//
//  MessageCell.swift
//  TopSecret
//
//  Created by Bruce Blake on 9/5/21.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct MessageCell: View {
    var name: String
    var messageID: String
    var chatID: String
    var profilePicture: String
    var timeStamp: Timestamp
    var nameColor: String
    @Binding var showOverlay: Bool
    var text: String
    
    var body: some View {
        HStack{
            WebImage(url: URL(string: profilePicture))
                .resizable()
                .scaledToFill()
                .frame(width:50,height:50)
                .clipShape(Circle())
                .padding()
            VStack(alignment: .leading){
                HStack{
                    Text("\(name)").foregroundColor(Color(nameColor))
                    Text("*")
                    Text("\(timeStamp.dateValue(), style: .time)")
                    Spacer()
                    Button(action:{
                        COLLECTION_CHAT.document(chatID).collection("Messages").document(messageID).delete { (err) in
                            if err != nil {
                                print("ERROR DELETING MESSAGE, ERROR CODE: \(err?.localizedDescription)")
                                return
                            }else{
                                print("Deleted message!")
                            }
                        }
                    },label:{
                        Text("---")
                    }).padding(.trailing,10)
                }
                Text("\(text)")
            }
            .overlay(MessagePopup(isPresented: showOverlay), alignment: .topTrailing)
        }
        
        
    }
}

//struct MessageCell_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageCell()
//    }
//}
