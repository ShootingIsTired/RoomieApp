//
//  EditTask.swift
//  RoomieApp
//
//  Created by Fiona on 2024/5/9.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct EditTask: View {
    @Binding var task: String
//    @Binding var selectedDate: Date
    @Binding var selectedTime: Date
    @Binding var selectedPerson: String
    let members: [Member]
//    let people: [String]
    let onSaveEdit: () -> Void
    let onCancelEdit: () -> Void

    var body: some View {
        VStack {
            Spacer()
            VStack {
                HStack{
                    Text("Edit Task:")
                        .font(.headline)
                    Spacer()
                    Button(action: onCancelEdit) {
                        Image(systemName: "xmark.circle")
                    }
                    .foregroundColor(.black)
                }
                .padding()
                TextField("Type in here", text: $task)
                    .padding()
                    .foregroundColor(task.isEmpty ? .gray : .black)
                    .textFieldStyle(.plain)
                    .background(Color(red: 0.96, green: 0.96, blue: 0.86).opacity(0.33))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8) // Stroke outline
                            .stroke(Color.gray, lineWidth: 1)
                    )
                HStack{
                    Image(systemName: "calendar")
                    DatePicker("Select Date", selection: $selectedTime, displayedComponents: .date)
                }.padding([.top,.horizontal])
                HStack{
                    Image(systemName: "clock")
                    DatePicker("Select Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                }.padding(.horizontal)
                HStack{
                    SelectPerson(selectedPerson: $selectedPerson, members:members)
                }.padding(.horizontal)
                Button(action: onSaveEdit) {
                    Text("SAVE")
                        .padding(5)
                        .cornerRadius(30)
                        .overlay(RoundedRectangle(cornerRadius: 30).stroke())
                }
                .foregroundColor(.blue)
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

// Example PreviewProvider
struct EditTask_Previews: PreviewProvider {
        struct PreviewWrapper: View {
            @State private var selectedPerson = "Unassigned"
            //        let people = ["Non Specific", "test1", "test2", "test3"]
            let members = [Member]()
            var body: some View{
                EditTask(
                    task: .constant("Complete the project"),
        //            selectedDate: .constant(Date()),
                    selectedTime: .constant(Date()),
                    selectedPerson: $selectedPerson,
                    members:members,
                    onSaveEdit: { print("Changes saved") },
                    onCancelEdit: { print("Cancelled") }
                )
            }
        }
        static var previews: some View {
            PreviewWrapper()
            .previewLayout(.sizeThatFits)
            .padding(10)
        }
}
