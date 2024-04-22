//
//  Menu Bar.swift
//  sad_project
//
//  Created by Fiona on 2024/4/19.
//

import Foundation
import UIKit
import SwiftUI

struct MenuBar: View{
    var body: some View{
        VStack{
            ZStack{
                Text("ROOMIE")
                    .font(Font.custom("Krona One", size: 20))
                    .foregroundColor(Color(red: 0, green: 0.23, blue: 0.44))
            }
            .frame(alignment: .top)
            VStack(alignment:.leading){
                Button{}label:{
                    Text("TEST")
                      .font(Font.custom("Jacques Francois", size: 18))
                      .foregroundColor(.black)
                }
                  .padding()
                
                Button{}label:{
                    Text("PROFILE")
                      .font(Font.custom("Jacques Francois", size: 18))
                      .foregroundColor(.black)
                }
                  .padding()
                Button{
                    
                }label:{
                    Text("HOME")
                        .font(Font.custom("Jacques Francois", size: 18))
                        .foregroundColor(.black)
                }
                    .padding()
                Button{}label:{
                    Text("CHORES")
                        .font(Font.custom("Jacques Francois", size: 18))
                        .foregroundColor(.black)
                }
                    .padding()
                Button{}label:{
                    Text("SCHEDULE")
                        .font(Font.custom("Jacques Francois", size: 18))
                        .foregroundColor(.black)
                }
                    .padding()
                Button{}label:{
                    Text("CHAT")
                        .font(Font.custom("Jacques Francois", size: 18))
                        .foregroundColor(.black)
                }
                    .padding()
            }
            .frame(maxHeight: .infinity, alignment: .top)
                Button{}label:{
                    Image("logout_outline")
                      .frame(width: 28, height: 28)
                    Text("LEAVE")
                      .font(Font.custom("Jacques Francois", size: 16))
                      .foregroundColor(.black)
                }
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

#Preview {
    MenuBar()
}
