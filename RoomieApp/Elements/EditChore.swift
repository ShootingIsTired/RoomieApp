////
////  EditChore.swift
////  RoomieApp
////
////  Created by Fiona on 2024/5/9.
////
//
//import Foundation
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
//
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
