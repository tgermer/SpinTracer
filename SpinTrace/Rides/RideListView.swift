//
//  RideListView.swift
//  SpinTrace
//
//  Created by Tristan Germer on 10.12.24.
//

import SwiftUI
import SwiftData

struct RideListView: View {
    @Environment(\.modelContext) var modelContext

    @Query(sort: \Ride.timestamp) var rides: [Ride]
    @Query private var bicycles: [Bicycle]
    
    @State private var selectedBicycle: Bicycle? = nil
    @State private var isAddingRide = false

    var body: some View {
        NavigationStack {
            content
                .sheet(isPresented: $isAddingRide) {
                    if let bicycle = selectedBicycle, bicycles.contains(bicycle) {
                        AddRideView(bicycle: bicycle, isEditable: false)
                    } else if let firstBicycle = bicycles.first {
                        AddRideView(bicycle: firstBicycle, isEditable: true)
                    } else {
                        Text("No bicycles available. Please add a bicycle first.")
                    }
                }
                .toolbar {
                    Button(action: {
                        isAddingRide.toggle()
                    }) {
                        Label("Add", systemImage: "plus")
                    }
                }
                .navigationTitle("tab-rides")
        }
    }
    
    func deleteRide(at offsets: IndexSet) {
        for index in offsets {
            let ride = rides[index]
            modelContext.delete(ride)
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if rides.isEmpty {
            emptyView
        } else {
            listView
        }
    }

    var emptyView: some View {
        ContentUnavailableView(
            label: {
                VStack {
                    Image("SpinTraceAppIcon")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.secondary)
                    Label("No Rides", image: "")
                }
            },
            description: {
                Text("Rides you add will appear here.")
            },
            actions: {
                Button("Add Ride") {
                    if let firstBicycle = bicycles.first {
                        selectedBicycle = firstBicycle
                        isAddingRide = true
                    }
                }
                .buttonBorderShape(.roundedRectangle)
                .buttonStyle(.borderedProminent)
            }
        )
    }

    var listView: some View {
        List {
            ForEach(rides) { ride in
                NavigationLink(destination: RideDetailView(ride: ride)) {
                    VStack(alignment: .leading) {
                        Text(ride.timestamp, style: .date)
                            .font(.headline)
                        HStack {
                            Text("Distance: \(ride.distance, specifier: "%.1f") km")
                            Spacer()
                            Text("\(ride.bicycle.name), \(ride.category?.name ?? "No category")")
                        }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }
                }
            }
            .onDelete(perform: deleteRide)
        }
    }
}

#Preview {
    RideListView()
}
