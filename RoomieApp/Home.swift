import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct HomeView: View {
    @Binding var selectedPage: String?
    @State private var showMenuBar = false
    @State private var showAddTask = false
    @State private var showEditTask = false
    @State private var editReminder = false
    @State private var editUnassigned = false
    @State private var tasks: [Tasks] = []
    @State private var content = ""
    @State private var selectedPerson = "Unassigned"
    @State private var selectedTime = Date()
    @State private var currentTaskId = ""

    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        ZStack(alignment: .leading) {
            if let members = authViewModel.currentRoom?.membersData {
                Home
                    .contentShape(Rectangle())
                    .onTapGesture {
                        hideOverlays()
                    }

                if showMenuBar {
                    MenuBar(selectedPage: $selectedPage)
                        .transition(.move(edge: .leading))
                }

                if showAddTask {
                    AddTask(
                        task: $content,
                        selectedTime: $selectedTime,
                        selectedPerson: $selectedPerson,
                        members: members,
                        onAddTask:       addNewTask,
                        onCancel: {
                            showAddTask = false
                            resetTaskState()
                            hideOverlays()
                        }
                    )
                }

                if showEditTask {
                    EditTask(
                        task: $content,
                        selectedTime: $selectedTime,
                        selectedPerson: $selectedPerson,
                        members: members,
                        onSaveEdit: saveEditTask,
                        onCancelEdit: {
                            showEditTask = false
                            resetTaskState()
                            hideOverlays()
                        }
                    )
                }
            }
        }
    }

    private var Home: some View {
        VStack(spacing: 0) {
            header
            reminderSection
            unassignedTasksSection
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }

    private var header: some View {
        HStack {
            Button(action: toggleMenuBar) {
                Image(systemName: "line.horizontal.3")
                    .imageScale(.large)
            }
            Spacer()
            Text("HOME")
                .font(Font.custom("Noto Sans", size: 24))
                .bold()
                .foregroundColor(Color(red: 0, green: 0.23, blue: 0.44))
            Spacer()
        }
        .padding()
        .background(Color.white)
        .shadow(radius: 2)
    }

    @ViewBuilder private func reminderRow(task: Tasks) -> some View {
        HStack {
            Text(formattedDate(task.time))
                .frame(width: 50, alignment: .leading)
            Spacer()
            Text(formattedTime(task.time))
                .frame(width: 70,alignment: .leading)
            Spacer()
            Text(task.content)
                .frame(/*width: 80,*/ alignment: .leading)
            Spacer()
            HStack {
                if task.assigned_person != nil, task.isUnassigned == false {
                    Image("person")
                } else {
                    Image("person-x")
                }
                if task.assigned_person == nil {
                    Text("Non Specific")
                } else {
                    Text(memberName(for: task.assigned_person!.documentID))
                }
            }
            .frame(/*width: 140, */alignment: .leading)
            Spacer()
            if editReminder {
                Button(action: {
                    Task {
                        await authViewModel.removeTask(roomID: authViewModel.currentRoom?.id ?? "", taskID: task.id ?? "")
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                }
            } else {
                Image(systemName: "chevron.right")
            }
        }
        .padding(10)
        .background(
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 370)
                .background(Color(red: 0.96, green: 0.96, blue: 0.93))
                .cornerRadius(15)
        )
        .onTapGesture {
            self.selectedPerson = task.assigned_person?.documentID ?? "Non Specific"
            self.selectedTime = task.time
            self.content = task.content
            self.currentTaskId = task.id!
            self.showEditTask = true
//            print(self.selectedPerson,
//                  self.selectedTime,
//                  self.content)
        }
    }

    private var reminderSection: some View {
        VStack {
            sectionHeader(title: "Reminders", isEditing: $editReminder)
            ScrollView {
                VStack {
                    ForEach(authViewModel.currentRoom?.tasksData ?? [], id: \.id) { task in
                        if task.isUnassigned == false {
                            reminderRow(task: task)
                        }
                    }
                }
//                .background(Color(red: 0.96, green: 0.96, blue: 0.93))
                .padding(.horizontal)
            }
        }
    }

    @ViewBuilder private func unassignedTaskRow(task: Tasks) -> some View {
        HStack {
            Text(formattedDate(task.time))
                .frame(width: 50, alignment: .leading)
            Spacer()
            Text(formattedTime(task.time))
                .frame(width: 70, alignment: .leading)
            Spacer()
            Text(task.content)
                .frame(/*width: 80, */alignment: .leading)
            Spacer()
            HStack{
                Image(systemName: "person")
                Text("Unassigned")
            }
            Spacer()
            if editUnassigned {
                Button(action: {
                    Task {
                        await authViewModel.removeTask(roomID: authViewModel.currentRoom?.id ?? "", taskID: task.id ?? "")
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                }
            } else {
                Image(systemName: "chevron.right")
            }
        }
        .padding(10)
        .background(
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 370)
                .background(Color(red: 0.96, green: 0.96, blue: 0.93))
                .cornerRadius(15)
        )
        .onTapGesture {
            self.selectedPerson = "Unassigned"
            self.selectedTime = task.time
            self.content = task.content
            self.currentTaskId = task.id!
            self.showEditTask = true
        }
    }

    private var unassignedTasksSection: some View {
        VStack {
            if authViewModel.currentRoom?.membersData != nil {
                sectionHeader(title: "Unassigned Tasks", isEditing: $editUnassigned, showAddButton: true)
                ScrollView {
                    VStack {
                        ForEach(authViewModel.currentRoom?.tasksData ?? [], id: \.id) { task in
                            if task.isUnassigned == true {
                                unassignedTaskRow(task: task)
                            }
                        }
                    }
//                    .background(Color(red: 0.96, green: 0.96, blue: 0.93))
                    .padding(.horizontal)
                }
            }
        }
    }

    private func sectionHeader(title: String, isEditing: Binding<Bool>, showAddButton: Bool = false) -> some View {
        HStack {
            Text(title)
                .font(Font.custom("Noto Sans", size: 20))
            Spacer()
            if !isEditing.wrappedValue {
                if showAddButton {
                    Button(action: { showAddTask.toggle()
                        resetTaskState()
                    }) {
                        Text("ADD")
                            .padding(5)
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 1, green: 0.87, blue: 0.44)))
                            .foregroundColor(.black)
                    }
                }
                Button(action: { isEditing.wrappedValue = true }) {
                    Text("EDIT")
                        .padding(5)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 1, green: 0.87, blue: 0.44)))
                        .foregroundColor(.black)
                }
            } else {
                Button(action: {
                    isEditing.wrappedValue = false
                    resetTaskState()
                }) {
                    Text("BACK")
                        .padding(5)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 1, green: 0.87, blue: 0.44)))
                        .foregroundColor(.black)
                }
            }
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 15)
    }

    private func addNewTask() {
//        resetTaskState()
        if let roomID = authViewModel.currentRoom?.id, !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            authViewModel.addNewTask(roomID: roomID, time: selectedTime, content: content, assigned_person: selectedPerson)
        }
        hideOverlays()
    }

    private func saveEditTask() {
        if let roomID = authViewModel.currentRoom?.id, !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            Task{
                await authViewModel.updateTask(roomID: roomID, taskID: currentTaskId, time: selectedTime, content: content, assigned_person: selectedPerson)
            }
        }
        hideOverlays()
    }

    private func resetTaskState() {
        content = ""
        selectedPerson = "Unassigned"
        selectedTime = Date()
    }

    private func hideOverlays() {
        showMenuBar = false
        showAddTask = false
        showEditTask = false
    }

    private func toggleMenuBar() {
        withAnimation {
            showMenuBar.toggle()
        }
    }

    private func memberName(for id: String) -> String {
        if let member = authViewModel.currentRoom?.membersData?.first(where: { $0.id == id }) {
            return member.name
        }
        return id // Fallback to showing the ID if no match is found
    }
}

private func formattedTime(_ time: Date) -> String {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter.string(from: time)
}

private func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd"
    return formatter.string(from: date)
}

struct HomeView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State var selectedPage: String? = "Home"
        @StateObject var authViewModel = AuthViewModel()

        var body: some View {
            HomeView(selectedPage: $selectedPage)
                .environmentObject(authViewModel)
        }
    }

    static var previews: some View {
        PreviewWrapper()
    }
}
