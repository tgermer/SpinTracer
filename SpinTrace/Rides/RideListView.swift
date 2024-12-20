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

    
    var body: some View {
        NavigationStack {
            content
            .navigationTitle("tab-rides")
        }
    }
    
    func deleteRide(at offsets: IndexSet) {
        for index in offsets {
            let ride = rides[index]
            modelContext.delete(ride)  // Fahrt aus dem Modellkontext entfernen
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
                    Label {
                        Text("No Rides")
                    } icon: {
                        EmptyView() // Kein Bild
                    }
                }
            },
//                Label("No Rides", image: "SpinTraceTabViewIcon")
//                    .symbolRenderingMode(.hierarchical)            },
            description: {
                Text("Rides you add will appear here.")
            },
            actions: {
                Button("Add Ride") {
//                    newBicycleSheet.toggle()
                }
                .buttonBorderShape(.roundedRectangle)
                .buttonStyle(.borderedProminent)
            }
        )
    }

    var listView: some View {
        List {
            ForEach(rides) { ride in
                NavigationLink(destination: RideDetailView(ride: ride))
                {
                    VStack(alignment: .leading) {
                        Text(ride.timestamp, style: .date)
                            .font(.headline)
                        HStack {
                            Text(
                                "Distance: \(ride.distance, specifier: "%.1f") km"
                            )
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
