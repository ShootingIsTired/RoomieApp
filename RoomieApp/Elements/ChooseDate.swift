//
//  ChooseDate.swift
//  RoomieApp
//
//  Created by Fiona on 2024/5/5.
//

import Foundation
import SwiftUI

struct ChooseDate: View {
    @Binding var selectedDate: Date
    @State private var showDatePicker = false

    var body: some View {
        HStack{
            Button{
                self.showDatePicker.toggle()
            }label:{
                Image("calendar-check")
                    .frame(width: 16, height: 16)
                Text("Choose Date")
                    .foregroundColor(.black)
//                        .underline()
            }
            if showDatePicker{
                DatePicker("",selection: $selectedDate, displayedComponents: .date)
            }
        }
    }
}

struct ChooseDateView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var selectedDate = Date()  // Current date

        var body: some View {
            ChooseDate(selectedDate: $selectedDate)
        }
    }

    static var previews: some View {
        PreviewWrapper()
//            .previewLayout(.sizeThatFits)
//            .padding(10)
    }
}
