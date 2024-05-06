//
//  ChooseFrequency.swift
//  RoomieApp
//
//  Created by Fiona on 2024/5/6.
//

import Foundation
import SwiftUI

struct ChooseFrequency: View {
//    @Binding var selectedDate: Date
//    @State private var showDatePicker = false
    
    @Binding var selectedFrequency:Int
    @State private var frequency:ClosedRange<Int> = 1...30
    @State private var showFrequencyPicker = false

    var body: some View {
        HStack{
            Button{
//                self.showDatePicker.toggle()
                self.showFrequencyPicker.toggle()
            }label:{
                Image("calendar-check")
                    .frame(width: 16, height: 16)
                Text("Every \(selectedFrequency > 0 ? "\(selectedFrequency)":"?") day\(selectedFrequency > 1 ? "s":"")")
//                Text("Choose Frequency")
                    .foregroundColor(.black)
//                        .underline()
            }
            if showFrequencyPicker{
                Picker("", selection:$selectedFrequency){
                    ForEach(frequency, id: \.self){
                        day in Button{ 
                        }label:{
                            Text("\(day) day\(day > 1 ? "s" : "")")
                        }
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .onChange(of: selectedFrequency){
                    self.showFrequencyPicker = false  // Ensure picker hides when disappearing
                }
                .frame(width: 100)
            }
        }
    }
}

struct ChooseFrequencyView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
//        @State private var selectedDate = Date()  // Current date
        @State private var selectedFrequency = 0  // Current date
        var body: some View {
            ChooseFrequency(selectedFrequency: $selectedFrequency)
        }
    }

    static var previews: some View {
        PreviewWrapper()
//            .previewLayout(.sizeThatFits)
//            .padding(10)
    }
}
