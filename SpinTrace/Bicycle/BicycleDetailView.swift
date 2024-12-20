//
//  BicycleDetailView.swift
//  SpinTrace
//
//  Created by Tristan Germer on 09.12.24.
//

import SwiftUI

struct BicycleDetailView: View {

    @Environment(\.modelContext) var modelContext

    @Bindable var bicycle: Bicycle

    @State private var isAddingRide = false

    var body: some View {

        List {
            HStack {
                Label("bicycle-name", systemImage: "bicycle")
                Spacer()
                TextField("Name", text: $bicycle.name)
                    .multilineTextAlignment(.trailing)
            }

            Section("purchase-details") {
                HStack {
                    Label("purchase-date", systemImage: "calendar")
                    Spacer()
                    DatePicker(
                        "", selection: $bicycle.purchaseDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.compact)
                }
                HStack {
                    Label("purchase-price", systemImage: "eurosign.circle")
                    Spacer()
                    TextField(
                        "purchase-price",
                        text: Binding(
                            get: {
                                bicycle.purchasePrice.map { String(describing: $0) }
                                    ?? ""
                            },  // Konvertiere `Decimal?` zu `String`
                            set: { bicycle.purchasePrice = Decimal(string: $0) }  // Konvertiere `String` zurück zu `Decimal?`
                        )
                    )
                    .keyboardType(.decimalPad)  // Für Dezimalzahlen
                    .multilineTextAlignment(.trailing)
                    .frame(width: 100)
                }
                HStack {
                    Label("purchase-mileage", systemImage: "point.bottomleft.forward.to.arrow.triangle.scurvepath.fill")
                    Spacer()
                    TextField(
                        "purchase-mileage",
                        text: Binding(
                            get: {
                                bicycle.purchaseMileage.map {
                                    String(format: "%.0f", $0)
                                } ?? ""
                            },  // Konvertiere `Double?` zu `String`
                            set: { bicycle.purchaseMileage = Double($0) }  // Konvertiere `String` zurück zu `Double?`
                        ))
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.numberPad)
                    .frame(width: 100)
                }

            }
            Section("bike-details") {
                HStack {
                    Label("bike-color", systemImage: "paintpalette")
                    Spacer()
                    ColorPicker(
                        "",
                        selection: Binding(
                            get: {
                                Color(
                                    red: bicycle.colorRed,
                                    green: bicycle.colorGreen,
                                    blue: bicycle.colorBlue)
                            },
                            set: { newColor in
                                let components = newColor.components
                                bicycle.colorRed = components.red
                                bicycle.colorGreen = components.green
                                bicycle.colorBlue = components.blue
                            }
                        ))
                }
                HStack {
                    Label(
                        "service-interval",
                        systemImage:
                            "gauge.open.with.lines.needle.67percent.and.arrowtriangle"
                    )
                    Spacer()
                    TextField(
                        "",
                        text: Binding(
                            get: {
                                bicycle.serviceInterval.map {
                                    String(describing: $0)
                                } ?? ""
                            },  // Konvertiere `Decimal?` zu `String`
                            set: { bicycle.purchasePrice = Decimal(string: $0) }  // Konvertiere `String` zurück zu `Decimal?`
                        ))
                    .multilineTextAlignment(.trailing)
                    .frame(width: 100)
                }
                HStack {
                    Label("frame-number", systemImage: "numbers.rectangle")
                    Spacer()
                    TextField("", text: $bicycle.frameNumber)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 130)
                }
            }

            Section {
                HStack {
                    Text("ride-history")
                        .foregroundStyle(.secondary)
                        .fontWeight(.semibold)
                    Spacer()
                    Button(action: {
                        isAddingRide.toggle()
                    }) {
                        Label("Add", systemImage: "plus.circle")
                    }
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
                if bicycle.rides.isEmpty {
                    Text("No rides recorded yet.")
                        .foregroundStyle(.secondary)
                        .listRowBackground(Color.clear)
                } else {
                    ForEach(
                        bicycle.rides.sorted(by: { $0.timestamp > $1.timestamp }
                        )
                    ) { ride in
                        NavigationLink(destination: RideDetailView(ride: ride))
                        {
                            VStack(alignment: .leading) {
                                Text(ride.timestamp, style: .date)
                                    .font(.headline)
                                Text(
                                    "Distance: \(ride.distance, specifier: "%.2f") km"
                                )
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .onDelete(perform: deleteRide)
                }

        }
        .sheet(isPresented: $isAddingRide) {
            AddRideView(bicycle: bicycle, isEditable: false)
        }
        .navigationTitle(bicycle.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    func deleteRide(at offsets: IndexSet) {
        for index in offsets {
            let ride = bicycle.rides[index]
            modelContext.delete(ride)  // Fahrt aus dem Modellkontext entfernen
        }
    }
}

#Preview {
    NavigationStack {
        BicycleDetailView(bicycle: Bicycle(name: "Fahrrad 1"))
    }
}
