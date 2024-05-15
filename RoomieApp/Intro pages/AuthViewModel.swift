//
//  AuthViewModel.swift
//  RoomieApp
//
//  Created by Ru Heng on 2024/5/14.
//

import Firebase
import FirebaseFirestoreSwift

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var firebaseUserSession: FirebaseAuth.User?
    @Published var currentUser: Member?
    @Published var currentRoom: Rooms?
    
    init(firebaseUserSession: FirebaseAuth.User? = nil, currentUser: Member? = nil) {
        self.firebaseUserSession = firebaseUserSession
        self.currentUser = currentUser
        Task {
            await fetchMember()
            if let user = currentUser {
                await fetchRoom(for: user)
            }
        }
    }
    
    
    func signIn(withEmail email: String, password: String) async throws {
        
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.firebaseUserSession = result.user
            await fetchMember()
            print("login")
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
            let snapshot = try await Firestore.firestore().collection("members").document(uid).getDocument()
            if let member = try? snapshot.data(as: Member.self) {
                self.currentUser = member
            } else {
                print("Document does not exist or could not be parsed")
            }
        } catch {
            print("Debug: Current user is \(String(describing: self.currentUser)), Error: \(error)")
        }
    }
    
    func updateMember(name: String? = nil, email: String? = nil, schoolid: String? = nil, birthday: String? = nil, department: String? = nil, password: String? = nil) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        do {
            var updatedData: [String: Any] = [:]
            if let name = name { updatedData["name"] = name }
            if let email = email { updatedData["email"] = email }
            if let schoolid = schoolid { updatedData["schoolid"] = schoolid }
            if let birthday = birthday { updatedData["birthday"] = birthday }
            if let department = department { updatedData["department"] = department }
            if let password = password { updatedData["password"] = password }
            
            // Update the user document in Firestore
            try await Firestore.firestore().collection("members").document(uid).updateData(updatedData)
            
            // Update the local state
            await fetchMember()
        } catch {
            print("Debug: Fail to update member with error \(error.localizedDescription)")
        }
    }
    
    func fetchRoom(for user: Member) async {
        do {
            guard let roomID = user.room else { return }
            let document = try await Firestore.firestore().document(roomID).getDocument()
            if let room = try? document.data(as: Rooms.self) {  // Use try? to handle the optional
                self.currentRoom = room
            } else {
                print("Room document does not exist or could not be parsed")
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
            if let user = currentUser {
                await fetchRoom(for: user)
            } else {
                print("Debug: currentUser is nil")
            }
        } catch {
            print("Debug: Failed to update room with error \(error.localizedDescription)")
        }
        
        
    }
}
