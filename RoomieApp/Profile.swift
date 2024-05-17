import SwiftUI

//struct Member {
//    var name: String
//    var birthday: String
//    var id: String = "B10705000"
//    var department: String = "資管三"
//    var password: String = "123456"
//}


struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
//    @ObservedObject var viewMembers = ViewMembers()
//    @ObservedObject var viewRooms = ViewRooms()
    let standardWidth = UIScreen.main.bounds.width - 90
    @Binding var selectedPage: String?
    @State private var newRuleText = ""
    @State private var isEditingMyInfo = false
    @State private var showPassword = false
    @State private var showMenuBar = false
    @State private var showingAddRulePopup = false
    @State private var isEditingRoom = false
    @State private var isEditingRules = false
    @State private var isEditingMembers = false
    
    @State private var editedName: String = ""
    @State private var editedBirthday: String = ""
    @State private var editedEmail: String = ""
    @State private var editedPassword: String = ""
    
    
//    @State private var rules = ["進房間敲門", "吹頭髮去廁所"]
//    @State private var currentUser = Members(name: "Asuka", status: "資管三", birthday: "05/21", room: "411", email: "b10705039@ntu.edu.tw", password: "password123")
//    @State private var roomName = "女三舍312"
//    @State private var roomID = "a12n32"
    

    var body: some View {
        ZStack(alignment: .leading) {
            Profile
                .contentShape(Rectangle())
                .onTapGesture{
                    if showMenuBar{
                        showMenuBar = false
                    }
                }
            if showMenuBar {
                MenuBar(selectedPage: $selectedPage)
                    .transition(.move(edge: .leading))
            }
        }
        .sheet(isPresented: $showingAddRulePopup) {
            addRulePopup()
        }
        .onAppear {
            Task {
                if let user = authViewModel.currentUser {
                    await authViewModel.fetchRoom(for: user)
                }
            }
            // Initialize local state with current user data
            if let user = authViewModel.currentUser {
                editedName = user.name
                editedBirthday = user.birthday
                editedEmail = user.email
                editedPassword = user.password
            }
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
            Text("PROFILE")
                .font(.custom("Krona One", size: 20))
                .foregroundColor(Color(red: 0, green: 0.23, blue: 0.44))
            Spacer()
        }
        .padding()
        .background(Color.white)
        .shadow(radius: 2)
    }
    var Profile: some View {
            VStack(spacing: 0) {
                header
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        rulesSection
                        membersSection
                        myInfoSection
                        roomInfoSection
                    }
                    .padding()
                }
            }
        }
    
    func removeRule(_ rule: String) {
        Task {
            await authViewModel.removeRule(rule: rule)
        }
    }

    var rulesSection: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Rules")
                    .font(Font.custom("Noto Sans", size: 20))
                Spacer()
                Button("ADD") {
                    showingAddRulePopup = true
                }
                .buttonStyle(ColoredButtonStyle())
                Button(isEditingRules ? "DONE" : "EDIT") {
                    withAnimation {
                        isEditingRules.toggle()
                    }
                }
                .buttonStyle(ColoredButtonStyle())
            }
            .padding(.horizontal)

            if let room = authViewModel.currentRoom {
                ForEach(room.rules, id: \.self) { rule in
                    HStack {
                        Text(rule)
                            .padding(.vertical, 4)
                            .padding(.horizontal)
                            .background(Color(red: 0.96, green: 0.96, blue: 0.93))
                            .cornerRadius(8)
                        
                        if isEditingRules {
                            Button(action: {
                                withAnimation {
                                    removeRule(rule)
                                }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                                    .imageScale(.large)
                            }
                        }
                    }
                    .frame(width: standardWidth, alignment: .leading)
                    .padding(.horizontal)
                }
            } else {
                Text("No room available.")
            }
        }
    }

    
    func addRulePopup() -> some View {
        VStack(spacing: 20) {
            Text("Add a new rule:")
                .font(Font.custom("Noto Sans", size: 18))
                .fontWeight(.medium)
                .padding(.top, 20)

            TextEditor(text: $newRuleText)
                .frame(height: 150)
                .padding(4)
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                .cornerRadius(8)
                .padding(.horizontal)
            HStack{
                Button(action: {
                    if !newRuleText.isEmpty {
                        withAnimation {
                            Task {
                                await authViewModel.addRule(rule: newRuleText)
                                newRuleText = ""
                                showingAddRulePopup = false
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
                        newRuleText = ""  // Clear text after saving
                        showingAddRulePopup = false
                    }
                }) {
                    Text("EXIT")
                        .font(Font.custom("Noto Sans", size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 50)
                        .background(Color.black)
                        .cornerRadius(8)
                }
                .padding(.bottom, 20)
            }
            
        }
        .frame(width: 320, height: 320)
        .background(Color.white)
        .cornerRadius(15)
    }
    
    var membersSection: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Members")
                    .font(Font.custom("Noto Sans", size: 20))
                Spacer()
                Button(isEditingMembers ? "DONE" : "EDIT") {
                    withAnimation {
                        isEditingMembers.toggle()
                    }
                }
                .buttonStyle(ColoredButtonStyle())
            }
            .padding(.horizontal)


            if let members = authViewModel.currentRoom?.membersData {
                VStack {
                    // Use an indexed loop to manually iterate over the members array
                    ForEach(Array(members.enumerated()), id: \.element.id) { index, member in
                        HStack {
                            memberView(memberInRoom: member)

                            if isEditingMembers {
                                Button(action: {
                                    withAnimation {
                                        if let memberID = member.id {
                                            //authViewModel.deleteMember(memberID: memberID)
                                        }
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                        .imageScale(.large)
                                }
                            }
                        }
                    }
                }
            } else {
                Text("No members available.")
            }


        }
    }


    func memberView(memberInRoom: Member) -> some View {
        HStack(spacing: 5) {
            Text(memberInRoom.name)
                .font(Font.custom("Noto Sans", size: 18))
            Spacer()
            Text(memberInRoom.birthday)
                .font(Font.custom("Noto Sans", size: 16))
            Spacer()
            Text(memberInRoom.status)
                .font(Font.custom("Noto Sans", size: 16))
        }
        .padding(.vertical, 4)
        .padding(.horizontal)
        .background(Color(red: 0.96, green: 0.96, blue: 0.93))
        .cornerRadius(8)
        .padding(.horizontal)
    }

    var myInfoSection: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("My Info")
                    .font(Font.custom("Noto Sans", size: 20))
                Spacer()
                Button(isEditingMyInfo ? "DONE" : "EDIT") {
                    withAnimation {
                        if isEditingMyInfo {
                            // Update member info in Firestore when done editing
                            Task {
                                await authViewModel.updateMember(
                                    name: editedName,
                                    email: editedEmail,
                                    birthday: editedBirthday,
                                    password: editedPassword
                                )
                            }
                        }
                        isEditingMyInfo.toggle()
                    }
                }
                .buttonStyle(ColoredButtonStyle())
            }
            .padding(.horizontal)

            Group {
                if isEditingMyInfo {
                    TextField("Name", text: $editedName)
                    TextField("Birthday", text: $editedBirthday)
                    TextField("Email", text: $editedEmail)
                    TextField("Password", text: $editedPassword)
                } else {
                    Text("Name: \(authViewModel.currentUser?.name ?? "Unknown")")
                    Text("Birthday: \(authViewModel.currentUser?.birthday ?? "Unknown")")
                    Text("Email: \(authViewModel.currentUser?.email ?? "Unknown")")
                    HStack {
                        if showPassword {
                            Text("Password: \(authViewModel.currentUser?.password ?? "Unknown")")
                        } else {
                            Text("Password: **********")
                        }
                        Spacer()
                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .frame(width: standardWidth,alignment: .leading)
            .padding(.vertical, 4)
            .padding(.horizontal)
            .background(Color(red: 0.96, green: 0.96, blue: 0.93))
            .cornerRadius(8)
            .padding(.horizontal)
        }
    }
    var roomInfoSection: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Room Info")
                    .font(Font.custom("Noto Sans", size: 20))
                Spacer()
                Button(isEditingRoom ? "DONE" : "EDIT") {
                    withAnimation {
                        isEditingRoom.toggle()
                    }
                }
                .buttonStyle(ColoredButtonStyle())
            }
            .padding(.horizontal)
            if let room = authViewModel.currentRoom {
                Group {
                    if isEditingRoom {
                        TextField("Room Name", text: Binding(
                            get: { room.name },
                            set: { newName in
                                Task {
                                    await authViewModel.updateRoom(roomID: room.id!, newName: newName)
                                }
                            }
                        ))
                        Text("Room ID: \(room.id ?? "unknown")")
                    } else {
                        Text("Room Name: \(room.name)")
                        Text("Room ID: \(room.id ?? "unknown")")
                    }
                }
                .frame(width: standardWidth, alignment: .leading)
                .padding(.vertical, 4)
                .padding(.horizontal)
                .background(Color(red: 0.96, green: 0.96, blue: 0.93))
                .cornerRadius(8)
                .padding(.horizontal)
            } else {
                Text("Room data not available")
            }
        }
    }
}

struct ColoredButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.black)
            .frame(width: 47, height: 20)
            .background(Color(red: 1, green: 0.87, blue: 0.44))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .inset(by: -0.5)
                    .stroke(Color(red: 1, green: 0.84, blue: 0.25), lineWidth: 1)
            )
    }
}

struct ProfileView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State var selectedPage: String? = "Profile"
        @StateObject var authViewModel = AuthViewModel()

        var body: some View {
            ProfileView(selectedPage: $selectedPage).environmentObject(authViewModel)
        }
    }

    static var previews: some View {
        PreviewWrapper()
    }
}
