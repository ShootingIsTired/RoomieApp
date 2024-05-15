import Foundation
import Firebase

class ViewRooms: ObservableObject {
    
    @Published var rooms = [Rooms]()
    
    private var db = Firestore.firestore()
    
    // MARK: - Fetch Rooms
    func getRoom() {
        db.collection("rooms").getDocuments { (snapshot, error) in
            if let snapshot = snapshot {
                DispatchQueue.main.async {
                    self.rooms = snapshot.documents.compactMap { document in
                        try? document.data(as: Rooms.self)
                    }
                }
            } else if let error = error {
                print("Error getting rooms: \(error.localizedDescription)")
            }
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
    func updateRoom(roomID: String, newName: String) {
        if let index = rooms.firstIndex(where: { $0.id == roomID }) {
            rooms[index].name = newName  // Update the name locally
            do {
                try db.collection("rooms").document(roomID).setData(["name": newName], merge: true) // Update name in Firestore
            } catch let error {
                print("Error updating room name: \(error.localizedDescription)")
            }
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
