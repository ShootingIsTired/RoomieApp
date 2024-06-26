//
//  Menu Bar.swift
//  sad_project
//
//  Created by Fiona on 2024/4/19.
//

import Foundation
import UIKit
import SwiftUI

// Main View containing the menu bar and page content
struct MenuBarView: View {
    @State private var selectedPage: String? = "Home"
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        switch selectedPage {
            case "Chat":
                ChatRoomView(selectedPage: $selectedPage).environmentObject(authViewModel)
            case "Home":
                HomeView(selectedPage: $selectedPage)
            case "Profile":
            ProfileView(selectedPage: $selectedPage).environmentObject(authViewModel)
            case "Login":
                LoginView(selectedPage: $selectedPage)
            case "Register":
                RegisterView(selectedPage: $selectedPage)
            case "Chores":
                ChoresView(selectedPage:$selectedPage).environmentObject(authViewModel)
            case "Schedule":
                ScheduleView(selectedPage:$selectedPage).environmentObject(authViewModel)
            default:
                HomeView(selectedPage: $selectedPage)
        }
    }
}
// MenuBar component with navigation
struct MenuBar: View {
    @Binding var selectedPage: String?
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        VStack {
            ZStack {
                Text("ROOMIE")
                    .font(Font.custom("Krona One", size: 24))
                    .bold()
                    .foregroundColor(Color(red: 0, green: 0.23, blue: 0.44))
            }
            .frame(alignment: .top)
            VStack(alignment: .leading) {
//                Button("TEST") { selectedPage = "Test" }
//                    .font(.custom("Jacques Francois", size: 18))
//                    .foregroundColor(.black)
//                    .padding()
                    
                Button("PROFILE") { selectedPage = "Profile" }
                    .font(.custom("Noto Sans", size: 18))
                    .bold()
                    .foregroundColor(.black)
                    .padding()
                    
                Button("HOME") { selectedPage = "Home" }
                    .font(.custom("Noto Sans", size: 18))
                    .bold()
                    .foregroundColor(.black)
                    .padding()
                    
                Button("CHORES") { selectedPage = "Chores" }
                    .font(.custom("Noto Sans", size: 18))
                    .bold()
                    .foregroundColor(.black)
                    .padding()
                    
                Button("SCHEDULE") { selectedPage = "Schedule" }
                    .font(.custom("Noto Sans", size: 18))
                    .bold()
                    .foregroundColor(.black)
                    .padding()
                    
                Button("CHAT") { selectedPage = "Chat" }
                    .font(.custom("Noto Sans", size: 18))
                    .bold()
                    .foregroundColor(.black)
                    .padding()
                    
//                Button("REGISTER") { selectedPage = "Register" }
//                    .font(.custom("Jacques Francois", size: 16))
//                    .foregroundColor(.black)
//                    .padding()
                
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
            Button{
                Task{
                    selectedPage = "Login"
                    authViewModel.signOut()
                }
            }
            label:{
                HStack {
                    Image("logout_outline")
                        .frame(width: 28, height: 28)
                    Text("LEAVE")
                        .font(Font.custom("Noto Sans", size: 16))
                        .foregroundColor(.black)
                }
            }
            .accessibility(identifier: "leaveButton")
            .frame(alignment: .bottom)
            .padding()
        }
        .frame(width: 168)
        .background(
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 0.97, green: 0.96, blue: 0.93).opacity(0.95), location: 0.03),
                    Gradient.Stop(color: Color(red: 0.98, green: 0.92, blue: 0.71).opacity(0.95), location: 0.32),
                    Gradient.Stop(color: Color(red: 1, green: 0.87, blue: 0.44).opacity(0.95), location: 0.61),
                ],
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 1)
            )
        )
    }
}

// Preview provider for MenuBar
struct MenuBarView_Previews: PreviewProvider {
    static var previews: some View {
        MenuBarView()
    }
}
