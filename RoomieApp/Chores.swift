//  Chores.swift
//  RoomieApp
import SwiftUI

struct ChoresView: View {
    @Binding var selectedPage: String?
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isEditing = false
    @State private var showAddChore = false
    @State private var editingChore: Chores?
    @State private var showingEditChore = false
    
    @State private var showMenuBar = false

    var body: some View {
        ZStack(alignment: .leading) {
            mainContent
                .overlay(
                    Rectangle()
                        .foregroundColor(.clear)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if showMenuBar {
                                withAnimation {
                                    showMenuBar = false
                                }
                            }
                        }
                        .allowsHitTesting(showMenuBar)  // Only enable hit testing when the menu is visible
                )
            
            if showMenuBar {
                MenuBar(selectedPage: $selectedPage)
                    .transition(.move(edge: .leading))
            }
        }
    }

    var mainContent: some View {
        VStack(spacing: 0) {
            header
            choreList
            editAndAddButtons
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
            Text("CHORES")
                .font(.custom("Krona One", size: 20))
                .foregroundColor(Color(red: 0, green: 0.23, blue: 0.44))
            Spacer()
        }
        .padding()
        .background(Color.white)
        .shadow(radius: 2)
    }

    var choreList: some View {
        NavigationView {
            List {
                ForEach(authViewModel.currentRoom?.choresData ?? [], id: \.id) { chore in
                    ChoreRow(
                        chore: chore,
                        isEditing: $isEditing,
                        onEdit: {
                            editingChore = chore
                            showingEditChore = true
                        },
                        onDelete: {
                            guard let roomId = authViewModel.currentRoom?.id, let choreId = chore.id else { return }
                            Task {
                                await authViewModel.deleteChore(choreID: choreId, roomID: roomId)
                            }
                        }
                    )
                }
            }
            //.navigationBarTitle("Chores", displayMode: .inline)
            .sheet(isPresented: $showingEditChore) {
                if let editingChore = editingChore {
                    EditChore(chore: .constant(editingChore)).environmentObject(authViewModel)
                }
            }
            .sheet(isPresented: $showAddChore) {
                AddChore().environmentObject(authViewModel)
            }
        }
    }

    var editAndAddButtons: some View {
        HStack {
            Button(isEditing ? "Done" : "Edit Chores") {
                isEditing.toggle()
            }
            .padding()
            .background(isEditing ? Color.green : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            Spacer()

            Button(action: {
                showAddChore = true
            }) {
                Image(systemName: "plus")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}


struct ChoreRow: View {
    let chore: Chores
    @Binding var isEditing: Bool
    var onEdit: () -> Void
    var onDelete: () -> Void
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(chore.content)
                Text("Frequency: \(chore.frequency) days").font(.subheadline).foregroundColor(.secondary)
            }
            Spacer()

            if isEditing {
                Button(action: {}) {
                    Text("Edit")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
                .onTapGesture {
                    onEdit()
                }

                Button(action: {}) {
                    Text("Delete")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
                .onTapGesture {
                    onDelete()
                }
            } else {
                Button(chore.status ? "Done" : "Undone") {
                    Task {
                        await authViewModel.toggleChoreStatus(chore)
                    }
                }
                .padding()
                .background(chore.status ? Color.green : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(5)
            }
        }
    }
}

//import SwiftUI
//
//struct Chore: Identifiable {
//    var id = UUID()
//    var content: String
//    var person: String
//    var isDone: Bool
//    var frequency: Int
//    var last_date: Date
//}
//
//struct ChoresView: View {
//    @Binding var selectedPage: String?
//    @State private var showMenuBar = false // State to manage the visibility of the menu
//    @State private var chores: [Chore] = [
//        Chore(content: "倒水", person: "Asuka", isDone: false, frequency: 1, last_date: Date()),
//        Chore(content: "掃地", person: "Emily", isDone: false, frequency: 2, last_date: Date()),
//        Chore(content: "買冷氣卡", person: "Fiona", isDone: false, frequency: 3, last_date:Date())
//    ]
//    
//    @State private var showAddChore = false
//    @State private var showEditChore = false
//    
//    @State private var chore = ""
//    @State private var person = "Unassigned"
//    @State var people :[String] = ["test1","test2","test3"]
//    @State private var frequency = 0
//    
//    //    private var listHeight: CGFloat {
//    //            CGFloat(chores.count * 45) // Assuming each row is 60 points tall
//    //        }
//    
//    @State private var editing = false
//    @State private var currentChoreId = UUID()
//    
//    var body: some View{
//        ZStack(alignment: .leading){
//            Chores
//                .contentShape(Rectangle())
//                .onTapGesture{
//                    if showMenuBar{
//                        showMenuBar = false
//                    }
//                    if showAddChore{
//                        showAddChore = false
//                    }
//                    if showEditChore{
//                        showEditChore = false
//                    }
//                }
//            if showMenuBar {
//                MenuBar(selectedPage: $selectedPage)
//                    .transition(.move(edge: .leading))
//            }
//            if showAddChore{
//                AddChore(chore: $chore, selectedPerson: $person,
//                         selectedFrequency: $frequency, people: people, onAddChore: {addNewChore()
//                    showAddChore = false}, onCancel: {showAddChore = false})
//            }
//            if showEditChore{
//                EditChore(chore: $chore, selectedPerson: $person,selectedFrequency: $frequency, people: people, onSaveEdit: {saveEditCohre()
//                    showEditChore = false}, onCancelEdit: {showEditChore = false})
//            }
//        }
//    }
//    
//    var Chores: some View {
//        //        NavigationView {
//        VStack {
//            HStack {
//                // Toggle button for the menu
//                Button(action: {
//                    // Toggle the visibility of the menu
//                    withAnimation {
//                        showMenuBar.toggle()
//                    }
//                }) {
//                    Image("menu")
//                    .frame(width: 38, height: 38)}
//                Spacer()
//                Text("CHORES")
//                    .font(.custom("Krona One", size: 20))
//                    .foregroundColor(Color(red: 0, green: 0.23, blue: 0.44))
//                Spacer()
//            }
//            .padding()
//            .background(Color.white)
//            .shadow(radius: 2)
//            HStack{
//                Text("Chores Assignment")
//                    .bold()
//                    .padding(.trailing)
//                Spacer()
//                if !editing{
//                    Button{
//                        self.editing = true
//                    }label:{
//                        Text("EDIT")
//                    .padding(5)
//                    .cornerRadius(8)
//            }
//            .overlay(
//                RoundedRectangle(cornerRadius: 8)
//                    .stroke()
//            )
//            .background(
//                RoundedRectangle(cornerRadius: 8)
//                    .fill(Color(red: 1, green: 0.87, blue: 0.44))
//            )
//            .foregroundColor(.black)
//                }
//                else{
//                    Button{
//                        self.editing = false
//                    }label:{
//                        Text("BACK")
//                    .padding(5)
//                    .cornerRadius(8)
//            }
//            .overlay(
//                RoundedRectangle(cornerRadius: 8)
//                    .stroke()
//            )
//            .background(
//                RoundedRectangle(cornerRadius: 8)
//                    .fill(Color(red: 1, green: 0.87, blue: 0.44))
//            )
//            .foregroundColor(.black)
//                }
//            }
//            .padding()
//            VStack{
//                HStack {
//                    HStack{
//                        Text("Chores")
//                            .fontWeight(.semibold)
//                            .frame(width:130)
//                        Spacer()
//                        Text("Next Person")
//                            .fontWeight(.semibold)
//                            .frame(width:100)
//                        Spacer()
//                        Text("Status")
//                            .fontWeight(.semibold)
//                            .frame(width:60)
//                    }
//                    .padding()
//                }.background(Color(red: 1, green: 0.87, blue: 0.44))
//                    .padding(.horizontal)
//                //                        .padding(.bottom,0)
//                //                        .listRowBackground(Color(red: 1, green: 0.87, blue: 0.44))
//                ScrollView{
//                    VStack{
//                        ForEach($chores){
//                            $chore in
//                            if !editing && !chore.isDone{
//                                HStack{
//                                    Text(chore.content)
//                                        .frame(width:130/*, alignment:.leading*/)
//                                    Spacer()
//                                    Text(chore.person).frame(width:100/*, alignment:.leading*/)
//                                    Spacer()
//                                    Button{
//                                        chore.isDone.toggle()
//                                    }label:{
//                                        Text("DONE")
//                                    .padding(5)
//                                    .cornerRadius(8)
//                            }
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 8)
//                                    .stroke()
//                            )
//                            .background(
//                                RoundedRectangle(cornerRadius: 8)
//                                    .fill(Color(red: 1, green: 0.87, blue: 0.44))
//                            )
//                            .foregroundColor(.black)
//                                }
//                            }
//                            else{
//                                Button{
//                                    self.chore = chore.content
//                                    person = chore.person
//                                    showEditChore = true
//                                }label:{
//                                    HStack{
//                                        Text(chore.content)
//                                            .frame(width:130/*, alignment:.leading*/)
//                                        Spacer()
//                                        Text(chore.person).frame(width:100/*, alignment:.leading*/)
//                                        Spacer()
//                                        Button{
//                                            currentChoreId = chore.id
//                                            chore.isDone = true
//                                            deleteChore()
//                                        }label:{
//                                            Text("DONE")
//                                        .padding(5)
//                                        .cornerRadius(8)
//                                }
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 8)
//                                        .stroke()
//                                )
//                                .background(
//                                    RoundedRectangle(cornerRadius: 8)
//                                        .fill(Color(red: 1, green: 0.87, blue: 0.44))
//                                )
//                                .foregroundColor(.black)
//    //                                    .frame(width:60)
//                                    }
//                                }
//                            }
//                        }
//                        .foregroundColor(.black)
//                        .padding()
//                    }
//                    .background(Color(red: 0.96, green: 0.96, blue: 0.93))
//                    //                        .padding(.top,0)
//                    //                        .listRowBackground(Color(red: 0.96, green: 0.96, blue: 0.93))
//                    //                    }
//                    //                    .listStyle(PlainListStyle())
//                    //                    .padding(.horizontal)
//                }
//                //                .frame(height:listHeight)
//                .frame(/*maxHeight:.infinity,*/ alignment:.top)
//                .padding(.horizontal)
//                }
//            Button{
//                showAddChore = true
//                person = "Unassigned"
//            }label:{
//                Rectangle()
//                    .foregroundColor(.clear)
//                    .frame(width: 200, height: 50)
//                    .background(Color(red: 0.96, green: 0.96, blue: 0.86))
//                    .cornerRadius(8)
//                    .overlay(
//                        Text("+ ADD CHORES"
//                            ).foregroundStyle(.black)
//                    )
//            }.padding()
//            Spacer()
//            //            }
//            //            .navigationBarHidden(true)
//            //            .background()
//            //            .background(Color(red: 0.88, green: 0.96, blue: 1.0).edgesIgnoringSafeArea(.all))
//        }
//    }
//
//    
//    func deleteChore(/*at offsets: IndexSet*/) {
//        //        chores.remove(atOffsets: offsets)
//        if let index = chores.firstIndex(where: {$0.id == currentChoreId}){
//            chores.remove(at: index)
//        }
//    }
//    
//    func addNewChore() {
//        // Logic for adding a chore
//        if !chore
//            .trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//            let newChore = Chore(content: chore, person: person, isDone: false, frequency: frequency, last_date:Date())
//            chores.append(newChore)
//            chore = ""
//            person = "Unassigned"
//            
//        }
//    }
//    
//    func saveEditCohre(){
//        if let index = chores.firstIndex(where: {$0.id == currentChoreId}){
//            chores[index].content = chore
//            chores[index].person = person
//        }
//        chore = ""
//        person = "Unassigned"
//    }
//}
//
////struct AddChore: View{
////    @State private var chore = ""
////    @State private var person = "Unassigned"
////    @State var people :[String] = ["test1","test2","test3"]
////    @State private var frequency = 1
////    @State private var chores:[Chore] = []
////    
////    func addNewChore() {
////        // Logic for adding a chore
////        if !chore
////            .trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
////            let newChore = Chore(task: chore, person: person, isDone: false)
////            chores.append(newChore)
////            chore = ""
////        }
////    }
////    
////    var body: some View{
////        VStack {
////            VStack{
////                HStack{
////                    Text("Add a new chore:")
////                        .foregroundColor(.black)
////                    Spacer()
////                    Button{
////                        
////                    }label:{
////                        Image("close-circle_outline")
////                        .frame(width: 18, height: 18)}
////                }
////                HStack{
////                    Text("Chore")
////                    Spacer()
////                }
////                RoundedRectangle(cornerRadius: 25.0)
////                    .stroke(.black.opacity(0.33), lineWidth: 1)
////                    .frame(width: 253, height: 30)
////                    .background(Color(red: 0.96, green: 0.96, blue: 0.86).opacity(0.33))
////                    .overlay(
////                        TextField("Type in here", text: $chore)
////                            .padding(10)
////                    )
////                HStack{
////                    SelectPerson(selectedPerson: $person, people: people)}
////                HStack{
////                    ChooseFrequency(selectedFrequency: $frequency)
////                }
////            }
////            .frame(width:260)
////        }
////        .frame(width: 320, height: 238)
////        .background(.white)
////        .cornerRadius(15)
////    }
////}
//
//struct ChoresView_Previews:
//    PreviewProvider {
//    struct PreviewWrapper: View {
//        @State var selectedPage: String? = "Chores"
//        var body: some View{
//            ChoresView(selectedPage: $selectedPage)
//        }
//    }
//        static var previews: some View {
//            PreviewWrapper()
//        }
//}
//
////#Preview{
////    AddChore()
////}
