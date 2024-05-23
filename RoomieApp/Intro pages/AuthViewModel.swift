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
    @Published var newRoomReference: DocumentReference?
    @Published var newRoomID: String?
    
    private var lastDocumentSnapshot: DocumentSnapshot?
    @Published var isMoreDataAvailable = true
    
    init(firebaseUserSession: FirebaseAuth.User? = nil, currentUser: Member? = nil, newRoomReference:DocumentReference? = nil,newRoomID: String? = nil) {
        self.firebaseUserSession = firebaseUserSession
        self.currentUser = currentUser
        self.newRoomReference = nil
        self.newRoomID = "00000000"
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
            if let user = currentUser {
                await fetchRoom(for: user)
                print(user)
            }
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
            self.IsLoggedIn = false
            self.currentRoom = nil
            self.userHasRoom = false
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
                IsLoggedIn = true
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
                    await fetchRoom(for: member)
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
    
    func updateMember(name: String? = nil, email: String? = nil, schoolid: String? = nil, birthday: String? = nil, department: String? = nil, password: String? = nil, room: DocumentReference? = nil,index: Int? = nil) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        do {
            var updatedData: [String: Any] = [:]
            if let name = name { updatedData["name"] = name }
            if let email = email { updatedData["email"] = email }
            if let schoolid = schoolid { updatedData["schoolid"] = schoolid }
            if let birthday = birthday { updatedData["birthday"] = birthday }
            if let department = department { updatedData["department"] = department }
            if let room = room { updatedData["room"] = room }
            if let index = index { updatedData["index"] = index }
            
            // Update the user document in Firestore
            try await Firestore.firestore().collection("members").document(uid).updateData(updatedData)
            
            // Update the local state
            await fetchMember()
        } catch {
            print("Debug: Fail to update member with error \(error.localizedDescription)")
        }
    }
    
    //Add Room to Member
    func createRoom(newRoom: Rooms) async {
        do {
            // Step 1: Create the room in Firestore
            let newRoomRef = try Firestore.firestore().collection("rooms").addDocument(from: newRoom)
            
            // Step 2: Store the new room's DocumentReference in newRoomReference
            self.newRoomReference = newRoomRef
            
            // Step 3: Convert the new room's DocumentReference to a string
            newRoomID = newRoomRef.documentID
            print("New room created with ID: \(String(describing: newRoomID))")
        } catch let error {
            print("Error adding room or updating member: \(error.localizedDescription)")
        }
    }
    
    // Function to update the current user's room name
    func addNewRoomInfo(newName: String) async {
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
            try await roomRef.updateData(["name": newName])
            
            print("Room name updated successfully")
        } catch {
            print("Error updating room: \(error.localizedDescription)")
        }
    }
    
    func joinRoom(roomName: String, roomID: String) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        do {
            // Step 1: Query Firestore for the room with the provided name and password
            let querySnapshot = try await Firestore.firestore().collection("rooms")
                .whereField(FieldPath.documentID(), isEqualTo: roomID)
                .getDocuments()
            
            // Step 2: Check if a room was found
            guard let roomDocument = querySnapshot.documents.first else {
                print("No room found with the provided name and id")
                return
            }
            
            let roomReference = roomDocument.reference // Get the room's DocumentReference
            // Step 3: Add the member's DocumentReference to the room's members sub-collection
            let memberReference = Firestore.firestore().collection("members").document(uid)
            try await roomReference.collection("members").document(uid).setData([
                "member": memberReference
            ])
            print("Member added to room's members sub-collection successfully")
            
            // Step 4: Calculate the current number of members in the room's members sub-collection and set the index
            let membersCollection = try await roomReference.collection("members").getDocuments()
            let newIndex = membersCollection.documents.count
            
            // Step 5: Update the current user's room property and index with this DocumentReference
            await updateMember(room: roomReference, index: newIndex)
            if let user = currentUser {
                await fetchRoom(for: user)
                print(user)
            }
            print("Room updated successfully for the current user")
        } catch {
            print("Error updating room for the current user: \(error.localizedDescription)")
        }
    }
    
    
    //Room
    func fetchRoom(for user: Member) async {
        do {
            guard let roomRef = user.room else {
                userHasRoom = false
                currentRoom = nil
                print("Error1: Room reference is nil")
                return
            }
            
            let document = try await roomRef.getDocument()
            if let room = try? document.data(as: Rooms.self) {
                self.currentRoom = room
                if let roomId = room.id {
                    print("Fetching sub-collections for room \(roomId)")
                    
                    // Fetch all related sub-collections and start listening to chats
                    self.currentRoom?.membersData = await fetchMembersInRoom(roomId: roomId)
                    self.currentRoom?.tasksData = await fetchSubCollection(collectionPath: "rooms/\(roomId)/tasks", as: Tasks.self)
                    self.currentRoom?.schedulesData = await fetchSubCollection(collectionPath: "rooms/\(roomId)/schedules", as: Schedules.self)
                    self.currentRoom?.choresData = await fetchSubCollection(collectionPath: "rooms/\(roomId)/chores", as: Chores.self)
                    fetchChats(roomID: roomId)  // Start listening to chat messages
                    fetchTasks(roomID: roomId)
                    DispatchQueue.main.async {
                        self.objectWillChange.send()
                    }
                } else {
                    print("Error: Room ID is nil")
                }
            } else {
                userHasRoom = false
                currentRoom = nil
                print("Error: Room document could not be parsed")
                print("Error: Room ID is nil")
            }
        } catch {
            userHasRoom = false
            currentRoom = nil
            print("Failed to fetch room with error \(error.localizedDescription)")
        }
    }
    
    
    func fetchSubCollection<T: Decodable>(collectionPath: String, as type: T.Type) async -> [T] {
        var results = [T]()
        do {
            let querySnapshot = try await Firestore.firestore().collection(collectionPath).getDocuments()
            for document in querySnapshot.documents {
                if let data = try? document.data(as: T.self) {
                    results.append(data)
                }
            }
        } catch {
            print("Failed to fetch sub-collection at \(collectionPath) with error \(error.localizedDescription)")
        }
        return results
    }
    
    func fetchMembersInRoom(roomId: String) async -> [Member] {
        var members = [Member]()
        do {
            // Fetch the members sub-collection from the specified room
            let querySnapshot = try await Firestore.firestore().collection("rooms/\(roomId)/members").getDocuments()
            print("Successfully fetched members sub-collection for roomId: \(roomId)")
            
            for document in querySnapshot.documents {
                // Extract the member reference from each document
                if let memberRef = document.data()["member"] as? DocumentReference {
                    print("Found member reference: \(memberRef.path)")
                    
                    // Fetch the member document using the reference
                    let memberSnapshot = try await memberRef.getDocument()
                    
                    if let member = try? memberSnapshot.data(as: Member.self) {
                        // Add the member to the members array
                        members.append(member)
                    } else {
                        print("Failed to decode member data from document at path: \(memberRef.path)")
                    }
                } else {
                    print("No valid member reference found in document with ID: \(document.documentID)")
                }
            }
        } catch {
            print("Failed to fetch members in room \(roomId) with error \(error.localizedDescription)")
        }
        // Print the number of members fetched
        print("Fetched \(members.count) members for roomId: \(roomId)")
        return members
    }
    
    func deleteMemberFromRoom(memberID: String) async {
        do {
            guard let roomID = currentRoom?.id else {
                print("Error: No current room ID available")
                return
            }
            
            // Step 1: Delete the member reference from the room's members sub-collection
            let membersSubCollectionRef = Firestore.firestore().collection("rooms").document(roomID).collection("members")
            let querySnapshot = try await membersSubCollectionRef.whereField("member", isEqualTo: Firestore.firestore().collection("members").document(memberID)).getDocuments()
            
            for document in querySnapshot.documents {
                try await document.reference.delete()
            }
            
            // Step 2: Update the top-level member document to remove the room reference
            let memberRef = Firestore.firestore().collection("members").document(memberID)
            try await memberRef.updateData(["room": FieldValue.delete()])
            
            // Check if the deleted member is the current user
            if memberID == firebaseUserSession?.uid {
                signOut()  // Log out the current user
            }
            
            // Refresh the room's member data locally
            if let currentUser = currentUser {
                await fetchRoom(for: currentUser)
            }
        } catch {
            print("Failed to delete member from room wit3h error: \(error.localizedDescription)")
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
    // AuthViewModel
    
    // Function to fetch and listen for new chat messages
    func fetchChats(roomID: String) {
        let chatsRef = Firestore.firestore().collection("rooms").document(roomID).collection("chats")
        chatsRef.order(by: "post_time", descending: false).addSnapshotListener { [weak self] snapshot, error in
            guard let documents = snapshot?.documents else {
                print("No documents in 'chats'")
                return
            }
            self?.currentRoom?.chatsData = documents.compactMap { document -> Chats? in
                var chat = try? document.data(as: Chats.self)
                if let uid = self?.currentUser?.id, let chatMemberID = chat?.member.documentID {
                    chat?.isCurrentUser = (uid == chatMemberID)
                }
                return chat
            }
            DispatchQueue.main.async {
                // Notify the UI to update as the chatsData array has changed.
                self?.objectWillChange.send()
            }
        }
    }
        
        func fetchTasks(roomID: String){
            let tasksRef = Firestore.firestore().collection("rooms").document(roomID).collection("tasks")
            tasksRef.order(by: "time", descending: true).addSnapshotListener { [weak self] snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("No documents in 'tasks'")
                    return
                }
                self?.currentRoom?.tasksData = documents.compactMap { document -> Tasks? in
                    let task = try? document.data(as: Tasks.self)
                    
                    return task
                }
                DispatchQueue.main.async {
                    // Notify the UI to update as the chatsData array has changed.
                    
                    self?.objectWillChange.send()
                }
            }
        }
        
        func addNewTask(roomID: String, time: Date, content: String, assigned_person: String){
            let tasksRef = Firestore.firestore().collection("rooms").document(roomID).collection("tasks")
            
            if assigned_person != "Unassigned" && assigned_person != "Non Specific"{
                let memberRef = Firestore.firestore().collection("members").document(assigned_person)
                
                let newTask = Tasks(time: time, content: content, assigned_person: memberRef, isUnassigned: false)
                
                self.currentRoom?.tasksData?.append(newTask)
                
                do{
                    _ = try tasksRef.addDocument(from: newTask){ error in
                        if let error = error {
                            print("Error add task: \(error.localizedDescription)")
                        }
                    }
                } catch let error {
                    print("Error add task: \(error.localizedDescription)")
                }
            }
            if assigned_person == "Unassigned"{
                let newTask = Tasks(time: time, content: content, isUnassigned: true)
                
                self.currentRoom?.tasksData?.append(newTask)
                
                do{
                    _ = try tasksRef.addDocument(from: newTask){ error in
                        if let error = error {
                            print("Error add task: \(error.localizedDescription)")
                        }
                    }
                } catch let error {
                    print("Error add task: \(error.localizedDescription)")
                }
            }
            if assigned_person == "Non Specific"{
                let newTask = Tasks(time: time, content: content, isUnassigned: false)
                
                self.currentRoom?.tasksData?.append(newTask)
                
                do{
                    _ = try tasksRef.addDocument(from: newTask){ error in
                        if let error = error {
                            print("Error add task: \(error.localizedDescription)")
                        }
                    }
                } catch let error {
                    print("Error add task: \(error.localizedDescription)")
                }
            }
        }
//        
//    func editChore(choreID: String, newContent: String, newFrequency: Int, newStatus: Bool, roomID: String) async {
//        guard !roomID.isEmpty, let choreRef = self.currentRoom?.choresData?.first(where: { $0.id == choreID }) else {
//            print("Error: No room ID provided or chore not found")
//            return
//        }
//        
//        let choreDocumentRef = Firestore.firestore().collection("rooms").document(roomID).collection("chores").document(choreID)
//        
//        do {
//            try await choreDocumentRef.updateData([
//                "content": newContent,
//                "status": newStatus,
//                "frequency": newFrequency,
//            ])
//            await fetchAllChores(roomID: roomID)  // Fetch all chores again to refresh the list
//            print("Chore updated successfully")
//        } catch let error {
//            print("Error updating chore: \(error.localizedDescription)")
//        }
//    }
    
        func updateTask(roomID: String, taskID: String, time: Date? = nil, content: String? = nil, assigned_person: String? = nil) async {
            let taskRef = Firestore.firestore().collection("rooms").document(roomID).collection("tasks").document(taskID)
            do {
                if assigned_person == "Unassigned"{
                    try await taskRef.updateData([
                    "time": time,
                    "content": content,
                    "isUnassigned" : true
                ])
                }
                else if assigned_person == "Non Specific"{
                    try await taskRef.updateData([
                    "time": time,
                    "content": content,
                    "isUnassigned" : false
                ])
                }
                else{
                    try await taskRef.updateData([
                    "time": time,
                    "content": content,
                    "isUnassigned" : false,
                    "assigned_person": Firestore.firestore().collection("members").document(assigned_person!)
                ])
                }
                    
//                var updatedData: [String: Any] = [:]
//                if let time = time { updatedData["time"] = time }
//                if let content = content { updatedData["content"] = content }
//                if let assigned_person = assigned_person {
//                    if assigned_person != "Unassigned" && assigned_person != "Non Specific" {
//                        updatedData["assigned_person"] = Firestore.firestore().collection("members").document(assigned_person)
//                        updatedData["isUnassigned"] = false
//                    } else if assigned_person == "Unassigned" {
////                        updatedData["assigned_person"] = NSNull()
//                        updatedData["isUnassigned"] = true
//                    } else if assigned_person == "Non Specific" {
////                        updatedData["assigned_person"] = NSNull()
//                        updatedData["isUnassigned"] = false
//                    }
//                }
//                print("Updating task ID: \(taskID) in room ID: \(roomID) with data: \(updatedData)")
//                try await Firestore.firestore().collection("rooms").document(roomID).collection("tasks").document(taskID).updateData(updatedData)
//                print("Debug: Successfully updated task")
                await fetchTasks(roomID: roomID)
            } catch {
                print("Debug: Fail to update task with error \(error.localizedDescription)")
            }
        }
        
        func removeTask(roomID: String, taskID: String) async {
            do {
                let taskDocument = Firestore.firestore().collection("rooms").document(roomID).collection("tasks").document(taskID)
                try await taskDocument.delete()
                print("Debug: Successfully deleted task with ID \(taskID)")
                await fetchTasks(roomID: roomID)
            } catch {
                print("Debug: Failed to delete task with error \(error.localizedDescription)")
            }
        }
        
        // Function to send a new chat message
        func sendChatMessage(roomID: String, content: String) {
            let chatsRef = Firestore.firestore().collection("rooms").document(roomID).collection("chats")
            guard let currentUser = currentUser else { return }
            
            let newChat = Chats(content: content, member: Firestore.firestore().collection("members").document(currentUser.id ?? ""), post_time: Date(), isCurrentUser: true)
            
            // Add the chat locally first to make it appear immediately
            self.currentRoom?.chatsData?.append(newChat)
            
            do {
                _ = try chatsRef.addDocument(from: newChat) { error in
                    if let error = error {
                        print("Error sending chat message: \(error.localizedDescription)")
                        // Optionally handle error, e.g., remove the chat from `chatsData` if not successful
                    }
                }
            } catch let error {
                print("Error sending chat message: \(error.localizedDescription)")
            }
        }
    
//    func fetchChores(roomID: String) async {
//        guard !roomID.isEmpty else {
//               print("Error: No room ID provided")
//               return
//           }
//
//           do {
//               let choresCollectionRef = Firestore.firestore().collection("rooms").document(roomID).collection("chores")
//               let querySnapshot = try await choresCollectionRef.getDocuments()
//
//               let choresData = querySnapshot.documents.compactMap { document -> Chores? in
//                   try? document.data(as: Chores.self)
//               }
//               DispatchQueue.main.async {
//                   self.currentRoom?.choresData = choresData
//                   self.objectWillChange.send()
//               }
//           } catch let error {
//               print("Error fetching chores: \(error.localizedDescription)")
//           }
//       }
    
    @Published var choresData: [Chores] = []
    
    // currently not used
    func fetchAllChores(roomID: String) {
        guard !roomID.isEmpty else {
            print("Error: No room ID provided")
            return
        }

        let choresCollectionRef = Firestore.firestore().collection("rooms").document(roomID).collection("chores")
        choresCollectionRef.addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching chores: \(String(describing: error))")
                return
            }
            let choresData = documents.compactMap { document -> Chores? in
                try? document.data(as: Chores.self)
            }
            DispatchQueue.main.async {
                self?.currentRoom?.choresData = choresData
                self?.objectWillChange.send()
            }
        }
    }
    
    func fetchChores(roomID: String, showCompleted: Bool) {
        guard !roomID.isEmpty else {
            print("Error: No room ID provided")
            return
        }

        let collectionRef = Firestore.firestore().collection("rooms").document(roomID).collection("chores")
        let query: Query = showCompleted ? collectionRef : collectionRef.whereField("status", isEqualTo: false)

        query.getDocuments { [weak self] (querySnapshot, error) in
            if let error = error {
                print("Error fetching chores: \(error.localizedDescription)")
                return
            }

            guard let documents = querySnapshot?.documents else {
                print("No chores found")
                return
            }

            self?.currentRoom?.choresData = documents.compactMap { document -> Chores? in
                try? document.data(as: Chores.self)
            }

            DispatchQueue.main.async {
                self?.objectWillChange.send()
            }
        }
    }

    func fetchIncompleteChores(roomID: String) {
        guard !roomID.isEmpty else {
            print("Error: No room ID provided")
            return
        }

        let choresCollectionRef = Firestore.firestore().collection("rooms").document(roomID).collection("chores")
        // Query to fetch chores where 'status' is false
        choresCollectionRef.whereField("status", isEqualTo: false).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching incomplete chores: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No incomplete chores found")
                return
            }
            
            self.currentRoom?.choresData = documents.compactMap { document -> Chores? in
                try? document.data(as: Chores.self)
            }
            
            DispatchQueue.main.async {
                // Notify the UI to update as the choresData array has changed.
                self.objectWillChange.send()
            }
            
            print("Fetched incomplete chores successfully")
        }
    }


    func addChore(content: String, frequency: Int, roomID: String) async {
        guard !roomID.isEmpty else {
            print("Error: No room ID provided")
            return
        }

        let newChore = Chores(content: content, last_index: 0, status: false, frequency: frequency,  last_time: Date())
        
//        // Add the chat locally first to make it appear immediately
        self.currentRoom?.choresData?.append(newChore)

        do {
            let _ = try Firestore.firestore().collection("rooms").document(roomID).collection("chores").addDocument(from: newChore)
            await fetchIncompleteChores(roomID: roomID)
            print("Chore added successfully")
        } catch let error {
            print("Error adding chore: \(error.localizedDescription)")
        }
    }
    
