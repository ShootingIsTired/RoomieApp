//
//  AuthViewModel.swift
//  RoomieApp
//
//  Created by Ru Heng on 2024/5/14.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift


protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var firebaseUserSession: FirebaseAuth.User?
    @Published var currentUser: Member?
    @Published var IsLoggedIn = false
    @Published var currentRoom: Rooms?
    @Published var userHasRoom = false
    
    init(firebaseUserSession: FirebaseAuth.User? = nil, currentUser: Member? = nil) {
        self.firebaseUserSession = firebaseUserSession
        self.currentUser = currentUser
        Task {
            await fetchMember()
            if let user = currentUser {
                await fetchRoom(for: user)
                print(user)
            }
        
        }
    }
    
    
    func signIn(withEmail email: String, password: String) async throws {
        
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.firebaseUserSession = result.user
            IsLoggedIn = true
            await fetchMember()
            print("user login success:")
            print(email, ",", password)
        } catch {
            print("Debug: Fail to sign in with user \(error.localizedDescription)")
            throw error
        }
    }
    
    func createMember(withEmail email: String, password: String, name: String, birthday: String) async throws {
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.firebaseUserSession = result.user
            let member = Member(id: result.user.uid, name: name, status: "資管三", birthday: birthday, email: email,  password: password)
            let encodedUser = try Firestore.Encoder().encode(member)
            try await Firestore.firestore().collection("members").document(member.id ?? "default value").setData(encodedUser)
            await fetchMember()
            print("register")
        } catch {
            print("Debug: Fail to create user with error \(error.localizedDescription)")
            throw error
        }
    }
    
    func signOut(){
        do {
            try Auth.auth().signOut() //sign out on backend
            self.firebaseUserSession = nil
            self.currentUser = nil
            IsLoggedIn = false
            print("user logout success")
        } catch {
            print("Debug: Fail to sign out with error \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() async {
        guard let user = Auth.auth().currentUser else {
            print("Debug: No user is currently signed in")
            return
        }
        
        do {
            let uid = user.uid
            try await Firestore.firestore().collection("members").document(uid).delete() // Delete the user document from Firestore
            try await user.delete() // Delete the user account from Firebase Authentication
            // Update the local state
            self.firebaseUserSession = nil
            self.currentUser = nil
            print("Debug: User account and data successfully deleted")
        } catch {
            print("Debug: Fail to delete user with error \(error.localizedDescription)")
        }
    }
    
    func fetchMember() async {
        do {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let documentRef = Firestore.firestore().collection("members").document(uid)
            let snapshot = try await documentRef.getDocument()
            
            if let data = snapshot.data() {
                print("Document data: \(data)") // Print raw document data for debugging
            } else {
                print("Document does not exist") // Document does not exist
                return
            }
            
            do {
                let member = try snapshot.data(as: Member.self)
                self.currentUser = member
                print("FetchMember: Current user is \(String(describing: self.currentUser))")
                if let user = currentUser {
                                await fetchRoom(for: user)}
                
                // Check if the user has a room
                if let roomRef = member.room {
                    self.userHasRoom = true
                    print("User has a room: \(roomRef)")
                } else {
                    self.userHasRoom = false
                    print("User does not have a room")
                }
                
            } catch {
                print("Document could not be parsed, Error: \(error)") // Parsing error
            }
        } catch {
            print("Debug: Current user is \(String(describing: self.currentUser)), Error: \(error)")
        }
    }

    
    func updateMember(name: String? = nil, email: String? = nil, schoolid: String? = nil, birthday: String? = nil, department: String? = nil, password: String? = nil, room: String? = nil) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        do {
            var updatedData: [String: Any] = [:]
            if let name = name { updatedData["name"] = name }
            if let email = email { updatedData["email"] = email }
            if let schoolid = schoolid { updatedData["schoolid"] = schoolid }
            if let birthday = birthday { updatedData["birthday"] = birthday }
            if let department = department { updatedData["department"] = department }
            if let password = password { updatedData["password"] = password }
            if let room = room { updatedData["room"] = room }
            
            // Update the user document in Firestore
            try await Firestore.firestore().collection("members").document(uid).updateData(updatedData)
            
            // Update the local state
            await fetchMember()
        } catch {
            print("Debug: Fail to update member with error \(error.localizedDescription)")
        }
    }
    
    //Add Room to Member
    func addNewRoomAndUpdateMember(newRoom: Rooms) async {
        // Step 1: Create the room in Firestore
        do {
            let roomRef = try Firestore.firestore().collection("rooms").addDocument(from: newRoom)
            let roomId = roomRef.documentID // Retrieve the room's ID
            
            // Step 2: Update the member's room property with the new room's ID
            await updateMember(room: roomId)
            print("Room added and member updated successfully")
        } catch let error {
            print("Error adding room or updating member: \(error.localizedDescription)")
        }
    }
    
    // Function to update the current user's room name and password
    func addNewRoomInfo(newName: String, newPassword: String) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        do {
            // Fetch the current user's member document
            let memberRef = Firestore.firestore().collection("members").document(uid)
            let memberSnapshot = try await memberRef.getDocument()
            
            guard let memberData = memberSnapshot.data(),
                  let memberRoomID = memberData["room"] as? String else {
                print("Debug: No room ID found for current user")
                return
            }
            
            // Update the room document with new name and password
            let roomRef = Firestore.firestore().collection("rooms").document(memberRoomID)
            try await roomRef.updateData(["name": newName, "password": newPassword])
            
            print("Room updated successfully")
        } catch {
            print("Error updating room: \(error.localizedDescription)")
        }
    }
    
    func joinRoom(roomName: String, roomPassword: String) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        do {
            // Step 1: Query Firestore for the room with the provided name and password
            let querySnapshot = try await Firestore.firestore().collection("rooms")
                .whereField("name", isEqualTo: roomName)
                .whereField("password", isEqualTo: roomPassword)
                .getDocuments()
            
            // Step 2: Check if a room was found
            guard let roomDocument = querySnapshot.documents.first else {
                print("No room found with the provided name and password")
                return
            }
            
            let roomId = roomDocument.documentID // Get the room's document ID
            
            // Step 3: Update the current user's room property with this document ID
            await updateMember(room: roomId)
            
            print("Room updated successfully for the current user")
        } catch {
            print("Error updating room for the current user: \(error.localizedDescription)")
        }
    }
    

    
