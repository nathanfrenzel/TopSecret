//
//  PostViewFilterOptions.swift
//  TopSecret
//
//  Created by nathan frenzel on 6/27/21.
//

import SwiftUI

enum PostFilterOptions: Int, CaseIterable {
    case text
    case image
    case poll
    
    var title: String {
        switch self {
        case.text: return "Text"
        case.image: return "Image"
        case.poll: return "Poll"
        }
    }
    
    var symbol: String {
        switch self {
        case.text: return "textformat"
        case.image: return "photo"
        case.poll: return "list.star"
        }
    }
}


struct PostViewFilterOptions: View {
    @Binding var selectedOption: PostFilterOptions
    
    var body: some View {
        ZStack {
            VStack {
                Text("Content Options")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                //present available content options
                GeometryReader { math in
                    HStack(alignment: .center) {
                        ForEach(PostFilterOptions.allCases, id: \.self) { option in
                            Button(action: {
                                self.selectedOption = option
                            }, label: {
                                HStack {
                                    Image(systemName: option.symbol)
                                        .foregroundColor(.white)
                                    
                                    Text(option.title)
                                        .foregroundColor(.white)
                                }
                            })
                            .frame(width: math.size.width * 0.32)
                            .background(
                                Rectangle()
                                    .cornerRadius(20)
                                    .foregroundColor(Color("OptionsColor"))
                            )
                        }
                    }
                }
            }
        }
    }
}

