//
//  Model.swift
//  RxSwift_MVVM_Tutorial
//
//  Created by 김병엽 on 2022/11/10.
//

import Foundation

struct User: Codable {
    let userID, id: Int
    var title, body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}
