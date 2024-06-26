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
    var content: String
    var assigned_person: DocumentReference?
    var isUnassigned: Bool
}

struct Schedules: Identifiable, Codable {
    @DocumentID var id: String?
    var member: DocumentReference
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

struct Chats:Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var content: String
    var member: DocumentReference
    var post_time: Date
    var isCurrentUser: Bool? 
    
    // Implement the Equatable protocol
    static func ==(lhs: Chats, rhs: Chats) -> Bool {
        return lhs.id == rhs.id && lhs.content == rhs.content && lhs.post_time == rhs.post_time
    }
}

struct MemberRefs:Identifiable, Codable {
    @DocumentID var id: String?
    var member: DocumentReference
}

struct Members: Identifiable, Codable {
    var id: String?
    var name: String
    var status: String
    var birthday: String
    var email: String
    var password: String
    var room: DocumentReference?
    var index: Int? = 999
}

struct Rooms: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var rules: [String]
    var members: [DocumentReference]?
    var tasks: [DocumentReference]?
    var schedules: [DocumentReference]?
    var chores: [DocumentReference]?
    var chats: [DocumentReference]?
    var membersData: [Member]?
    var tasksData: [Tasks]?
    var schedulesData: [Schedules]?
    var choresData: [Chores]?
    var chatsData: [Chats]?
}

struct Member: Identifiable, Codable {
    @DocumentID var id: String?
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

