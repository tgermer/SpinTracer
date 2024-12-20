#  SpinTracer

## Der Name

Der Name SpinTrace setzt sich aus zwei Teilen zusammen:
1. Spin: Das Drehen der Pedale, eine häufig verwendete Metapher fürs Fahrradfahren.
2. Trace: Rückverfolgen oder Aufzeichnen von etwas, wie die Route oder die Daten deiner Fahrten.

## Der Untertitel

1. “Explore rides, unlock stats.”
2. “Track rides, reveal stats.”
3. “Unlock stats, ride smarter.”
4. “Discover rides, track stats.”


---

//
//  Model.swift
//  SpinTrace
//
//  Created by Tristan Germer on 09.12.24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Bicycle : ObservableObject, Identifiable {
    var id: UUID
    var name: String
    var image: Data?
    var purchaseDate: Date?
    var currentMileage: Double?
    var purchasePrice: Decimal?
    var frameNumber: String?
    var colorRed: Double?
    var colorGreen: Double?
    var colorBlue: Double?
    var serviceInterval: Double?
    var totalMileage: Double {
        // Logic to calculate total mileage from rides (computed property)
        return rides.reduce(0) { sum, ride in sum + ride.distance }
      }
    @Relationship(deleteRule: .cascade) var rides: [Ride] = []
    @Relationship(deleteRule: .cascade) var services: [Service] = []
    
//    init(name: String, purchaseDate: Date, currentMileage: Double, purchasePrice: Decimal, frameNumber: String, colorRed: Double, colorGreen: Double, colorBlue: Double, serviceInterval: Double) {
//        self.id = UUID()
//        self.name = name
//        self.purchaseDate = purchaseDate
//        self.currentMileage = currentMileage
//        self.purchasePrice = purchasePrice
//        self.frameNumber = frameNumber
//        self.colorRed = colorRed
//        self.colorGreen = colorGreen
//        self.colorBlue = colorBlue
//        self.serviceInterval = serviceInterval
//    }
    
    init(id: UUID = .init(), name: String) {
        self.id = id
        self.name = name
        self.purchaseDate = Date() // Standardwert: heutiges Datum
        self.currentMileage = 0 // Standardwert: 0
        self.purchasePrice = 0 // Standardwert: 0
        self.frameNumber = "" // Standardwert: leerer String
        self.colorRed = 0.5 // Standardwert: Mittelwert für Farbe
        self.colorGreen = 0.5
        self.colorBlue = 0.5
        self.serviceInterval = 1000 // Standardwert: 1000 km
    }
}

@Model
final class Ride: Identifiable {
    var timestamp: Date
    var distance: Double
    var averageSpeed: Double
    var caloriesBurned: Double
    var duration: TimeInterval
    @Relationship var category: RideCategory?
    @Relationship var bicycle: Bicycle?

    init(timestamp: Date, distance: Double, averageSpeed: Double, caloriesBurned: Double, duration: TimeInterval, category: RideCategory, bicycle: Bicycle?) {
        self.timestamp = timestamp
        self.distance = distance
        self.averageSpeed = averageSpeed
        self.caloriesBurned = caloriesBurned
        self.duration = duration
        self.category = category
        self.bicycle = bicycle
    }
}

@Model
final class Service: Identifiable {
    var id: UUID
    var date: Date
    var mileage: Double
    var serviceDescription: String
    @Relationship var category: ServiceCategory?
    var cost: Decimal
    @Relationship var bicycle: Bicycle?
    
    init(date: Date, mileage: Double, serviceDescription: String, category: ServiceCategory, cost: Decimal, bicycle: Bicycle?) {
        self.id = UUID()
        self.date = date
        self.mileage = mileage
        self.serviceDescription = serviceDescription
        self.category = category
        self.cost = cost
        self.bicycle = bicycle
    }
}

@Model
final class RideCategory: Identifiable {
    var id: UUID
    var name: String
    
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}

@Model
final class ServiceCategory: Identifiable {
    var id: UUID
    var name: String
    
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}

