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
    case Templates
    case Settings
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
            
            Schedule()
                .environmentObject(todosStore)
                .tabItem {
                    Label("Schedule", systemImage: "clock")
                }
                .tag(Tab.Schedule)
            
            Templates()
                .tabItem {
                    Label("Templates", systemImage: "wrench.adjustable")
                }
                .tag(Tab.Templates)
            
            Settings()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(Tab.Settings)
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
