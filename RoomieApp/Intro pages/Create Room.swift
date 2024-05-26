//
//  Create Room.swift
//  RoomieApp
//
//  Created by Ru Heng on 2024/5/6.
//

import Foundation
import SwiftUI
import SwiftData

struct CreateRoomView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var id: String = "123"
    @State private var roomName = ""
    @State private var isActive = false
    
    
    var body: some View {
        NavigationView{
            ZStack{
                //background
//                LinearGradient(
//                    gradient: Gradient(stops: [
//                        Gradient.Stop(color: Color(red: 1, green: 0.98, blue: 0.92), location: 0.00),
//                        Gradient.Stop(color: Color(red: 0.88, green: 0.92, blue: 0.94), location: 0.29),
//                        Gradient.Stop(color: Color(red: 0.69, green: 0.81, blue: 0.94), location: 1.00)
//                    ]),
//                    startPoint: .topLeading,
//                    endPoint: .bottomTrailing
//                )
//                .edgesIgnoringSafeArea(.all)
                //Title
                VStack{
                    Image("Roomie Create Icon")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .aspectRatio(contentMode: .fit)
                    Text("CREATE ROOM")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color(#colorLiteral(red: 0.18, green: 0.38, blue: 0.56, alpha: 1)))
                        .onAppear {
                                self.id = viewModel.newRoomID ?? "create room fail"
                            }
                    VStack{
                        Spacer().frame(height:40)
                        HStack{
                            Text("Room ID:")
                                .font(.headline)
                                .frame(width:80,alignment:.leading)
                                .padding(.leading, 20)
                                .multilineTextAlignment(.leading)
                            TextField(id, text: $id)
//                                .disabled(true)
                                .font(Font.custom("Noto Sans", size: 16))
                                .bold()
                                .padding()
                                .multilineTextAlignment(.center)
                        }.background {textFieldBorder}
                        Spacer().frame(height:20)
                        HStack{
                            Text("Room Name:")
                                .font(.headline)
                                .frame(width:120, alignment:.leading)
                                .padding(.leading, 40)
                                .multilineTextAlignment(.leading)
                            TextField("Set Your Room Name", text: $roomName)
                                .font(Font.custom("Noto Sans", size: 16))
                                .bold()
                                .padding()
                                .multilineTextAlignment(.center)
                        }.background {textFieldBorder}
                        Spacer().frame(height:40)
                    }
//                    HStack {
//                        //sub title
//                        VStack {
//                            Text("Room ID:")
//                                .font(.headline)
//                                .foregroundColor(.black)
//                                .bold()
//                                .frame(width: 100, height: 60
//                                )
//                                .padding(.trailing, 2)
//                            Text("Room Name:")
//                                .font(.headline)
//                                .foregroundColor(.black)
//                                .bold()
//                                .frame(width: 100, height: 60)
//                                .padding(.trailing, 2)
//                        }
//                        //text field
//                        VStack {
//                            Text(id)
//                                .font(Font.custom("Noto Sans", size: 16))
//                                .bold()
//                                .padding()
//                                .background {textFieldBorder}
//                                .multilineTextAlignment(.center)
//                            
//                            TextField("Set Your Room Name", text: $roomName)
//                                .font(Font.custom("Noto Sans", size: 16))
//                                .bold()
//                                .padding()
//                                .background {textFieldBorder}
//                                .multilineTextAlignment(.center)
//                        }
//                    }
                    
                    //Buttoom
                    NavigationLink(destination: MenuBarView()
                        .navigationBarBackButtonHidden(), isActive: $isActive) {
                            Button{
                                Task{
                                    await viewModel.joinRoom(roomName: roomName, roomID: id)
                                    await viewModel.updateRoom(roomID: id, newName: roomName)
                                    print("Create roomName: \(roomName), roomID: \(id) success ")
                                    isActive = true
                                }
                            } label: {
                                Text("CREATE")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .frame(width: 100.0, height: 42.0)
                                    .background(ButtomBorder)
                            }
                        }
                    
                    NavigationLink {
                        JoinRoomView()
                    } label: {
                        VStack {
                            Text("Join Room")
                                .font(.subheadline)
                                .underline()
                                .foregroundColor(.black)
                                .frame(width: 90.0, height: 22.0)
                        }
                    }
                }
                .padding()
            }
        }
    }
}
    
    
    var textFieldBorder: some View {
            Rectangle()
            .foregroundColor(.clear)
            .frame(width: 350, height: 45)
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
              .frame(width: 82, height: 35)
              .background(Color(red: 1, green: 0.84, blue: 0.25))
              .cornerRadius(15)
              .overlay(
                RoundedRectangle(cornerRadius: 15)
                  .inset(by: -1)
                  .stroke(Color(red: 0.95, green: 0.75, blue: 0.09), lineWidth: 1)
              )
        }


struct CreateRoomView_Previews: PreviewProvider {
    static var previews: some View {
        CreateRoomView()
    }
}
