////  AddChore.swift
////  RoomieApp
//
//import Foundation
//import SwiftUI
//
//struct AddChore: View {
//    @Environment(\.presentationMode) var presentationMode  // To manage the view's dismissal
//    @State private var chore: String = ""
//    @State private var selectedPerson: String = "Unassigned"
//    @State private var frequencyText: Int = 1  // Use Int directly for frequency
//    @State private var memberNames: [String] = ["Unassigned"]
//    @EnvironmentObject var authViewModel: AuthViewModel
//
//    var body: some View {
//        VStack {
//            TextField("Type in here", text: $chore)
//                .padding()
//                .background(Color.gray.opacity(0.2))
//                .cornerRadius(5)
//
//            Picker("Assign to", selection: $selectedPerson) {
//                ForEach(memberNames, id: \.self) { name in
//                    Text(name).tag(name)
//                }
//            }
//            .pickerStyle(MenuPickerStyle())
//            .padding()
//
//            Stepper(value: $frequencyText, in: 1...365, step: 1) {
//                Text("Frequency in days: \(frequencyText)")
//            }
//            .padding()
//
//            Button("SAVE", action: addChore)
//                .padding()
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//        }
//        .padding()
//        .onAppear(perform: loadMembers)
//    }
//
//    private func loadMembers() {
//        guard let roomId = authViewModel.currentRoom?.id else { return }
//        Task {
//            let members = await authViewModel.fetchMembersInRoom(roomId: roomId)
//            memberNames = members.map { $0.name }
//            print("Members loaded: \(memberNames)")
//        }
//    }
//
//    private func addChore() {
//        guard let roomId = authViewModel.currentRoom?.id else { return }
//        Task {
//            await authViewModel.addChore(content: chore, frequency: frequencyText, roomID: roomId)
//            // Dismiss the view after the chore is added
//            presentationMode.wrappedValue.dismiss()
//        }
//    }
//}
//
//// Previews
//struct AddChore_Previews: PreviewProvider {
//    static var previews: some View {
//        AddChore()
//            .environmentObject(AuthViewModel())
//    }
//}
//
////
////struct AddChore: View {
////    @Binding var chore: String
////    @Binding var selectedPerson: String
////    @Binding var selectedFrequency: Int // For simplicity, frequency is handled as a string
////    @EnvironmentObject var authViewModel: AuthViewModel
////    @State private var memberNames: [String] = []
////    @State private var frequencyText: String = ""
////
////    var body: some View {
////        VStack {
////            Spacer()
////            VStack {
////                HStack {
////                    Text("Add a new Chore:")
////                        .font(.headline)
////                    Spacer()
////                    Button(action: { self.dismiss() }) {
////                        Image(systemName: "xmark.circle").foregroundColor(.black)
////                    }
////                }
////                .padding()
////
////                TextField("Type in here", text: $chore)
////                    .padding()
////                    .foregroundColor(chore.isEmpty ? .gray : .black)
////                    .textFieldStyle(.roundedBorder)
////                    .background(Color(red: 0.96, green: 0.96, blue: 0.86).opacity(0.33))
////                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
////
////                Picker("Assign to", selection: $selectedPerson) {
////                    ForEach(memberNames, id: \.self) { name in
////                        Text(name).tag(name)
////                    }
////                }
////                .pickerStyle(MenuPickerStyle())
////                .padding([.horizontal, .top])
////                .onAppear {
////                    loadMembers()
////                }
////                .onChange(of: authViewModel.currentRoom?.id) { _ in
////                    loadMembers()
////                }
////
////                TextField("Frequency in days", text: $frequencyText)
////                    .keyboardType(.numberPad) 
////                    .padding()
////                    .background(Color(red: 0.96, green: 0.96, blue: 0.86).opacity(0.33))
////                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
////
////                Button("SAVE", action: self.saveChore)
////                    .padding()
////                    .background(Color.blue)
////                    .foregroundColor(.white)
////                    .cornerRadius(10)
////            }
////            .padding()
////            .background(Color.white)
////            .cornerRadius(12)
////            .shadow(radius: 10)
////            Spacer()
////        }
////        .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
////    }
////
////    private func dismiss() {
////        // Logic to dismiss the modal
////    }
////
////    private func saveChore() {
////        // Logic to save the chore, convert frequency to an Int and handle errors
////        dismiss()
////    }
////
////    private func loadMembers() {
////        guard let roomId = authViewModel.currentRoom?.id else { return }
////        Task {
////            memberNames = await authViewModel.fetchMembersInRoom(roomId: roomId).map { $0.name }
////        }
////    }
////}
////
////struct AddChoreView_Previews: PreviewProvider {
////    static var previews: some View {
////        AddChore(
////            chore: .constant(""),
////            selectedPerson: .constant("Unassigned"),
////            selectedFrequency: .constant(7)
////        )
////        .environmentObject(AuthViewModel())
////    }
////}
