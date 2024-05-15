//
//  AddTask.swift
//  RoomieApp
//
//  Created by Fiona on 2024/5/9.
//

import Foundation
import SwiftUI

struct AddTask: View {
    @Binding var task: String
//    @Binding var selectedDate: Date
    @Binding var selectedTime: Date
    @Binding var selectedPerson: String
    let people: [String]
    let onAddTask: () -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack {
            Spacer()
            VStack {
                HStack{
                    Text("Add a new Task:")
                        .font(.headline)
                    Spacer()
                    Button(action: onCancel) {
                        Image(systemName: "xmark.circle")
//                            .frame(width:18, height:18)
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
//                    Image("calendar-check")
                    Image(systemName: "calendar")
                    DatePicker("Select Date", selection: $selectedTime, displayedComponents: .date)
                }.padding([.top, .leading, .trailing])
                HStack{
//                    Image("clock")
                    Image(systemName: "clock")
                    DatePicker("Select Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                }.padding(.horizontal)
                HStack{
                    SelectPerson(selectedPerson: $selectedPerson, people: people)
                }.padding(.horizontal)
                Button(action: onAddTask) {
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



//var AddTask: some View {
//    VStack {
//        Spacer()  // Pushes everything to center
//        VStack {
//            HStack{
//                Text("Add a new Task:")
//                Spacer()
//                Button{
//                    self.showAddTask.toggle()
//                }label:{
//                    Image("close-circle_outline")
//                }
//                .frame(width: 18, height: 18)
//            }
//            .frame(width: 260)
//            ZStack{
//                RoundedRectangle(cornerRadius: 15)
//                    .stroke(.black.opacity(0.33), lineWidth: 1)
//                    .frame(width: 253, height: 140)
//                    .background(Color(red: 0.96, green: 0.96, blue: 0.86).opacity(0.33))
//                    .overlay(
//                        TextField("Type in here", text: $task)
//                            .padding(10)
//                            .frame(alignment:.top)
//                    )
//            }
//            HStack{
//                ChooseDate(selectedDate: $selectedDate)}
//            HStack{
//                ChooseTime(selectedTime: $selectedTime)
//            }
//            HStack{
//                SelectPerson(selectedPerson: $selectedPerson, people: people)
//            }
//            Button{
//                addNewTask()
//                self.showAddTask = false
//            }label:{

//RoundedRectangle(cornerRadius: 8)
//    .inset(by: -1)
//    .stroke(Color(red: 1, green: 0.84, blue: 0.25), lineWidth: 2)
//    .background(Color(red: 1, green: 0.87, blue: 0.44))
//    .frame(width: 36, height: 20)
//    .overlay(
//Text("ADD")
//    .font(Font.custom("Jacques Francois", size: 10))
//    .foregroundColor(.black))
//            }
//            .padding(10)
//        }
//        .padding(10)
//        .frame(width: 300)
//        Spacer()  // Pushes everything to center
//    }
//    .background(.white)
//    .border(.black)
//    .frame(maxWidth: .infinity, maxHeight: 400)
//    // Ensure VStack takes full screen
//}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTask(
            task: .constant("Complete the project"),
//            selectedDate: .constant(Date()),
            selectedTime: .constant(Date()),
            selectedPerson: .constant("Unassigned"),
            people: ["Non Specific", "test1", "test2", "test3"],
            onAddTask: { print("Task added") },
            onCancel: { print("Cancelled") }
        )
        .previewLayout(.sizeThatFits)
        .padding(10)
    }
}