//    func toggleChoreStatus(_ chore: Chores) async {
//        guard let choreID = chore.id, let roomID = currentRoom?.id else { return }
//
//        let choreRef = Firestore.firestore().collection("rooms").document(roomID).collection("chores").document(choreID)
//        
//        do {
//            try await choreRef.updateData([
//                "status": !chore.status  // Toggle the current status
//            ])
//            print("Chore status updated successfully")
//        } catch let error {
//            print("Error updating chore status: \(error.localizedDescription)")
//        }
//    }
    func toggleChoreStatus(_ chore: Chores) async {
            guard let choreID = chore.id, let roomID = currentRoom?.id else { return }

            let newStatus = !chore.status
            let choreRef = Firestore.firestore().collection("rooms").document(roomID).collection("chores").document(choreID)
            
            do {
                try await choreRef.updateData(["status": newStatus])
                if let index = currentRoom?.choresData?.firstIndex(where: {$0.id == choreID}) {
                    currentRoom?.choresData?[index].status = newStatus
                }
                await fetchIncompleteChores(roomID: roomID)
                print("Chore status updated successfully")
            } catch let error {
                print("Error updating chore status: \(error.localizedDescription)")
            }
        }
    
    func editChore(choreID: String, newContent: String, newFrequency: Int, newStatus: Bool, roomID: String) async {
        guard !roomID.isEmpty, let choreRef = self.currentRoom?.choresData?.first(where: { $0.id == choreID }) else {
            print("Error: No room ID provided or chore not found")
            return
        }
        
        let choreDocumentRef = Firestore.firestore().collection("rooms").document(roomID).collection("chores").document(choreID)
        
        do {
            try await choreDocumentRef.updateData([
                "content": newContent,
                "status": newStatus,
                "frequency": newFrequency,
            ])
            await fetchAllChores(roomID: roomID)  // Fetch all chores again to refresh the list
            print("Chore updated successfully")
        } catch let error {
            print("Error updating chore: \(error.localizedDescription)")
        }
    }

    func deleteChore(choreID: String, roomID: String) async {
        guard !roomID.isEmpty else {
            print("Error: No room ID provided")
            return
        }

        let choreDocumentRef = Firestore.firestore().collection("rooms").document(roomID).collection("chores").document(choreID)
        
        do {
            try await choreDocumentRef.delete()
            print("Chore deleted successfully")
            await fetchAllChores(roomID: roomID)  // Fetch all chores again to refresh the list
        } catch let error {
            print("Error deleting chore: \(error.localizedDescription)")
        }
    }


}
