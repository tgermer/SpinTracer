//
//  AddRideView.swift
//  SpinTrace
//
//  Created by Tristan Germer on 11.12.24.
//

import SwiftUI
import SwiftData

struct AddRideView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Bindable var bicycle: Bicycle
    
    @Query(sort: \RideCategory.orderIndex, order: .forward) private var categories: [RideCategory]
    
    @State private var timestamp = Date()
    @State private var distance: Double = 0
    @State private var averageSpeed: Double = 0
    @State private var caloriesBurned: Double = 0
    @State private var duration: TimeInterval = 0
    @State private var selectedCategory: RideCategory?  // Speichert die ausgewählte Kategorie
    
    var body: some View {
        NavigationView {
            Form {
                Section("Ride Details") {
                   
                    HStack {
                        Label("Date", systemImage: "calendar")
                        DatePicker("", selection: $timestamp, displayedComponents: .date)
                    }
                    
                    HStack {
                        Label("Distance (km)", systemImage: "signpost.right.fill")
                        Spacer()
                        TextField("Distance (km)", value: $distance, format: .number)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                            .frame(width: 100)
                    }
                    HStack {
                        Label("Average Speed (km/h)", systemImage: "gauge.with.dots.needle.33percent")
                        Spacer()
                        TextField("Average Speed (km/h)", value: $averageSpeed, format: .number)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                            .frame(width: 100)
                    }
                    HStack {
                        Label("Calories Burned", systemImage: "flame.fill")
                        Spacer()
                        TextField("Calories Burned", value: $caloriesBurned, format: .number)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                            .frame(width: 100)
                    }
                    HStack {
                        Label("Duration (min)", systemImage: "timer")
                        Spacer()
                        TextField("Duration (min)", value: $duration, format: .number)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                            .frame(width: 100)
                    }
                }
                Section("Category") {
                                    Picker("Select Category", selection: $selectedCategory) {
//                                        Text("No category").tag(nil as RideCategory?)
                                        ForEach(categories) { category in
                                            Text(category.name).tag(category as RideCategory?)
                                        }
                                    }
                                    .pickerStyle(.navigationLink)
                                }
            }
            .navigationTitle("Add Ride")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        addRide()
                        dismiss()
                    }
//                    .disabled(distance <= 0 || duration <= 0)
                }
            }
        }
    }
    
    private func addRide() {
        let newRide = Ride(
            timestamp: timestamp,
            distance: distance,
            averageSpeed: averageSpeed,
            caloriesBurned: caloriesBurned,
            duration: duration,
            category: selectedCategory,
            bicycle: bicycle
        )
        
        withAnimation {
            modelContext.insert(newRide)
            bicycle.rides.append(newRide)
            try? modelContext.save()
        }
    }
}


#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Bicycle.self, configurations: config)
    let bicycle = Bicycle(name: "Test Bike")
    container.mainContext.insert(bicycle)
    return AddRideView(bicycle: bicycle)
        .modelContainer(container)
} 
