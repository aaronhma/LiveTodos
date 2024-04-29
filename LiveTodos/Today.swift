//
//  Today.swift
//  LiveTodos
//
//  Created by Aaron Ma on 4/26/24.
//

import SwiftUI
import ActivityKit

struct Today: View {
    @StateObject private var todosStore = TodosStore()
    
    @AppStorage("liveActivitiesTodoID") private var liveActivitiesTodoID = AppSettings.liveActivitiesTodoID
    
    @State private var showingNewTodoSheet = false
    @State private var showingTodoDeleteConfirmation = false
    
    @State private var currentTodo = Todo(emoji: "", todo: "", description: "", template: "Today")
    
    // New Todo Form:
    @State private var newTodoEmoji = ""
    @State private var newTodoText = ""
    @State private var newTodoDescription = ""
    
    @State var startHour: Int = 0
    @State var startMinute: Int = 0
    
    @State var endHour: Int = 0
    @State var endMinute: Int = 0
    
    func save() async throws {
        try await todosStore.save(todos: todosStore.todos)
    }
    
    var body: some View {
        NavigationStack {
            if todosStore.todos.isEmpty {
                VStack {
                    Image(systemName: "calendar")
                        .font(.largeTitle)
                    
                    Text("No Todos Yet")
                        .font(.largeTitle)
                        .bold()
                
                    Text("Build your day with step-by-step todos.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                    
                    Button {
                        showingNewTodoSheet = true
                    } label: {
                        Label("Add New Todo", systemImage: "plus.circle.fill")
                            .bold()
                            .foregroundStyle(.white)
                            .padding()
                            .background(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                }
            } else {
                List {
                    Section {
                        ForEach(todosStore.todos.sorted { $0.startTime < $1.startTime }) { todo in
                            HStack {
                                Text(todo.emoji)
                                    .font(.largeTitle)
                                
                                VStack(alignment: .leading) {
                                    Text(todo.todo)
                                        .bold()
                                    
                                    HStack {
                                        Text(todo.startTime, format: .dateTime.hour().minute())
                                        Text("-")
                                        Text(todo.endTime, format: .dateTime.hour().minute())
                                    }
                                    .foregroundStyle(.secondary)
                                }
                            }
                            .onTapGesture {
                                print("TODO: open edit sheet")
                            }
                            .contextMenu {
                                Button {
                                    print("TODO: open edit sheet")
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                
                                Button(role: .destructive) {
                                    currentTodo = todo
                                    showingTodoDeleteConfirmation = true
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .swipeActions(edge: .trailing) {
                                Button {
                                    currentTodo = todo
                                    showingTodoDeleteConfirmation = true
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .tint(.red)
                                
                                Button {
                                    print("TODO: open edit sheet")
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(.indigo)
                            }
                        }
                        .onDelete { indexSet in
                        }
                        .confirmationDialog("Delete Todo?", isPresented: $showingTodoDeleteConfirmation, titleVisibility: .visible) {
                            Button("Delete Todo", role: .destructive) {
                                if let idx = todosStore.indexOfTodo(withID: currentTodo.id) {
                                    withAnimation {
                                        todosStore.todos.remove(at: idx)
                                        
                                        Task {
                                            do {
                                                try await save()
                                            } catch {
                                                print(error)
                                            }
                                        }
                                        
                                        showingTodoDeleteConfirmation = false
                                    }
                                }
                            }
                        }
                    } header: {
                        Text(Date.now, format: .dateTime.day().month().year())
                    }
                }
            }
            
            VStack {}
                .navigationTitle("Today")
                .sheet(isPresented: $showingNewTodoSheet) {
                    NavigationStack {
                        Form {
                            Section {
                                TextField("Emoji", text: $newTodoEmoji)
                            }
                            
                            Section {
                                TextField("New Todo", text: $newTodoText)
                            }
                            
                            Section {
                                TextField("What are you planning to do?", text: $newTodoDescription)
                            }
                            
                            VStack {
                                Text("Start Time")
                                    .bold()
                                
                                HStack {
                                    Picker("", selection: $startHour){
                                        ForEach(0..<23, id: \.self) { i in
                                            Text("\(i) hours")
                                                .tag(i)
                                        }
                                    }
                                    .pickerStyle(WheelPickerStyle())
                                    
                                    Picker("", selection: $startMinute){
                                        ForEach(0..<60, id: \.self) { i in
                                            Text("\(i) min")
                                                .tag(i)
                                        }
                                    }
                                    .pickerStyle(WheelPickerStyle())
                                }
                            }
                            .padding(.horizontal)
                            
                            VStack {
                                Text("End Time")
                                    .bold()
                                
                                HStack {
                                    Picker("", selection: $endHour){
                                        ForEach(0..<23, id: \.self) { i in
                                            Text("\(i) hours")
                                                .tag(i)
                                        }
                                    }
                                    .pickerStyle(WheelPickerStyle())
                                    
                                    Picker("", selection: $endMinute){
                                        ForEach(0..<60, id: \.self) { i in
                                            Text("\(i) min")
                                                .tag(i)
                                        }
                                    }
                                    .pickerStyle(WheelPickerStyle())
                                }
                            }
                            .padding(.horizontal)
                        }
                        .navigationTitle("New Todo")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button("Cancel") {
                                    showingNewTodoSheet = false
                                }
                            }
                            
                            ToolbarItem(placement: .topBarTrailing) {
                                Button("Done") {
                                    let newTodo = Todo(emoji: newTodoEmoji, todo: newTodoText, description: newTodoDescription, template: "Today")
                                    todosStore.todos.append(newTodo)
                                    
                                    Task {
                                        do {
                                            try await save()
                                        } catch {
                                            fatalError(error.localizedDescription)
                                        }
                                    }
                                    
                                    showingNewTodoSheet = false
                                }
                            }
                        }
                    }
                }
                .toolbar {
                    if !todosStore.todos.isEmpty {
                        ToolbarItem(placement: .topBarLeading) {
                            EditButton()
                        }
                        
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                showingNewTodoSheet = true
                            } label: {
                                Label("Add New Todo", systemImage: "plus")
                            }
                        }
                    }
                }
        }
        .onAppear {
            Task {
                do {
                    try await todosStore.load()
                    
                    if !todosStore.todos.isEmpty {
                        //                    try LiveActivityManager.startActivity(emoji: "😉", todo: "test", startTime: Date.now, endTime: Date.now.addingTimeInterval(24 * 60 * 60))
//                        await LiveActivityManager.endAllActivities()
                        
                        if liveActivitiesTodoID == "" {
                            liveActivitiesTodoID = try LiveActivityManager.startActivity(emoji: "😉", todo: "test", startTime: Date.now, endTime: Date.now.addingTimeInterval(60 * 60))
                        }
                    }
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    Today()
}
