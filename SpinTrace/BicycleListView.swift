//
//  BicycleListView.swift
//  SpinTrace
//
//  Created by Tristan Germer on 09.12.24.
//

import SwiftUI
import SwiftData

struct BicycleListView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Bicycle.name) private var bicycles: [Bicycle]
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(bicycles, id: \.id) { bicycle in
                    NavigationLink(destination: BicycleDetailView(bicycle: bicycle)) {
                        Text(bicycle.name)
                    }
                }
            }
            .navigationTitle("tab-bicycles")
        }
    }
}

#Preview {
    BicycleListView()
        .modelContainer(for: [Bicycle.self, Ride.self, Service.self, RideCategory.self, ServiceCategory.self], inMemory: true)
}
