//
//  ChooseFrequency.swift
//  RoomieApp
//
//  Created by Fiona on 2024/5/6.
//

//import Foundation
//import SwiftUI
//
//struct ChooseFrequency: View {
////    @Binding var selectedDate: Date
////    @State private var showDatePicker = false
//    
//    @Binding var selectedFrequency:Int
//    @State private var frequency:ClosedRange<Int> = 1...30
//    @State private var showFrequencyPicker = false
//
//    var body: some View {
//        HStack{
//            Button{
////                self.showDatePicker.toggle()
//                self.showFrequencyPicker.toggle()
//            }label:{
//                Image("calendar-check")
//                    .frame(width: 16, height: 16)
//                Text("Every \(selectedFrequency > 0 ? "\(selectedFrequency > 1 ? "\(selectedFrequency)":"")":"?") day\(selectedFrequency > 1 ? "s":"")")
////                Text("Choose Frequency")
//                    .foregroundColor(.black)
////                        .underline()
//            }
//            if showFrequencyPicker{
//                Picker("", selection:$selectedFrequency){
//                    ForEach(frequency, id: \.self){
//                        day in Button{ 
//                        }label:{
//                            Text("\(day) day\(day > 1 ? "s" : "")")
//                        }
//                    }
//                }
//                .pickerStyle(WheelPickerStyle())
//                .onChange(of: selectedFrequency){
//                    self.showFrequencyPicker = false  // Ensure picker hides when disappearing
//                }
//                .frame(width: 100)
//            }
//        }
//    }
//}
//
//struct ChooseFrequencyView_Previews: PreviewProvider {
//    struct PreviewWrapper: View {
////        @State private var selectedDate = Date()  // Current date
//        @State private var selectedFrequency = 0  // Current date
//        var body: some View {
//            ChooseFrequency(selectedFrequency: $selectedFrequency)
//        }
//    }
//
//    static var previews: some View {
//        PreviewWrapper()
////            .previewLayout(.sizeThatFits)
////            .padding(10)
//    }
//}

import SwiftUI

struct ChooseFrequency: View {
    @Binding var selectedFrequency: Int
    @State private var showFrequencyPicker = false
    @State private var customFrequency = ""
    @State private var frequencySelection = -1
    @State private var showingAlert = false
    @State private var customFrequencySubmitted = false  // To control the visibility of custom fields

    let frequencyOptions = ["Every day", "Every week", "Every month", "Custom"]

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.showFrequencyPicker.toggle()
                }) {
                    HStack {
                        Image(systemName: "calendar") // Using a system image
                            .frame(width: 16, height: 16)
                        Text(displayFrequencyText())
                            .foregroundColor(.black)
                        Image(systemName: "chevron.right")
                    }
                }

                if showFrequencyPicker {
                    Picker("Frequency", selection: $frequencySelection) {
                        ForEach(0..<frequencyOptions.count, id: \.self) { index in
                            Text(self.frequencyOptions[index]).tag(index)
                        }
                    }
                    .accentColor(.black)
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: frequencySelection) { newValue in
                        updateFrequency(newValue)
                    }
                }
                if frequencySelection == 3
                    && !customFrequencySubmitted
                { // Custom option and not yet submitted
                    TextField("Enter days", text: $customFrequency)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button("Submit") {
                        handleCustomFrequencySubmission()
                    }
                    .padding()
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Invalid Input"), message: Text("Please enter a valid number."), dismissButton: .default(Text("OK")))
                    }
                }
            }
        }.foregroundColor(.black)
    }

    private func displayFrequencyText() -> String {
        if customFrequencySubmitted && frequencySelection == 3 {
            switch selectedFrequency{
            case 1:
                frequencySelection = 0
                return "Every day"
            case 7:
                frequencySelection = 1
                return "Every week"
            case 30:
                frequencySelection = 2
                return "Every month"
            default:
                return "Every \(selectedFrequency) days"
            }
        }
        
        switch frequencySelection {
        case 0:
            return "Every day"
        case 1:
            return "Every week"
        case 2:
            return "Every month"
        case 3:
            return "Custom"
        default:
            return "Select Frequency"
        }
    }

    private func updateFrequency(_ selection: Int) {
        if selection == 3 {
            selectedFrequency = 0 // Reset frequency when custom is selected
            customFrequency = "" // Clear previous custom input
            customFrequencySubmitted = false // Reset submission status
        } else {
            switch selection {
            case 0:
                selectedFrequency = 1 // Daily
            case 1:
                selectedFrequency = 7 // Weekly
            case 2:
                selectedFrequency = 30 // Monthly
            default:
                break
            }
            customFrequencySubmitted = false // Ensure this is reset when changing from custom
        }
        showFrequencyPicker = false
    }
    
    private func handleCustomFrequencySubmission() {
        if let value = Int(customFrequency), value > 0 {
            selectedFrequency = value
            customFrequencySubmitted = true
            showFrequencyPicker = false // Optionally hide the picker after submission
        } else {
            showingAlert = true
        }
    }
}

struct ChooseFrequencyView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseFrequency(selectedFrequency: .constant(1))
    }
}
