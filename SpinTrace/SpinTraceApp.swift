import SwiftData
import SwiftUI

@main
struct SpinTraceApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Bicycle.self,
                              Ride.self,
                              Service.self,
                              RideCategory.self,
                              RideCategory.self])
    }
}
