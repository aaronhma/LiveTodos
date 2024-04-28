//
//  Schedule.swift
//  LiveTodos
//
//  Created by Aaron Ma on 4/26/24.
//

import SwiftUI

struct Schedule: View {
    @StateObject private var todosStore = TodosStore()
    @State private var selectedDay = "Sun"
    
    private var allDays = ["Sun", "Mon", "Tue", "Wed", "Thurs", "Fri", "Sat"]
    
    var body: some View {
        NavigationStack {
            Picker("", selection: $selectedDay) {
                ForEach(allDays, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            let todos = todosStore.todos.filter { $0.template == selectedDay }
            
            if todos.isEmpty {
                VStack {
                    Image(systemName: "calendar")
                        .font(.largeTitle)
                        .padding(.top, 50)
                    
                    Text("No Todos Yet")
                        .font(.largeTitle)
                        .bold()
                
                    Text("Build your day with step-by-step todos.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                    
                    Button {
                        print("todo")
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
                    Section(todos.count == 1 ? "1 Todo" : "\(todos.count) Todos") {
                        ForEach(todos) { todo in
                        }
                    }
                }
            }
            
            VStack {}
            .navigationTitle("Schedule")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    Schedule()
}
