//
//  RideDetailView.swift
//  SpinTrace
//
//  Created by Tristan Germer on 11.12.24.
//

import SwiftData
import SwiftUI

struct RideDetailView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var ride: Ride
    @Query var bicycles: [Bicycle]  // Ruft alle verfügbaren Fahrräder ab

    @Query(sort: \RideCategory.orderIndex, order: .forward) private var categories: [RideCategory]
    var body: some View {
        List {
            Section("Details") {
                HStack {
                    Text("Date")
                    Spacer()
                    Text(ride.timestamp, style: .date)
                }
                HStack {
                    Text("Distance")
                    Spacer()
                    Text("\(ride.distance, specifier: "%.2f") km")
                }
                HStack {
                    Text("Average Speed")
                    Spacer()
                    Text("\(ride.averageSpeed, specifier: "%.2f") km/h")
                }
                HStack {
                    Text("Calories Burned")
                    Spacer()
                    Text("\(ride.caloriesBurned, specifier: "%.0f") kcal")
                }
                HStack {
                    Text("Duration")
                    Spacer()
                    Text("\(ride.duration)")
                }
            }
            Section("Bicycle") {
                Picker("Bicycle", selection: $ride.bicycle) {
                    ForEach(bicycles) { bicycle in
                        Text(bicycle.name).tag(bicycle as Bicycle)
                    }
                }
                .pickerStyle(.menu)
            }
            Section("Categorie") {
                Picker("Select Category", selection: $ride.category) {
//                    Text("No Category").tag(nil as RideCategory?)
                    ForEach(categories) { category in
                        Text(category.name).tag(category as RideCategory?)
                    }
                }
                .pickerStyle(.menu)
            }
        }
        .navigationTitle("Ride Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
