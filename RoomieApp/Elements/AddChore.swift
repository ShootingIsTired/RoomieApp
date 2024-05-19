//  AddChore.swift
//  RoomieApp

import Foundation
import SwiftUI


import Foundation
import SwiftUI

struct AddChore: View {
    @Binding var chore: String
    @Binding var selectedPerson: String
    @Binding var selectedFrequency: Int
    @EnvironmentObject var authViewModel: AuthViewModel
    let people: [String]
    let onAddChore: () -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack {
            Spacer()
            VStack {
                HStack{
                    Text("Add a new Chore:")
                        .font(.headline)
                    Spacer()
                    Button(action: onCancel) {
                        Image(systemName: "xmark.circle")
//                            .frame(width:18, height:18)
                    }.foregroundColor(.black)
                }
                .padding()
                TextField("Type in here", text: $chore)
                    .padding()
                    .foregroundColor(chore.isEmpty ? .gray : .black)
                    .textFieldStyle(.plain)
                    .background(Color(red: 0.96, green: 0.96, blue: 0.86).opacity(0.33))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8) // Stroke outline
                            .stroke(Color.gray, lineWidth: 1)
                    )
                HStack{
                    SelectPerson(selectedPerson: $selectedPerson, people: people)
                }.padding([.horizontal,.top])
                HStack{
                    ChooseFrequency(selectedFrequency: $selectedFrequency)
                }
                Button(action: onAddChore) {
                    
                    Text("SAVE")
                        .padding(5)
                        .cornerRadius(30)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke()
                )
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color(red: 0.95, green: 0.75, blue: 0.09))
                )
                .foregroundColor(.black)
                .padding()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 10)
            Spacer()
        }
        .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
    }
}

struct AddChoreView_Previews: PreviewProvider {
    static var previews: some View {
        AddChore(
            chore: .constant("Complete the project"),
            selectedPerson: .constant("Unassigned"),
            selectedFrequency: .constant(1),
            people: ["Non Specific", "test1", "test2", "test3"],
            onAddChore: { print("Task added") },
            onCancel: { print("Cancelled") }
        )
        .previewLayout(.sizeThatFits)
        .padding(10)
    }
}

//
//struct AddChore: View {
//    @Binding var chore: String
//    @Binding var selectedPerson: String
//    @Binding var selectedFrequency: Int // For simplicity, frequency is handled as a string
//    @EnvironmentObject var authViewModel: AuthViewModel
//    @State private var memberNames: [String] = []
//    @State private var frequencyText: String = ""
//
//    var body: some View {
//        VStack {
//            Spacer()
//            VStack {
//                HStack {
//                    Text("Add a new Chore:")
//                        .font(.headline)
//                    Spacer()
//                    Button(action: { self.dismiss() }) {
//                        Image(systemName: "xmark.circle").foregroundColor(.black)
//                    }
//                }
//                .padding()
//
//                TextField("Type in here", text: $chore)
//                    .padding()
//                    .foregroundColor(chore.isEmpty ? .gray : .black)
//                    .textFieldStyle(.roundedBorder)
//                    .background(Color(red: 0.96, green: 0.96, blue: 0.86).opacity(0.33))
//                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
//
//                Picker("Assign to", selection: $selectedPerson) {
//                    ForEach(memberNames, id: \.self) { name in
//                        Text(name).tag(name)
//                    }
//                }
//                .pickerStyle(MenuPickerStyle())
//                .padding([.horizontal, .top])
//                .onAppear {
//                    loadMembers()
//                }
//                .onChange(of: authViewModel.currentRoom?.id) { _ in
//                    loadMembers()
//                }
//
//                TextField("Frequency in days", text: $frequencyText)
//                    .keyboardType(.numberPad) 
//                    .padding()
//                    .background(Color(red: 0.96, green: 0.96, blue: 0.86).opacity(0.33))
//                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
//
//                Button("SAVE", action: self.saveChore)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//            .padding()
//            .background(Color.white)
//            .cornerRadius(12)
//            .shadow(radius: 10)
//            Spacer()
//        }
//        .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
//    }
//
//    private func dismiss() {
//        // Logic to dismiss the modal
//    }
//
//    private func saveChore() {
//        // Logic to save the chore, convert frequency to an Int and handle errors
//        dismiss()
//    }
//
//    private func loadMembers() {
//        guard let roomId = authViewModel.currentRoom?.id else { return }
//        Task {
//            memberNames = await authViewModel.fetchMembersInRoom(roomId: roomId).map { $0.name }
//        }
//    }
//}
//
//struct AddChoreView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddChore(
//            chore: .constant(""),
//            selectedPerson: .constant("Unassigned"),
//            selectedFrequency: .constant(7)
//        )
//        .environmentObject(AuthViewModel())
//    }
//}
