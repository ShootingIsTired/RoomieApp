import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ScheduleView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var selectedPage: String?
    @State private var showMenuBar = false
    @State private var selectedDate = Date()
    @State private var showingAddSchedulePopup = false
    @State private var selectedEventID: String? = nil
    
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
        .sheet(isPresented: $showingAddSchedulePopup) {
            addSchedulePopup()
        }
    }
    
    var schedule: some View {
        VStack(spacing: 0) {
            header
            Spacer()
            timeline
            Spacer()
            Button(action: {
                withAnimation {
                    showingAddSchedulePopup = true
                }
            }) {
                Text("Add Schedule")
                    .font(Font.custom("Noto Sans", size: 16))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 50)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.bottom, 20)
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
                    .imageScale(.large)
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
                .font(Font.custom("Noto Sans", size: 20))
                .bold()
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
        GeometryReader { geometry in
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(8..<24) { hour in
                        HStack(alignment: .top) {
                            Text(String(format: "%02d", hour))
                                .frame(width: 40, alignment: .trailing)
                                .padding(.trailing, 10)
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(minHeight: geometry.size.height / CGFloat(24 - 8), maxHeight: .infinity)
                                .overlay(
                                    eventsOverlay(for: hour)
                                )
                        }
                        .frame(minHeight: geometry.size.height / CGFloat(24 - 8), maxHeight: .infinity)
                    }
                }
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
        }).sorted(by: { $0.start_time < $1.start_time }) {
            HStack(spacing: 5) {
                ForEach(events) { event in
                    EventView(event: event, selectedEventID: $selectedEventID)
                        .environmentObject(authViewModel)
                }
            }
        }
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
    
    @State private var newScheduleContent = ""
    @State private var newScheduleDate = Date()
    @State private var newScheduleStartTime = Date()
    @State private var newScheduleEndTime = Date()
    @State private var newScheduleMode = "Normal"

    func addSchedulePopup() -> some View {
        VStack(spacing: 20) {
            Text("Add a new schedule:")
                .font(Font.custom("Noto Sans", size: 18))
                .fontWeight(.medium)
                .padding(.top, 20)

            TextField("Schedule Content", text: $newScheduleContent)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            DatePicker("Date", selection: $newScheduleDate, displayedComponents: .date)
                .padding(.horizontal)

            DatePicker("Start Time", selection: $newScheduleStartTime, displayedComponents: .hourAndMinute)
                .padding(.horizontal)

            DatePicker("End Time", selection: $newScheduleEndTime, displayedComponents: .hourAndMinute)
                .padding(.horizontal)
            
            Picker("Mode", selection: $newScheduleMode) {
                    Text("Normal").tag("Normal")
                    Text("Quiet").tag("Quiet")
                    Text("Alone").tag("Alone")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

            HStack {
                Button(action: {
                    if !newScheduleContent.isEmpty {
                        withAnimation {
                            Task {
                                let calendar = Calendar.current
                                let startTime = calendar.date(bySettingHour: calendar.component(.hour, from: newScheduleStartTime),
                                                              minute: calendar.component(.minute, from: newScheduleStartTime),
                                                              second: 0, of: newScheduleDate) ?? newScheduleStartTime
                                let endTime = calendar.date(bySettingHour: calendar.component(.hour, from: newScheduleEndTime),
                                                            minute: calendar.component(.minute, from: newScheduleEndTime),
                                                            second: 0, of: newScheduleDate) ?? newScheduleEndTime
                                await authViewModel.addSchedule(content: newScheduleContent, startTime: startTime, endTime: endTime, mode: newScheduleMode)
                                newScheduleContent = ""
                                showingAddSchedulePopup = false
                            }
                        }
                    }
                }) {
                    Text("SAVE")
                        .font(Font.custom("Noto Sans", size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 50)
                        .background(Color.black)
                        .cornerRadius(8)
                }
                .padding(.bottom, 20)

                Button(action: {
                    withAnimation {
                        newScheduleContent = ""
                        showingAddSchedulePopup = false
                    }
                }) {
                    Text("EXIT")
                        .font(Font.custom("Noto Sans", size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 50)
                        .background(Color.gray)
                        .cornerRadius(8)
                }
                .padding(.bottom, 20)
            }
        }
        .frame(width: 320, height: 400)
        .background(Color.white)
        .cornerRadius(15)
    }
}
struct EventView: View {
    var event: Schedules
    @Binding var selectedEventID: String?
    @State private var member: Member? = nil
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(formattedTimeRange(start: event.start_time, end: event.end_time))")
                    .font(.caption)
                    .foregroundColor(.white)
                Spacer()
                if authViewModel.currentUser?.id == member?.id {
                    Button(action: {
                        Task {
                            await authViewModel.deleteSchedule(event: event)
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                            .imageScale(.small)
                            .padding(.leading, 4)
                    }
                }
            }
            Text(event.content)
                .font(.headline)
                .foregroundColor(.white)
            if let member = member {
                Text(member.name)
                    .font(.subheadline)
                    .foregroundColor(.white)
                Spacer()
                Text(event.mode)
                    .font(.caption)
                    .foregroundColor(.white)
            } else {
                Text("Loading...")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .onAppear {
                        fetchMemberData()
                    }
            }
        }
        .padding(10)
        .background(GeometryReader { geometry in
            Rectangle()
                .fill(event.modeColor)
                .frame(height: calculateHeight(from: event.start_time, to: event.end_time, in: geometry))
        })
        .cornerRadius(10)
        .foregroundColor(.white)
        .shadow(radius: 2)
        .padding(.vertical, 2)
        .frame(width: calculateEventWidth())
        .frame(minHeight: 100)
        .zIndex(selectedEventID == event.id ? 1 : 0) // Adjust z-index based on selection
        .onTapGesture {
            selectedEventID = event.id // Set the selected event ID on tap
        }
    }
    
    func formattedTimeRange(start: Date, end: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let startTime = formatter.string(from: start)
        let endTime = formatter.string(from: end)
        return "\(startTime) ~ \(endTime)"
    }
    
    func calculateHeight(from start: Date, to end: Date, in geometry: GeometryProxy) -> CGFloat {
        let duration = end.timeIntervalSince(start)
        let hourHeight = geometry.size.height / 16
        let calculatedHeight = hourHeight * CGFloat(duration / 3600) * 6
        let minHeight: CGFloat = 100
        print("height", max(calculatedHeight, minHeight), calculatedHeight)
        return max(calculatedHeight, minHeight)
    }

    private func fetchMemberData() {
        Task {
            member = await fetchMember(for: event.member)
        }
    }

    private func fetchMember(for reference: DocumentReference) async -> Member? {
        do {
            let snapshot = try await reference.getDocument()
            let member = try snapshot.data(as: Member.self)
            return member
        } catch {
            print("Failed to fetch member with reference \(reference.path): \(error.localizedDescription)")
            return nil
        }
    }

    private func calculateEventWidth() -> CGFloat {
        let overlappingEvents = authViewModel.overlappingEvents(for: event)
        let calculatedWidth = (UIScreen.main.bounds.width - 100) / CGFloat(overlappingEvents.count)
        let minWidth: CGFloat = 150
        
        return max(calculatedWidth, minWidth)
    }
}



extension Schedules {
    var modeColor: Color {
        switch mode {
        case "Normal":
            return .blue
        case "Alone":
            return .orange
        case "Quiet":
            return .green
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

// Extend AuthViewModel to fetch and add schedules for a specific date
extension AuthViewModel {
    func overlappingEvents(for event: Schedules) -> [Schedules] {
        let oneHour: TimeInterval = 1800 // 1 hour in seconds
        return currentRoom?.schedulesData?.filter { otherEvent in
            return (otherEvent.start_time < event.end_time && otherEvent.end_time > event.start_time) ||
                   abs(otherEvent.start_time.timeIntervalSince(event.end_time)) < oneHour ||
                   abs(otherEvent.end_time.timeIntervalSince(event.start_time)) < oneHour
        } ?? []
    }
    func fetchSchedules(for date: Date) {
        print("___fetch schedule for", date)
        guard let roomID = currentRoom?.id else { return }

        Firestore.firestore().collection("rooms").document(roomID).collection("schedules")
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("No schedules found")
                    return
                }
                self.currentRoom?.schedulesData = documents.compactMap { document in
                    if var schedule = try? document.data(as: Schedules.self) {
                        return schedule
                    }
                    return nil
                }
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }
        print(self.currentRoom?.schedulesData ?? "---")
    }
    
    func addSchedule(content: String, startTime: Date, endTime: Date, mode: String) async {
        guard let roomID = currentRoom?.id, let user = currentUser else { return }
        
        let newSchedule = Schedules(
            member: Firestore.firestore().collection("members").document(user.id ?? ""),
            content: content,
            start_time: startTime,
            end_time: endTime,
            mode: mode
        )
        
        do {
            _ = try Firestore.firestore().collection("rooms").document(roomID).collection("schedules").addDocument(from: newSchedule)
            fetchSchedules(for: Date())
        } catch {
            print("Failed to add schedule: \(error.localizedDescription)")
        }
    }
    
    func deleteSchedule(event: Schedules) async {
        guard let roomID = currentRoom?.id, let eventID = event.id else { return }

        do {
            try await Firestore.firestore().collection("rooms").document(roomID).collection("schedules").document(eventID).delete()
            fetchSchedules(for: Date())
        } catch {
            print("Failed to delete schedule: \(error.localizedDescription)")
        }
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
    
    func convertToLocalTime() -> Date {
        let timeZoneOffset = TimeZone.current.secondsFromGMT(for: self)
        return addingTimeInterval(TimeInterval(timeZoneOffset))
    }
}

