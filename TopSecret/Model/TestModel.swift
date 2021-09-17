//
//  TestModel.swift
//  TopSecret
//
//  Created by Bruce Blake on 9/14/21.
//

import Foundation
import Firebase



struct TestModel: Identifiable, Encodable, Decodable {
    var id = UUID().uuidString
    var username: String?
    var idk: String?
}
