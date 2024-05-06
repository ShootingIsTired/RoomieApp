//
//  ViewModel.swift
//  RoomieApp
//
//  Created by 松浦明日香 on 2024/05/04.
//

// TEST FILE

import Foundation
import Firebase

class ViewModel: ObservableObject{
    
    @Published var list = [Todo]()
    
    func getData(){
        
        let db = Firestore.firestore()
        
        db.collection("todos").getDocuments { snapshot, error in
            
            if error == nil{
                if let snapshot = snapshot{
                    
                    DispatchQueue.main.async{
                        self.list = snapshot.documents.map{ d in
                            return Todo(id: d.documentID,
                                        name: d["name"] as? String ?? "",
                                        notes: d["notes"] as? String ?? "")
                        }
                    }
                }
            }
            else{
                
            }
        }
        
    }
    
}
