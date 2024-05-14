//
//  Member.swift
//  RoomieApp
//
//  Created by Ru Heng on 2024/5/14.
//

import Foundation


struct Member:Identifiable, Codable {
    var id: String = "000000"
    var name: String
    var email: String = "0@gmail.com"
    var schoolid: String = "B10705000"
    var birthday: String
    var department: String = "資管三"
    var password: String = "123456"
}
