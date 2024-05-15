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
                guard let roomID = user.room else { return }
                let document = try await Firestore.firestore().document(roomID).getDocument()
                if let room = try? document.data(as: Rooms.self) {
                    self.currentRoom = room
                    self.rooms = [room]
                } else {
                    print("Room document does not exist or could not be parsed")
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