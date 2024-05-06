//
//  ContentView.swift
//  RoomieApp
//
//  Created by Yuting Hsu on 2024/4/22.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    @ObservedObject var model = ViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            List(model.list, id: \.self){ item in
                Text(item.name)
            }
        }
        .padding()
    }
    
    init(){
        model.getData()
    }

}

#Preview {
    ContentView()
}
