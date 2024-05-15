import Foundation
import Firebase

class ViewRooms: ObservableObject {
    
    @Published var rooms: [Rooms] = []
    @Published var currentRoom: Rooms?
    @Published var currentUser: Member?
    
    private var db = Firestore.firestore()
    
    // MARK: - Fetch Rooms
    func fetchRoom(for user: Member) async {
        do {
            guard let roomRef = user.room else {
                print("Room reference is nil")
                return
            }
            let document = try await roomRef.getDocument()
            
            if let data = document.data() {
                print("Room document data: \(data)") // Print raw document data for debugging
            } else {
                print("Room document does not exist")
                return
            }
            
            if let room = try? document.data(as: Rooms.self) {
                self.currentRoom = room
                print("FetchRoom: Current room is \(String(describing: self.currentRoom))")
            } else {
                print("Room document could not be parsed")
            }
        } catch {
            print("Debug: Failed to fetch room with error \(error.localizedDescription)")
        }
    }

    
    // MARK: - Delete a Room
    func deleteRoom(roomID: String) {
        db.collection("rooms").document(roomID).delete { error in
            if let error = error {
                print("Error removing room: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    self.rooms.removeAll { $0.id == roomID }
                }
                print("Room successfully removed")
            }
        }
    }
    
    // MARK: - Update a Room
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


    
    // MARK: - Add a Room
    func addRoom(newRoom: Rooms) {
        do {
            _ = try db.collection("rooms").addDocument(from: newRoom)
        } catch let error {
            print("Error adding room: \(error.localizedDescription)")
        }
    }
    
    func addRule(toRoomID roomID: String, rule: String) {
            if let index = rooms.firstIndex(where: { $0.id == roomID }) {
                rooms[index].rules.append(rule)
                // Optionally update Firestore here if needed
            }
        }

    func removeRule(fromRoomID roomID: String, rule: String) {
        if let index = rooms.firstIndex(where: { $0.id == roomID }),
           let ruleIndex = rooms[index].rules.firstIndex(of: rule) {
            rooms[index].rules.remove(at: ruleIndex)
            // Optionally update Firestore here if needed
        }
    }
}
