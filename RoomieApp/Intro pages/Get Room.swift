//
//  Get Room.swift
//  RoomieApp
//
//  Created by Ru Heng on 2024/5/15.
//

import Foundation
import SwiftUI
import SwiftData

struct GetRoomView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var id: String = "123456"
    @State private var roomName = ""
    @State private var isActiveJoin = false
    @State private var isActiveCreate = false
    let newRoom = Rooms(
        id: nil,
        name: "Default Room",
        rules: [],
        members: nil,
        tasks: nil,
        schedules: nil,
        chores: nil,
        chats: nil,
        membersData: nil,
        tasksData: nil,
        schedulesData: nil,
        choresData: nil,
        chatsData: nil
    )
    
    var body: some View {
        NavigationView{
            ZStack{
//                LinearGradient(
//                            gradient: Gradient(stops: [
//                                Gradient.Stop(color: Color(red: 1, green: 0.98, blue: 0.92), location: 0.00),
//                                Gradient.Stop(color: Color(red: 0.88, green: 0.92, blue: 0.94), location: 0.29),
//                                Gradient.Stop(color: Color(red: 0.69, green: 0.81, blue: 0.94), location: 1.00)
//                            ]),
//                            startPoint: .topLeading,
//                            endPoint: .bottomTrailing
//                        )
//                        .edgesIgnoringSafeArea(.all)
                    VStack{
                        Image("Roomie Create Icon")
                            .resizable()
                            .frame(width: 200, height: 200)
                            .aspectRatio(contentMode: .fit)
                        //LOGIN
                        Text("DON'T HAVE ROOM ?")
                            .font(.title)
                            .bold()
                            .foregroundColor(Color(#colorLiteral(red: 0.18, green: 0.38, blue: 0.56, alpha: 1)))
                        HStack {
                            VStack {
                                NavigationLink(destination: JoinRoomView()
                                    , isActive: $isActiveJoin) {
                                        Button {
                                            Task {
//                                                try await 
                                                isActiveJoin = true
                                            }
                                        } label: {
                                            VStack {
                                                Text("Join an Exist Room")
                                                    .font(.headline)
                                                    .foregroundColor(.black)
                                                    .frame(width: 400.0, height: 42.0)
                                                    .background(ButtomBorder)
                                            }
                                        }
                                    }
                                
                                
                                
                                NavigationLink(destination: CreateRoomView()
                                    , isActive: $isActiveCreate) {
                                        Button{
                                            Task{
                                                await viewModel.createRoom(newRoom: newRoom)
                                                isActiveCreate = true
                                            }
                                        } label: {
                                            Text("Create a New Room")
                                                .font(.headline)
                                                .foregroundColor(.black)
                                                .frame(width: 400.0, height: 42.0)
                                                .background(ButtomBorder)
                                        }
                                    }
                            }
                        }
                    }
                    .padding()
                }
        }
        
    }

    
    
    var textFieldBorder: some View {
            Rectangle()
            .foregroundColor(.clear)
            .frame(width: 230, height: 35)
            .background(Color(red: 1, green: 0.87, blue: 0.44))
            .cornerRadius(15)
            .overlay(
            RoundedRectangle(cornerRadius: 15)
            .inset(by: -1)
            .stroke(Color(red: 0, green: 0.23, blue:0.44).opacity(0.8), lineWidth: 2)

            )
        
        }
    
    var ButtomBorder: some View {
            RoundedRectangle(cornerRadius: 20)
              .foregroundColor(.clear)
              .frame(width: 200, height: 35)
              .background(Color(red: 1, green: 0.84, blue: 0.25))
              .cornerRadius(15)
              .overlay(
                RoundedRectangle(cornerRadius: 15)
                  .inset(by: -1)
                  .stroke(Color(red: 0.95, green: 0.75, blue: 0.09), lineWidth: 1)
              )
        }
}

struct GetRoomView_Previews: PreviewProvider {
    static var previews: some View {
        GetRoomView()
    }
}
