//
//  ChooseTime.swift
//  RoomieApp
//
//  Created by Fiona on 2024/5/5.
//

import Foundation
import SwiftUI

struct ChooseTime: View {
    @Binding var selectedTime: Date
    @State private var showTimePicker = false

    var body: some View {
        HStack {
//            Button{
//                self.showTimePicker.toggle()
//            }label:
            HStack
            {
                Image("clock")
                    .frame(width: 16, height: 16)
                Text("Choose Time")
                    .foregroundColor(.black)
            }
//            if showTimePicker {
                DatePicker(
                    "",
                    selection: $selectedTime,
                    displayedComponents: .hourAndMinute
                )
//                .timePickerStyle(WheelTimePickerStyle())  // 或使用其他风格
                .onDisappear {
                    self.showTimePicker = false
                }
//            }
        }
    }
}

struct ChooseTimeView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var selectedTime = Date()  // Current time

        var body: some View {
            ChooseTime(selectedTime: $selectedTime)
        }
    }

    static var previews: some View {
        PreviewWrapper()
//            .previewLayout(.sizeThatFits)
//            .padding(10)
    }
}
