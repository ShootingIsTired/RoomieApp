//
//
//  ContentView.swift
//  sad_project
//
//  Created by Fiona on 2024/4/19.
//

import SwiftUI

struct Task: Identifiable {
    var id = UUID()
    var date: Date
    var time: Date
    var content: String
    var person: String
}

struct HomeView: View {
    @Binding var selectedPage: String?
    @State private var showMenuBar = false
    
    @State private var showAddTask = false
    @State private var tasks:[Task] = [
        Task(date:Date(),time:Date(), content:"abcd",person:"test1"), 
        Task(date:Date(),time:Date(), content:"abcd",person:"Unassigned"),Task(date:Date(),time:Date(), content:"abcd",person:"Non Specific")
    ]
    
    @State private var today = Date()
    
    @State private var task = ""
    @State private var selectedPerson = ""  // 存儲當前選擇的人員名稱
    let people:[String] = ["Non Specific","test1","test2","test3"]
    
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    @State private var currentTaskId = UUID()

    @State private var editReminder = false
    @State private var editUnassigned = false
    @State private var showEditTask = false
    
    var body: some View {
        ZStack(alignment: .leading){
            Home
                .contentShape(Rectangle())
                .onTapGesture{
                    if showMenuBar{
                        showMenuBar = false
                    }
                    if showAddTask{
                        showAddTask = false
                    }
                    if showEditTask{
                        showEditTask = false
                    }
                }
            if showMenuBar {
                MenuBar(selectedPage: $selectedPage)
                    .transition(.move(edge: .leading))
            }
            if showAddTask {
                AddTask(task: $task, /*selectedDate: $selectedDate,*/ selectedTime: $selectedTime, selectedPerson: $selectedPerson, people: people, onAddTask: {
                    addNewTask()
                    showAddTask = false
                }, onCancel: {
                    showAddTask = false
                })
            }
            if showEditTask{
                EditTask(task: $task, /*selectedDate: $selectedDate,*/ selectedTime: $selectedTime, selectedPerson: $selectedPerson, people: people, onSaveEdit: {saveEditTask()
                    showEditTask = false},
                 onCancelEdit: {showEditTask = false})
            }
        }
    }
    
    func addNewTask(){
        if !task
            .trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let newTask = Task(date:selectedDate, time:selectedTime, content:task, person:selectedPerson)
            tasks.append(newTask)
            task = ""
            selectedPerson = "Unassigned"
            selectedDate = Date()
            selectedTime = Date()
        }
    }
    
    func saveEditTask() {
        if let index = tasks.firstIndex(where: { $0.id == currentTaskId }) {
            tasks[index].content = task
            tasks[index].date = selectedDate
            tasks[index].time = selectedTime
            tasks[index].person = selectedPerson
        }
        task = ""
        selectedPerson = "Unassigned"
        selectedDate = Date()
        selectedTime = Date()
    }

    
    var Home: some View{
        VStack(spacing: 0) {
            HStack {
                // Toggle button for the menu
                Button(action: {
                        // Toggle the visibility of the menu
                        withAnimation {
                            showMenuBar.toggle()
                        }
                    }) {
                    Image("menu")
                    .frame(width: 38, height: 38)}
                Spacer()
                Text("HOME")
                    .font(.custom("Krona One", size: 20))
                    .foregroundColor(Color(red: 0, green: 0.23, blue: 0.44))
                Spacer()
            }
            .padding()
            .background(Color.white)
            .shadow(radius: 2)
            
            VStack{
                HStack{
                    Text("Reminders")
//                        .font(Font.custom("Jacques Francois", size: 20))
                        .foregroundColor(.black)
//                        .padding()
                    Spacer()
                    if !editReminder{
                        Button{
                            self.editReminder = true
                        }label:{
                            Text("EDIT")
                        .padding(5)
                        .cornerRadius(8)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke()
                )
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(red: 1, green: 0.87, blue: 0.44))
                )
                .foregroundColor(.black)
                    }
                    else{
                        Button{
                            self.editReminder = false
                        }label:{
                            Text("BACK")
                        .padding(5)
                        .cornerRadius(8)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke()
                )
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(red: 1, green: 0.87, blue: 0.44))
                )
                .foregroundColor(.black)
                    }
                }
                .padding(.horizontal,30)
                .padding(.vertical,15)
                ScrollView{
                    VStack{
                        ForEach($tasks){
                            $task in
                            if formattedDate(task.time) == formattedDate(today) &&
                             task.person != "Unassigned"
                            {
                                if !editReminder{
                                    HStack{
                                        Text(formattedDate(task.date))
                                            .frame(width:50,alignment:.leading)
                                        Spacer()
                                        Text(formattedTime(task.time))
                                            .frame(width:70,alignment:.leading)
                                        Spacer()
                                        Text(task.content)
                                            .frame(width:80,alignment:.leading)
                                        Spacer()
                                        HStack{
                                            if task.person != "Non Specific"{
                                                Image("person")
                                                Text(task.person)
                                            }
                                            else{
                                                Image("person-x")
                                                Text(task.person)
                                            }
                                        }
                                        .frame(width:140,alignment:/*.trailing*/.leading)
                                    }
                                    .padding(10)
                                    .background(
                                        Rectangle()
                                          .foregroundColor(.clear)
                                          .frame(width: 370 )
                                          .background(Color(red: 0.96, green: 0.96, blue: 0.93))
                                          .cornerRadius(15)
                                    )
                                }
                                else{
                                    Button{
                                        currentTaskId = task.id // Set the current task ID
                                            self.task = task.content
                                            self.selectedDate = task.date
                                            self.selectedTime = task.time
                                            self.selectedPerson = task.person
                                            self.showEditTask = true
                                    }label:{
                                        Text(formattedDate(task.date))
                                            .frame(width:50,alignment:.leading)
                                        Spacer()
                                        Text(formattedTime(task.time))
                                            .frame(width:70,alignment:.leading)
                                        Spacer()
                                        Text(task.content)
                                            .frame(width:80,alignment:.leading)
                                        Spacer()
                                        HStack{
                                            if task.person != "Non Specific"{
                                                Image("person")
                                                Text(task.person)
                                            }
                                            else{
                                                Image("person-x")
                                                Text(task.person)
                                            }
                                        }
                                        .frame(width:140,alignment:/*.trailing*/.leading)
                                    }
                                    .foregroundColor(.black)
                                    .padding(10)
                                    .background(
                                        Rectangle()
                                          .foregroundColor(.clear)
                                          .frame(width: 370 )
                                          .background(Color(red: 0.96, green: 0.96, blue: 0.93))
                                          .cornerRadius(15)
                                    )
                                }
                            }
                        }
                    }.background(Color(red: 0.96, green: 0.96, blue: 0.93))
                        .padding(.horizontal)
                }
                }
