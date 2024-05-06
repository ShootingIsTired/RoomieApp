//
//  SelectPerson.swift
//  RoomieApp
//
//  Created by Fiona on 2024/5/5.
//

import Foundation
import SwiftUI

struct SelectPerson: View {
    @Binding var selectedPerson: String
    @State private var showPersonPicker = false
    let people: [String]
    
    var body: some View {
        Button{
            self.showPersonPicker.toggle()
        }label:{
            HStack {
                Image("person")
                    .frame(width: 16, height: 16)
                Text(selectedPerson)
                    .foregroundStyle(.black)
                Image("Polygon 1")
                    .frame(width: 16, height: 16)
            }
        }
        if showPersonPicker{
            Picker("",selection: $selectedPerson){
                ForEach(people, id:\.self){
                    person in
                    Button{
                    }label:{
                        Text(person).tag(person)
                            .onTapGesture {
                                self.selectedPerson = person
                                self.showPersonPicker = false  // Hide picker after selection
                            }
                    }
                }
            }
            .pickerStyle(WheelPickerStyle())
            .onChange(of: selectedPerson){
                self.showPersonPicker = false  // Ensure picker hides when disappearing
            }
        }
//        Menu {
//            ForEach(people, id: \.self) { person in
//                Button(person) {
//                    self.selectedPerson = person
//                }
//            }
//        } label: {
//            HStack {
//                Image("person")
//                    .frame(width: 16, height: 16)
//                Text(selectedPerson)
//                    .foregroundStyle(.black)
//                Image("Polygon 1")
//                    .frame(width: 16, height: 16)
//            }
//        }
//        .onAppear {
//            self.selectedPerson = "Unassigned"  // 重置选项为“Unassigned”每次视图出现时
//        }
//        .onDisappear {
//            self.selectedPerson = "Unassigned"  // 视图消失时重置
//        }
    }
}

//import SwiftUI

struct SelectPerson_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var selectedPerson = "Unassigned"  // Initial state for the preview
        let people = ["Non Specific", "test1", "test2", "test3"]  // Sample data

        var body: some View {
            SelectPerson(selectedPerson: $selectedPerson, people: people)
        }
    }

    static var previews: some View {
        PreviewWrapper()
            .previewLayout(.sizeThatFits)
            .padding(10)  // Optional: Adds padding around the preview for clarity
    }
}