//Room
    
    func fetchRoom(for user: Member) async {
        do {
            guard let roomRef = user.room else {
                print("Error1: Room reference is nil")
                return
            }

            // Print the path of the room document reference for debugging
            print("Room Reference Path: \(roomRef.path)")

            let document = try await roomRef.getDocument()

            if let data = document.data() {
                print("Room document data: \(data)")
            } else {
                print("Error2: Room document does not exist")
                return
            }

            if let room = try? document.data(as: Rooms.self) {
                self.currentRoom = room
                print("FetchRoom: Current room is \(String(describing: self.currentRoom))")
            } else {
                print("Error3: Room document could not be parsed")
            }
        } catch {
            print("Debug: Failed to fetch room with error \(error.localizedDescription)")
        }
    }

    
    func updateRoom(roomID: String, newName: String) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        do {
            let roomRef = Firestore.firestore().collection("rooms").document(roomID)
            try await roomRef.updateData(["name": newName])
            // Fetch the updated room to ensure local state is consistent
            if let user = currentUser {
                await fetchRoom(for: user)
            } else {
                print("Debug: currentUser is nil")
            }
        } catch {
            print("Debug: Failed to add rule with error \(error.localizedDescription)")
        }
    }
    
    func addRule(rule: String) async {
        guard let currentRoom = currentRoom, let roomID = currentRoom.id else {
            print("Error: Current room or room ID is nil")
            return
        }

        // Make a mutable copy of the rules array
        var updatedRules = currentRoom.rules

        // Add the new rule to the mutable copy
        updatedRules.append(rule)

        // Update Firestore with the modified rules
        do {
            let roomRef = Firestore.firestore().collection("rooms").document(roomID)
            try await roomRef.updateData(["rules": updatedRules])
            // Fetch the updated room to ensure local state is consistent
            if let user = currentUser {
                await fetchRoom(for: user)
            } else {
                print("Debug: currentUser is nil")
            }
        } catch {
            print("Debug: Failed to add rule with error \(error.localizedDescription)")
        }
    }

    func removeRule(rule: String) async {
        guard let currentRoom = currentRoom, let roomID = currentRoom.id else {
            print("Error: Current room or room ID is nil")
            return
        }

        // Make a mutable copy of the rules array
        var updatedRules = currentRoom.rules

        // Remove the rule from the mutable copy
        if let ruleIndex = updatedRules.firstIndex(of: rule) {
            updatedRules.remove(at: ruleIndex)
        } else {
            print("Error: Rule not found in current room")
            return
        }

        // Update Firestore with the modified rules
        do {
            let roomRef = Firestore.firestore().collection("rooms").document(roomID)
            try await roomRef.updateData(["rules": updatedRules])
            // Fetch the updated room to ensure local state is consistent
            if let user = currentUser {
                await fetchRoom(for: user)
            } else {
                print("Debug: currentUser is nil")
            }
        } catch {
            print("Debug: Failed to remove rule with error \(error.localizedDescription)")
        }
    }
}