//            .frame(maxWidth: 370)
//            .padding(.horizontal)
            VStack{
                HStack{
                    Text("Unassigned Tasks")
//                        .font(Font.custom("Jacques Francois", size: 20))
                    Spacer()
                    
                    if !editUnassigned{
                        Button{
                                showAddTask.toggle()
                            selectedPerson = "Unassigned"
                        }label:{
                            Text("ADD")
                        .padding(5)
                        .cornerRadius(8)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke()
                )
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(red: 1, green: 0.87, blue: 0.44))
                )
                .foregroundColor(.black)
                        Button{
                            editUnassigned = true
                        }label:{
                            Text("EDIT")
                        .padding(5)
                        .cornerRadius(8)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke()
                )
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(red: 1, green: 0.87, blue: 0.44))
                )
                .foregroundColor(.black)
                    }
                    else{
                        Button{
                            editUnassigned = false
                            task = ""
                            selectedDate = Date()
                            selectedTime = Date()
                            selectedPerson = "Unassigned"
                        }label:{
                            Text("BACK")
                        .padding(5)
                        .cornerRadius(8)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke()
                )
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(red: 1, green: 0.87, blue: 0.44))
                )
                .foregroundColor(.black)
                    }
                }
                .padding(15)
//                .padding(.horizontal,15)
//                .padding(.vertical,15)
                ScrollView{
                    VStack{
                        ForEach($tasks){
                            $task in
                            if task.person == "Unassigned"{
                                if !editUnassigned{
                                    HStack
                                    {
                                        Text(formattedDate(task.date))
                                            .frame(width:50,alignment:.leading)
                                        Spacer()
                                        Text(formattedTime(task.time))
                                            .frame(width:70,alignment:.leading)
                                        Spacer()
                                        Text(task.content)
                                            .frame(width:80,alignment:.leading)
                                        VStack{
                                            SelectPerson(selectedPerson: $task.person, people: people)
                                        }
                                        .frame(width:140)
                                    }
                                    .foregroundColor(.black)
                                    .padding(10)
                                    .background(
                                        Rectangle()
                                            .foregroundColor(.clear)
                                            .frame(width: 370)
                                            .background(Color(red: 0.96, green: 0.96, blue: 0.93))
                                            .cornerRadius(15))
                                }
                                else{
                                    Button{
                                        currentTaskId = task.id // Set the current task ID
                                            self.task = task.content
                                            self.selectedDate = task.date
                                            self.selectedTime = task.time
                                            self.selectedPerson = task.person
                                            self.showEditTask = true
                                    }label:
                                    {
                                        Text(formattedDate(task.date))
                                            .frame(width:50,alignment:.leading)
                                        Spacer()
                                        Text(formattedTime(task.time))
                                            .frame(width:70,alignment:.leading)
                                        Spacer()
                                        Text(task.content)
                                            .frame(width:80,alignment:.leading)
                                        HStack{
        //                                    SelectPerson(selectedPerson: $task.person, people: people)
                                            Image("person")
                                            Text(task.person)
                                        }
                                        .frame(width:140)
                                    }
                                    .foregroundColor(.black)
                                    .padding(10)
                                    .background(
                                        Rectangle()
                                            .foregroundColor(.clear)
                                            .frame(width: 370)
                                            .background(Color(red: 0.96, green: 0.96, blue: 0.93))
                                            .cornerRadius(15))
                                }
                            }
                        }
                    }.background(Color(red: 0.96, green: 0.96, blue: 0.93))
                }
                .padding(.horizontal)
                }
        }
        .frame(maxHeight:.infinity, alignment:.top)
    }
}

private func formattedTime(_ time: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .none // Use short date style for compact display
    formatter.timeStyle = .short
        return formatter.string(from: time)
    }

private func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .short // Use short date style for compact display
    formatter.timeStyle = .none
    formatter.dateFormat = "MM/dd"
    return formatter.string(from: date)
}



struct HomeView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State var selectedPage: String? = "Home"
        var body: some View {
            HomeView(selectedPage: $selectedPage)
        }
    }

    static var previews: some View {
        PreviewWrapper()
    }
}
