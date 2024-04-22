//
//  ContentView.swift
//  sad_project
//
//  Created by Fiona on 2024/4/19.
//

import SwiftUI

struct HomeView: View {
    @State private var showMenuBar = false
    @State private var currentPage = "home"
    var body: some View {
        ZStack(alignment: .leading){
            Home
                .contentShape(Rectangle())
                .onTapGesture{
                    if showMenuBar{
                        showMenuBar = false
                    }
                }
            if showMenuBar{
                MenuBar()
                    .transition(.move(edge: .leading)
                    )
            }
        }
    }
    var Home: some View{
        VStack{
            HStack{
                Button{
                    self.showMenuBar.toggle()
                }label:{
                    Image("menu")
                    .frame(width: 38, height: 38)}
                
                Text("HOME")
                    .font(Font.custom("Krona One", size: 20))
                    .foregroundColor(Color(red: 0, green: 0.23, blue: 0.44))
                Spacer()
            }
            VStack{
                HStack{
                    Text("Today’s Reminders")
                        .font(Font.custom("Jacques Francois", size: 20))
                        .foregroundColor(.black)
//                        .padding()
                    Spacer()
                    Button{}label:{
                        RoundedRectangle(cornerRadius: 8)
                            .inset(by: -1)
                            .stroke(Color(red: 1, green: 0.84, blue: 0.25), lineWidth: 2)
                            .background(Color(red: 1, green: 0.87, blue: 0.44))
                            .frame(width: 36, height: 20)
                            .overlay(
                        Text("EDIT")
                            .font(Font.custom("Jacques Francois", size: 10))
                            .foregroundColor(.black))
                    }
                }
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 300, height: 126)
                  .background(Color(red: 0.96, green: 0.96, blue: 0.93))
                  .cornerRadius(15)
            }
            .frame(maxWidth: 300)
            VStack{
                HStack{
                    Text("Unassigned Tasks")
                      .font(Font.custom("Jacques Francois", size: 20))
                      .foregroundColor(.black)
//                      .padding()
                    Spacer()
                    Button{}label:{
                        RoundedRectangle(cornerRadius: 8)
                            .inset(by: -1)
                            .stroke(Color(red: 1, green: 0.84, blue: 0.25), lineWidth: 2)
                            .background(Color(red: 1, green: 0.87, blue: 0.44))
                            .frame(width: 36, height: 20)
                            .overlay(
                        Text("ADD")
                            .font(Font.custom("Jacques Francois", size: 10))
                            .foregroundColor(.black))
                    }
                    Button{}label:{
                        RoundedRectangle(cornerRadius: 8)
                            .inset(by: -1)
                            .stroke(Color(red: 1, green: 0.84, blue: 0.25), lineWidth: 2)
                            .background(Color(red: 1, green: 0.87, blue: 0.44))
                            .frame(width: 36, height: 20)
                            .overlay(
                        Text("EDIT")
                            .font(Font.custom("Jacques Francois", size: 10))
                            .foregroundColor(.black))
                    }
                }
                
                ZStack{
                    Rectangle()
                      .foregroundColor(.clear)
                      .frame(width: 300, height: 126)
                      .background(Color(red: 0.96, green: 0.96, blue: 0.93))
                      .cornerRadius(15)
                      .overlay(
                        HStack{
                            Text("18:00")
                            Text("幫忙收衣服")
                            Button{}label:{
                                Image("person-x")
                                Text("Unassigned")}
                        }
                      )
                }
            }
            .frame(maxWidth: 300)
        }
        .frame(maxWidth:350, maxHeight:.infinity, alignment:.top)
    }
        
}

#Preview {
    HomeView()
}

