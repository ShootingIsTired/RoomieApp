//  EditChore.swift
//  RoomieApp

import SwiftUI

struct EditChore: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var chore: Chores? // Use binding to an optional Chores
    @State private var editedContent: String
    @State private var editedFrequency: Int
    @State private var editedStatus: Bool // State for status toggle
    @EnvironmentObject var authViewModel: AuthViewModel

    init(chore: Binding<Chores?>) {
        self._chore = chore
        _editedContent = State(initialValue: chore.wrappedValue?.content ?? "")
        _editedFrequency = State(initialValue: chore.wrappedValue?.frequency ?? 1)
        _editedStatus = State(initialValue: chore.wrappedValue?.status ?? false) // Initialize with the current status
    }

    var body: some View {
        NavigationView {
            Form {
                TextField("Chore Description", text: $editedContent)
                Stepper("Frequency in days: \(editedFrequency)", value: $editedFrequency, in: 1...365)
                Toggle("Status", isOn: $editedStatus) // Toggle for editing status
                Button("Save Changes") {
                    editChore()
                }
                .disabled(editedContent.isEmpty)
            }
            .navigationBarTitle("Edit Chore", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    private func editChore() {
        guard let chore = chore, let roomId = authViewModel.currentRoom?.id else { return }
        Task {
            await authViewModel.editChore(choreID: chore.id ?? "", newContent: editedContent, newFrequency: editedFrequency, newStatus: editedStatus, roomID: roomId)
            presentationMode.wrappedValue.dismiss()
        }
    }
}

//import Foundation
//import SwiftUI
//
//struct EditChore: View {
//    @Binding var chore: String
//    @Binding var selectedPerson: String
//    @Binding var selectedFrequency:Int
//    let people: [String]
//    let onSaveEdit:()->Void
//    let onCancelEdit:()->Void
//    
////    @Binding var task: String
////    @Binding var selectedDate: Date
////    @Binding var selectedTime: Date
//
//    var body: some View {
//        VStack {
//            Spacer()
//            VStack {
//                HStack{
//                    Text("Edit Chore:")
//                        .font(.headline)
//                    Spacer()
//                    Button(action: onCancelEdit) {
//                        Image(systemName: "xmark.circle")
//                    }
//                    .foregroundColor(.black)
//                }
//                .padding()
//                TextField("Type in here", text: $chore)
//                    .padding()
//                    .foregroundColor(chore.isEmpty ? .gray : .black)
//                    .textFieldStyle(.plain)
//                    .background(Color(red: 0.96, green: 0.96, blue: 0.86).opacity(0.33))
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 8) // Stroke outline
//                            .stroke(Color.gray, lineWidth: 1)
//                    )
//                SelectPerson(selectedPerson: $selectedPerson, people: people)
//                    .padding(.top)
//                ChooseFrequency(selectedFrequency: $selectedFrequency)
//                Button(action: onSaveEdit) {
//                    Text("SAVE")
//                        .padding(5)
//                        .cornerRadius(30)
//                }
//                .overlay(
//                    RoundedRectangle(cornerRadius: 30)
//                        .stroke()
//                )
//                .background(
//                    RoundedRectangle(cornerRadius: 30)
//                        .fill(Color(red: 0.95, green: 0.75, blue: 0.09))
//                )
//                .foregroundColor(.black)
//                .padding()
//            }
//            .padding()
//            .background(Color.white)
//            .cornerRadius(12)
//            .shadow(radius: 10)
//            Spacer()
//        }
//        .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
//    }
//}
//
//// Example PreviewProvider
//struct EditChore_Previews: PreviewProvider {
//    static var previews: some View {
//        EditChore(
//            chore: .constant("Some Chore"),
//            selectedPerson: .constant("test1"),
//            selectedFrequency: .constant(1
//                                        ),
//            people: ["Non Specific", "test1", "test2", "test3"],
//            onSaveEdit: { print("Changes saved") },
//            onCancelEdit: { print("Editing cancelled") }
//        )
//        .previewLayout(.sizeThatFits)
//        .padding(10)
//    }
//}
