import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ScheduleView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var selectedPage: String?
    @State private var showMenuBar = false
    @State private var selectedDate = Date()
    
    var body: some View {
        ZStack(alignment: .leading) {
            schedule
                .contentShape(Rectangle())
                .onTapGesture {
                    if showMenuBar {
                        showMenuBar = false
                    }
                }
            
            if showMenuBar {
                MenuBar(selectedPage: $selectedPage)
                    .transition(.move(edge: .leading))
            }
        }
    }
    
    var schedule: some View {
        VStack(spacing: 0) {
            header
            timeline
            Spacer()
        }
    }
    
    var header: some View {
        HStack {
            Button(action: {
                withAnimation {
                    showMenuBar.toggle()
                }
            }) {
                Image(systemName: "line.horizontal.3")
                    .frame(width: 38, height: 38)
            }
            Spacer()
            Button(action: {
                changeDay(by: -1)
            }) {
                Image(systemName: "chevron.left")
                    .frame(width: 38, height: 38)
            }
            Spacer()
            Text("\(formattedDate(selectedDate))")
                .font(.custom("Krona One", size: 20))
                .foregroundColor(Color(red: 0, green: 0.23, blue: 0.44))
            Spacer()
            Button(action: {
                changeDay(by: 1)
            }) {
                Image(systemName: "chevron.right")
                    .frame(width: 38, height: 38)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .shadow(radius: 2)
    }
    
    var timeline: some View {
        LazyVStack(spacing: 0) {
            ForEach(8..<24) { hour in
                HStack(alignment: .top) {
                    Text(String(format: "%02d", hour))
                        .frame(width: 40, alignment: .trailing)
                        .padding(.trailing, 10)
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 30)
                        .overlay(
                            eventsOverlay(for: hour)
                        )
                }
                .frame(height: 30)
            }
        }
    }
    
    @ViewBuilder
    func eventsOverlay(for hour: Int) -> some View {
        if let events = authViewModel.currentRoom?.schedulesData?.filter({ event in
            let calendar = Calendar.current
            let eventHour = calendar.component(.hour, from: event.start_time)
            let eventDay = calendar.isDate(event.start_time, inSameDayAs: selectedDate)
            return eventHour == hour && eventDay
        }) {
            ForEach(events) { event in
                eventView(event: event)
            }
        }
    }
    
    func eventView(event: Schedules) -> some View {
        VStack(alignment: .leading) {
            Text(event.content)
                .padding(10)
                .background(event.modeColor)
                .cornerRadius(10)
                .foregroundColor(.white)
                .shadow(radius: 2)
        }
        .padding(.vertical, 2)
    }
    
    func changeDay(by days: Int) {
        if let newDate = Calendar.current.date(byAdding: .day, value: days, to: selectedDate) {
            selectedDate = newDate
            authViewModel.fetchSchedules(for: selectedDate)
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
}

struct ScheduleEvent: Identifiable {
    let id = UUID()
    let startTime: String
    let endTime: String
    let title: String
    let color: Color
}

extension Schedules {
    var modeColor: Color {
        switch mode {
        case "Normal":
            return .blue
        case "Alone":
            return .red
        case "Quiet":
            return .yellow
        default:
            return .gray
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State var selectedPage: String? = "Schedule"
        @StateObject var authViewModel = AuthViewModel()

        var body: some View {
            ScheduleView(selectedPage: $selectedPage).environmentObject(authViewModel)
        }
    }
    
    static var previews: some View {
        PreviewWrapper()
    }
}

// Extend AuthViewModel to fetch schedules for a specific date
extension AuthViewModel {
    func fetchSchedules(for date: Date) {
        guard let roomID = currentRoom?.id else { return }
        
        Firestore.firestore().collection("rooms").document(roomID).collection("schedules")
            .whereField("start_time", isGreaterThanOrEqualTo: date.startOfDay())
            .whereField("start_time", isLessThanOrEqualTo: date.endOfDay())
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("No schedules found")
                    return
                }
                self.currentRoom?.schedulesData = documents.compactMap { document in
                    try? document.data(as: Schedules.self)
                }
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }
        print(self.currentRoom?.schedulesData ?? "---")
    }
}

// Date extension to get the start and end of the day
extension Date {
    func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    func endOfDay() -> Date {
        return Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: self)!
    }
}
