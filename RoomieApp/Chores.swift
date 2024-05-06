//
//  Chores.swift
//  RoomieApp
//
//  Created by Fiona on 2024/5/5.
//

//import Foundation

//
//  AddChores.swift
//  RoomieApp
//
//  Created by Fiona on 2024/5/2.
//

//import Foundation

//
//  Chores.swift
//  RoomieApp
//
//  Created by 松浦明日香 on 2024/04/29.
//

import Foundation

import SwiftUI

struct Chore: Identifiable {
    var id = UUID()
    var task: String
    var person: String
    var isDone: Bool
    var frequency: Int
}

struct ChoresView: View {
    @Binding var selectedPage: String?
    @State private var showMenuBar = false // State to manage the visibility of the menu
    @State private var chores: [Chore] = [
        Chore(task: "倒水", person: "Asuka", isDone: true, frequency: 1),
        Chore(task: "掃地", person: "Emily", isDone: false, frequency: 2),
        Chore(task: "買冷氣卡", person: "Fiona", isDone: false, frequency: 3)
    ]

    @State private var showAddChore = false
    
    @State private var chore = ""
    @State private var person = "Unassigned"
    @State var people :[String] = ["test1","test2","test3"]
    @State private var frequency = 0
    
    var body: some View{
        ZStack(alignment: .leading){
            Chores
                .contentShape(Rectangle())
                .onTapGesture{
                    if showMenuBar{
                        showMenuBar = false
                    }
                    if showAddChore{
                        showAddChore = false
                    }
                }
            if showMenuBar {
                MenuBar(selectedPage: $selectedPage)
                    .transition(.move(edge: .leading))
            }
            if showAddChore{
                AddChore
            }
        }
    }
    
    var AddChore: some View{
        VStack {
            Spacer()
            VStack{
                HStack{
                    Text("Add a new chore:")
                        .foregroundColor(.black)
                    Spacer()
                    Button{
                        self.showAddChore = false
                    }label:{
                        Image("close-circle_outline")
                        .frame(width: 18, height: 18)}
                }
                HStack{
                    Text("Chore")
                    Spacer()
                }
                RoundedRectangle(cornerRadius: 25.0)
                    .stroke(.black.opacity(0.33), lineWidth: 1)
                    .frame(width: 253, height: 30)
                    .background(Color(red: 0.96, green: 0.96, blue: 0.86).opacity(0.33))
                    .overlay(
                        TextField("Type in here", text: $chore)
                            .padding(10)
                    )
                HStack{
                    SelectPerson(selectedPerson: $person, people: people)}
                HStack{
                    ChooseFrequency(selectedFrequency: $frequency)
                }
                Button{
                    if (frequency > 0 && person != "Unassigned"){
                        addNewChore()
                        self.showAddChore = false
                    }
                }label:{
                    Text("Save")
                        .padding(5)
                        .foregroundColor(.black)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.black, lineWidth: 1)
                                .background(Color(red: 0.95, green: 0.75, blue: 0.09))
                        )
                }
            }
            .padding(10)
            .frame(width:300)
            Spacer()
        }
        .frame(maxWidth:.infinity, maxHeight: 400)
        .background(.white)
        .border(.black)
        .cornerRadius(15)
    }
    
    var Chores: some View {
//        NavigationView {
            VStack {
                HStack {
                    // Toggle button for the menu
                    Button(action: {
                            // Toggle the visibility of the menu
                            withAnimation {
                                showMenuBar.toggle()
                            }
                        }) {
                        Image("menu")
                        .frame(width: 38, height: 38)}
                    Spacer()
                    Text("CHORES")
                        .font(.custom("Krona One", size: 20))
                        .foregroundColor(Color(red: 0, green: 0.23, blue: 0.44))
                    Spacer()
                }
                .padding()
                .background(Color.white)
                .shadow(radius: 2)
                
                // Headers
                HStack {
                    Text("Chores")
                        .fontWeight(.semibold)
                    Spacer()
                    Text("Next Person")
                        .fontWeight(.semibold)
                    Spacer()
                    Text("Status")
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 16)

                // Chore List
                List {
                    ForEach($chores) { $chore in
                        HStack {
                            Text(chore.task)
                                .frame(width: 100, alignment: .leading)
                            Spacer()
                            Text(chore.person)
                                .frame(width: 100, alignment: .leading)
                            Spacer()
                            Button(action: {
                                chore.isDone.toggle()
                            }) {
                                Text(chore.isDone ? "Done" : "Not Yet")
                                    .fontWeight(.bold)
                                    .foregroundColor(chore.isDone ? .green : .red)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                    .background(chore.isDone ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                                    .cornerRadius(20)
                            }
                            .fixedSize() // This will prevent the button from resizing
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    }
                    .onDelete(perform: deleteChore)
                }
                .listStyle(PlainListStyle())
                .padding(.horizontal, 16)

                Spacer()

                // Add Chore Button
                Button{
                    self.showAddChore = true
                } label:{
                    Text("+ ADD CHORES")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.yellow)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 16)
//            }
//            .navigationBarHidden(true)
//            .background()
//            .background(Color(red: 0.88, green: 0.96, blue: 1.0).edgesIgnoringSafeArea(.all))
        }
    }
    
    func deleteChore(at offsets: IndexSet) {
        chores.remove(atOffsets: offsets)
    }
    
    func addChore() {
        // Logic for adding a chore
        
    }
    
    func addNewChore() {
        // Logic for adding a chore
        if !chore
            .trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let newChore = Chore(task: chore, person: person, isDone: false, frequency: frequency)
            chores.append(newChore)
            chore = ""
        }
    }
}

//struct AddChore: View{
//    @State private var chore = ""
//    @State private var person = "Unassigned"
//    @State var people :[String] = ["test1","test2","test3"]
//    @State private var frequency = 1
//    @State private var chores:[Chore] = []
//    
//    func addNewChore() {
//        // Logic for adding a chore
//        if !chore
//            .trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//            let newChore = Chore(task: chore, person: person, isDone: false)
//            chores.append(newChore)
//            chore = ""
//        }
//    }
//    
//    var body: some View{
//        VStack {
//            VStack{
//                HStack{
//                    Text("Add a new chore:")
//                        .foregroundColor(.black)
//                    Spacer()
//                    Button{
//                        
//                    }label:{
//                        Image("close-circle_outline")
//                        .frame(width: 18, height: 18)}
//                }
//                HStack{
//                    Text("Chore")
//                    Spacer()
//                }
//                RoundedRectangle(cornerRadius: 25.0)
//                    .stroke(.black.opacity(0.33), lineWidth: 1)
//                    .frame(width: 253, height: 30)
//                    .background(Color(red: 0.96, green: 0.96, blue: 0.86).opacity(0.33))
//                    .overlay(
//                        TextField("Type in here", text: $chore)
//                            .padding(10)
//                    )
//                HStack{
//                    SelectPerson(selectedPerson: $person, people: people)}
//                HStack{
//                    ChooseFrequency(selectedFrequency: $frequency)
//                }
//            }
//            .frame(width:260)
//        }
//        .frame(width: 320, height: 238)
//        .background(.white)
//        .cornerRadius(15)
//    }
//}

struct ChoresView_Previews:
    PreviewProvider {
    struct PreviewWrapper: View {
        @State var selectedPage: String? = "Chores"
        var body: some View{
            ChoresView(selectedPage: $selectedPage)
        }
    }
        static var previews: some View {
            PreviewWrapper()
        }
}

//#Preview{
//    AddChore()
//}
