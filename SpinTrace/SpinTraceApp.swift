//
//  SpinTraceApp.swift
//  SpinTrace
//
//  Created by Tristan Germer on 09.12.24.
//

import SwiftData
import SwiftUI

@main
struct RideTrackerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Bicycle.self, Ride.self, Service.self,
            RideCategory.self, ServiceCategory.self,
        ])

        // Prüfe, ob die App im Debug-Modus läuft
        #if DEBUG
            let configuration = ModelConfiguration(
                schema: schema, isStoredInMemoryOnly: true
            )
        #else
            let configuration = ModelConfiguration(
                schema: schema,
                cloudKitContainerIdentifier:
                    "iCloud.de.tristan-germer.SpinTrace"
            )
        #endif

        do {
            return try ModelContainer(
                for: schema,
                configurations: [configuration]
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
