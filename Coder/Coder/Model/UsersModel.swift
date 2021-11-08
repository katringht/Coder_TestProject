//
//  UsersModel.swift
//  Coder
//
//  Created by Ekaterina Tarasova on 07.11.2021.
//

import Foundation

struct Users: Codable {
    var items: [User]
}

struct User: Codable {
    var avatarUrl: String
    var firstName: String
    var lastName: String
    var userTag: String
    var department: String
    var position: String
    var birthday: String
    var phone: String
}
