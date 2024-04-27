//
//  Today.swift
//  LiveTodos
//
//  Created by Aaron Ma on 4/26/24.
//

import SwiftUI

struct Today: View {
    @StateObject private var todosStore = TodosStore()
    
    @State private var showingNewTodoSheet = false
    @State private var showingTodoDeleteConfirmation = false
    
    @State private var newTodoText = ""
    @State private var currentTodo = Todo(todo: "")
    
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
                    }
                    
                    Section {
                        Button {
                            showingNewTodoSheet = true
                        } label: {
                            Label("Add New Todo", systemImage: "plus.circle")
                        }
                    }
                }
            }
            
            VStack {}
                .navigationTitle("Today")
                .sheet(isPresented: $showingNewTodoSheet) {
                    NavigationStack {
                        Form {
                            TextField("New Todo", text: $newTodoText)
                        }
                        .navigationTitle("New Todo")
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button("Cancel") {
                                    showingNewTodoSheet = false
                                }
                            }
                            
                            ToolbarItem(placement: .topBarTrailing) {
                                Button("Done") {
                                    let newTodo = Todo(todo: newTodoText)
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
                        EditButton()
                    }
                }
        }
        .onAppear {
            Task {
                do {
                    try await todosStore.load()
                } catch {
                    fatalError("Couldn't load stored todos.")
                }
            }
        }
    }
}

#Preview {
    Today()
}
