//
//  RoomieAppApp.swift
//  RoomieApp
//
//  Created by Yuting Hsu on 2024/4/22.
//

import SwiftUI
import FirebaseCore
import Firebase

@main
struct RoomieAppApp: App {
    
    init(){
        FirebaseApp.configure()
        print("Configured Firebase!")
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack{
                LinearGradient(
                  stops: [
                    Gradient.Stop(color: Color(red: 0.9, green: 0.92, blue: 0.94), location: 0.00),
                    Gradient.Stop(color: Color(red: 0.7, green: 0.81, blue: 0.94), location: 0.46),
                    Gradient.Stop(color: Color(red: 0.64, green: 0.79, blue: 0.96), location: 1.00),
                  ],
                  startPoint: UnitPoint(x: 0.5, y: 0),
                  endPoint: UnitPoint(x: 0.5, y: 1)
                )
                MenuBarView()
            }
        }
    }
}
