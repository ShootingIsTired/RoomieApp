//
//  Todo.swift
//  RoomieApp
//
//  Created by 松浦明日香 on 2024/05/04.
//

// TEST FILE

import Foundation

import FirebaseFirestore
import FirebaseFirestoreSwift

struct Todo: Identifiable, Hashable{
    var id: String
    var name: String
    var notes: String
}


struct Tasks: Identifiable, Codable {
    @DocumentID var id: String?
    var time: Date
    var status: String
    var assigned_person: String
}

struct Schedules: Identifiable, Codable {
    @DocumentID var id: String?
    var member: String
    var content: String
    var start_time: Date  // Using Date which conforms to Codable
    var end_time: Date
    var mode: String
}

struct Chores: Identifiable, Codable {
    @DocumentID var id: String?
    var content: String
    var last_index: Int
    var status: Bool
    var frequency: Int
    var last_time: Date
}

struct Chats:Identifiable, Codable {
    @DocumentID var id: String?
    var content: String
    var member: String
    var post_time: Date
}

struct Members: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var status: String
    var birthday: String
    var email: String
    var password: String
    var room: String?
    var index: Int? = 0
}

struct Rooms: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var rules: [String]
    var members: [Members]?
    var tasks: [Tasks]?
    var schedules: [Schedules]?
    var chores: [Chores]?
    var chats: [Chats]?
}

struct Member: Identifiable, Codable {
    var id: String?
    var name: String
    var status: String
    var birthday: String
    var email: String
    var password: String
    var room: DocumentReference?
    var index: Int? = 0

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
        case birthday
        case email
        case password
        case room
        case index
    }
}

