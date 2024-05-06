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
    @State private var selectedPerson = "Unassigned"  // 存儲當前選擇的人員名稱
    let people:[String] = ["Non Specific","test1","test2","test3"]
    
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    
//    @State private var showDatePicker = false
//    @State private var showTimePicker = false
    
    @State private var editing = false
    
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
                }
            if showMenuBar {
                MenuBar(selectedPage: $selectedPage)
                    .transition(.move(edge: .leading))
            }
            if showAddTask{
                AddTask
            }
        }
    }
    
    func addNewTask(){
        if !task
            .trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let newTask = Task(date:selectedDate, time:selectedTime, content:task, person:selectedPerson)
            tasks.append(newTask)
            task = ""
        }
    }
    
    var AddTask: some View {
        VStack {
            Spacer()  // Pushes everything to center
            VStack {
                HStack{
                    Text("Add a new Task:")
                    Spacer()
                    Button{
                        self.showAddTask.toggle()
                    }label:{
                        Image("close-circle_outline")
                    }
                    .frame(width: 18, height: 18)
                }
                .frame(width: 260)
                ZStack{
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.black.opacity(0.33), lineWidth: 1)
                        .frame(width: 253, height: 140)
                        .background(Color(red: 0.96, green: 0.96, blue: 0.86).opacity(0.33))
                        .overlay(
                            TextField("Type in here", text: $task)
                                .padding(10)
                                .frame(alignment:.top)
                        )
                }
                HStack{
                    ChooseDate(selectedDate: $selectedDate)}
                HStack{
                    ChooseTime(selectedTime: $selectedTime)
                }
                HStack{
                    SelectPerson(selectedPerson: $selectedPerson, people: people)
                }
                Button{
                    addNewTask()
                    self.showAddTask = false
                }label:{
                    Text("SAVE")
                        .padding(5)
                        .foregroundColor(.black)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.black, lineWidth: 1)
                                .background(Color(red: 0.95, green: 0.75, blue: 0.09))
                        )
                }
                .padding(10)
            }
            .padding(10)
            .frame(width: 300)
            Spacer()  // Pushes everything to center
        }
        .background(.white)
        .border(.black)
        .frame(maxWidth: .infinity, maxHeight: 400) 
        // Ensure VStack takes full screen
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
                        .font(Font.custom("Jacques Francois", size: 20))
                        .foregroundColor(.black)
//                        .padding()
                    Spacer()
                    Button{}label:{
                        RoundedRectangle(cornerRadius: 8)
                            .inset(by: -1)
                            .stroke(Color(red: 1, green: 0.84, blue: 0.25), lineWidth: 2)
                            .background(Color(red: 1, green: 0.87, blue: 0.44))
                            .frame(width: 36, height: 20)
                            .overlay(
                        Text("EDIT")
                            .font(Font.custom("Jacques Francois", size: 10))
                            .foregroundColor(.black))
                    }
                }
                ForEach($tasks){
                    $task in
//                    if formattedDate(task.date) == formattedDate(today)
                    if task.person != "Unassigned"
                    {
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
                                }
                            }
                            .frame(width:70,alignment:.trailing)
                        }
                        .padding(10)
                        .background(
                            Rectangle()
                              .foregroundColor(.clear)
                              .frame(width: 300 )
                              .background(Color(red: 0.96, green: 0.96, blue: 0.93))
                              .cornerRadius(15)
                        )
                    }
                }
            }
            .frame(maxWidth: 300)
            .padding()
            VStack{
                HStack{
                    Text("Unassigned Tasks")
                        .font(Font.custom("Jacques Francois", size: 20))
                    Spacer()
                    Button{
                            showAddTask.toggle()
                    }label:{
                        RoundedRectangle(cornerRadius: 8)
                            .inset(by: -1)
                            .stroke(Color(red: 1, green: 0.84, blue: 0.25), lineWidth: 2)
                            .background(Color(red: 1, green: 0.87, blue: 0.44))
                            .frame(width: 36, height: 20)
                            .overlay(
                        Text("ADD")
                            .font(Font.custom("Jacques Francois", size: 10))
                            .foregroundColor(.black))
                    }
                    Button{
                        editing.toggle()
                    }label:{
                        RoundedRectangle(cornerRadius: 8)
                            .inset(by: -1)
                            .stroke(Color(red: 1, green: 0.84, blue: 0.25), lineWidth: 2)
                            .background(Color(red: 1, green: 0.87, blue: 0.44))
                            .frame(width: 36, height: 20)
                            .overlay(
                        Text("EDIT")
                            .font(Font.custom("Jacques Francois", size: 10))
                            .foregroundColor(.black))
                    }
                }
                ForEach($tasks){
                    $task in
                        if task.person == "Unassigned"{
                            HStack{
                                Text(formattedDate(task.date))
                                    .frame(width:50,alignment:.leading)
                                Spacer()
                                Text(formattedTime(task.time))
                                    .frame(width:70,alignment:.leading)
                                Spacer()
                                Text(task.content)
                                    .frame(width:80,alignment:.leading)
//                                Spacer()
//                                HStack{
//                                    Image("person")
//                                    Text(task.person)
//                                }
//                                SelectPerson(selectedPerson: $selectedPerson, people: people)
//                                
                            }
                            .padding(10)
                            .background(
                                Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width: 300)
                                        .background(Color(red: 0.96, green: 0.96, blue: 0.93))
                                        .cornerRadius(15))
                        }
                }
            }
            .frame(maxWidth: 300)
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

//#Preview{
//    AddTask()
//}
//
