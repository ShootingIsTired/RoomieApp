//
//  EditTask.swift
//  RoomieApp
//
//  Created by Fiona on 2024/5/9.
//

import Foundation
import SwiftUI

struct EditTask: View {
    @Binding var task: String
//    @Binding var selectedDate: Date
    @Binding var selectedTime: Date
    @Binding var selectedPerson: String
    let people: [String]
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
                    SelectPerson(selectedPerson: $selectedPerson, people: people)
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
    static var previews: some View {
        EditTask(
            task: .constant("Some task"),
//            selectedDate: .constant(Date()),
            selectedTime: .constant(Date()),
            selectedPerson: .constant("test1"),
            people: ["Non Specific", "test1", "test2", "test3"],
            onSaveEdit: { print("Changes saved") },
            onCancelEdit: { print("Editing cancelled") }
        )
        .previewLayout(.sizeThatFits)
        .padding(10)
    }
}
