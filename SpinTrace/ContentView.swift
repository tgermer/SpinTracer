//
//  ContentView.swift
//  SpinTrace
//
//  Created by Tristan Germer on 09.12.24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView {
            BicycleListView()
                .tabItem {
                    Label("tab-bicycles", systemImage: "bicycle")
                }

            RideListView()
                .tabItem {
                    Label("tab-rides", image: "SpinTraceTabViewIcon")
                }

            StatisticsView()
                .tabItem {
                    Label("tab-stats", systemImage: "chart.bar")
                }

            SettingsView()
                .tabItem {
                    Label("tab-settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [
            Bicycle.self, Ride.self, Service.self,
            RideCategory.self, RideCategory.self,
        ])
}
