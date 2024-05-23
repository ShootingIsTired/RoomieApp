//
//  SelectPerson.swift
//  RoomieApp
//
//  Created by Fiona on 2024/5/5.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct SelectPerson: View {
    @Binding var selectedPerson: String
    @State private var showPersonPicker = false
//    let people: [String]
    let members: [Member]
    
    private func memberName(for id: String) -> String {
            if let member = members.first(where: { $0.id == id }) {
                return member.name
            }
            return id // Fallback to showing the ID if no match is found
        }
    
    var body: some View {
        HStack{  // Ensure no spacing between elements in the VStack
            // Button to toggle picker visibility
            Button {
                self.showPersonPicker.toggle()
            } label: {
                HStack {
//                    Image("person").frame(width: 16, height: 16)
                    Image(systemName: "person").foregroundColor(.black)
                    Text(memberName(for: selectedPerson))
                        .foregroundStyle(.black)
//                    Image("Polygon 1")
                    Image(systemName: "chevron.right")
//                        .frame(width: 16, height: 16)
                        .foregroundColor(.black)
                }
            }

            // Picker appears directly under the button without any space
            if showPersonPicker {
                Picker("", selection: $selectedPerson) {
//                    Text("Unassigned").tag("Unassigned")
                    Text("Non Specific")
                        .tag("Non Specific")
                    ForEach(members, id: \.id){ member in
                            Text(member.name)
                            .tag(String(member.id ?? "Unassigned"))
                    }
                }
                .accentColor(.black)
                .pickerStyle(MenuPickerStyle())
                .labelsHidden()  // Optionally hide labels if not necessary
                .background(Color.clear)  // Background to capture taps
//                .onTapGesture {
//                    self.showPersonPicker.toggle()  // Hide picker when tapping outside
//                }
            }
        }
        .onChange(of: selectedPerson) { _ in
//            print(selectedPerson)
            self.showPersonPicker = false  // Hide picker when selection changes
        }
    }
        
}

// Preview provider for SwiftUI previews
struct SelectPerson_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var selectedPerson = String()
//        let people = ["Non Specific", "test1", "test2", "test3"]
        let members = [Member]()

        var body: some View {
            SelectPerson(selectedPerson: $selectedPerson, members: members)
        }
    }

    static var previews: some View {
        PreviewWrapper()
            .previewLayout(.sizeThatFits)
            .padding(10)
    }
}
