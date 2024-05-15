//
//  Join Room.swift
//  RoomieApp
//
//  Created by Ru Heng on 2024/5/6.
//

import Foundation
import SwiftUI
import SwiftData

struct JoinRoomView: View {
    @State private var id = ""
    @State private var roomID = ""
    var body: some View {
        ZStack{
            LinearGradient(
                        gradient: Gradient(stops: [
                            Gradient.Stop(color: Color(red: 1, green: 0.98, blue: 0.92), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.88, green: 0.92, blue: 0.94), location: 0.29),
                            Gradient.Stop(color: Color(red: 0.69, green: 0.81, blue: 0.94), location: 1.00)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    Image("Roomie Icon")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .aspectRatio(contentMode: .fit)
                    
                    //LOGIN
                    Text("JOIN AN EXIST ROOM")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color(#colorLiteral(red: 0.18, green: 0.38, blue: 0.56, alpha: 1)))
                    HStack {
                        VStack {
                            Text("ID:")
                                .font(.headline)
                                .foregroundColor(.black)
                                .bold()
                                .frame(width: 100, height: 60
                                )
                                .padding(.trailing, 2)
                            Text("Password:")
                                .font(.headline)
                                .foregroundColor(.black)
                                .bold()
                                .frame(width: 100, height: 60)
                                .padding(.trailing, 2)
                            
                        }
                        VStack {
                            TextField("Enter Room ID", text: $id)
                                .font(Font.custom("Noto Sans", size: 16))
                                .bold()
                                .padding()
                                .background {textFieldBorder}
                                .multilineTextAlignment(.center)
                            TextField("Enter Your Room Password", text: $roomID)
                                .font(Font.custom("Noto Sans", size: 16))
                                .bold()
                                .padding()
                                .background {textFieldBorder}
                                .multilineTextAlignment(.center)
                        }
                        
                    }
                    
                    Button(action: {
                        // 按鈕的動作
                    }) {
                        Text("JOIN")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(width: 100.0, height: 42.0)
                            .background(ButtomBorder)
                    }
                    
                    NavigationLink {
                        CreateRoomView()
                    } label: {
                        VStack {
                            Text("Create Room")
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
              .frame(width: 82, height: 35)
              .background(Color(red: 1, green: 0.84, blue: 0.25))
              .cornerRadius(15)
              .overlay(
                RoundedRectangle(cornerRadius: 15)
                  .inset(by: -1)
                  .stroke(Color(red: 0.95, green: 0.75, blue: 0.09), lineWidth: 1)
              )
        }
}

struct JoinRoomView_Previews: PreviewProvider {
    static var previews: some View {
        JoinRoomView()
    }
}
