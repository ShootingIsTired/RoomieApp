import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ScheduleView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var selectedPage: String?
    @State private var showMenuBar = false
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
            Text("Schedule")
                .font(.custom("Krona One", size: 20))
                .foregroundColor(Color(red: 0, green: 0.23, blue: 0.44))
            Spacer()
        }
        .padding()
        .background(Color.white)
        .shadow(radius: 2)
    }
    
    var timeline: some View {
        LazyVStack(spacing: 0) {
            ForEach(0..<24) { hour in
                HStack(alignment: .top) {
                    Text(String(format: "%02d:00", hour))
                        .frame(width: 60, alignment: .trailing)
                        .padding(.trailing, 10)
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 60)
                        .overlay(
                            eventsOverlay(for: hour)
                        )
                }
                .frame(height: 60)
            }
        }
    }
    
    @ViewBuilder
    func eventsOverlay(for hour: Int) -> some View {
        if let events = authViewModel.currentRoom?.schedulesData?.filter({ event in
            let calendar = Calendar.current
            let eventHour = calendar.component(.hour, from: event.start_time)
            return eventHour == hour
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
        case "Do not Disturb":
            return .red
        case "Alone in Room":
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
