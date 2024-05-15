//import Foundation
//import Firebase
//import FirebaseFirestoreSwift
//
//class UserViewModel: ObservableObject {
//    @Published var currentUser = Member() // Assuming Members is your user model
//    private var db = Firestore.firestore()
//
//    init() {
//        fetchCurrentUser()
//    }
//
//    func fetchCurrentUser() {
//        // Assuming there's a way to identify the current user, e.g., through FirebaseAuth
//        let userId = Auth.auth().currentUser?.uid ?? ""
//        db.collection("users").document(userId).getDocument { (document, error) in
//            if let document = document, document.exists {
//                DispatchQueue.main.async {
//                    self.currentUser = try? document.data(as: Members.self) ?? Members()
//                }
//            } else {
//                print("Document does not exist or error: \(error?.localizedDescription ?? "Unknown error")")
//            }
//        }
//    }
//
//    func updateCurrentUser() {
//        let userId = Auth.auth().currentUser?.uid ?? ""
//        do {
//            try db.collection("users").document(userId).setData(from: currentUser, merge: true)
//        } catch let error {
//            print("Error updating user: \(error.localizedDescription)")
//        }
//    }
//}
