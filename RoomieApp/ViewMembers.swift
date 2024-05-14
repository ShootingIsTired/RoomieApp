import Foundation
import Firebase
import FirebaseFirestoreSwift
class ViewMembers: ObservableObject {
    
    @Published var members = [Members]()
    private var db = Firestore.firestore()
    
    // MARK: - Fetch Members
    func getMember() {
        db.collection("members").getDocuments { (snapshot, error) in
            if let snapshot = snapshot {
                DispatchQueue.main.async {
                    self.members = snapshot.documents.compactMap { document in
                        try? document.data(as: Members.self)
                    }
                }
            } else if let error = error {
                print("Error getting members: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Delete a Member
    func deleteMember(memberID: String) {
        db.collection("members").document(memberID).delete { error in
            if let error = error {
                print("Error removing member: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    self.members.removeAll { $0.id == memberID }
                }
                print("Member successfully removed")
            }
        }
    }
    
    // MARK: - Update a Member
    func updateMember(member: Members) {
        if let memberID = member.id {
            do {
                try db.collection("members").document(memberID).setData(from: member, merge: true)
            } catch let error {
                print("Error updating member: \(error.localizedDescription)")
            }
        }
    }

    
    // MARK: - Add a Member
    func addMember(newMember: Members) {
        do {
            _ = try db.collection("members").addDocument(from: newMember)
        } catch let error {
            print("Error adding member: \(error.localizedDescription)")
        }
    }
}
