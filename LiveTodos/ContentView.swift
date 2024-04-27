//
//  ContentView.swift
//  LiveTodos
//
//  Created by Aaron Ma on 4/26/24.
//

import SwiftUI

enum Tab {
    case Today
    case Schedule
    case Automations
}

struct ContentView: View {
    @StateObject private var todosStore = TodosStore()
    @State private var selectedTab: Tab = .Today
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Today()
                .environmentObject(todosStore)
                .tabItem {
                    Label("Today", systemImage: "calendar")
                }
                .tag(Tab.Today)
            
            Text("Schedule")
                .tabItem {
                    Label("Schedule", systemImage: "gear")
                }
                .tag(Tab.Schedule)
            
            Text("Automations")
                .tabItem {
                    Label("Automations", systemImage: "gear")
                }
                .tag(Tab.Automations)
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
    ContentView()
}
