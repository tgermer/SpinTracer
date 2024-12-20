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
    @Attribute(.unique) var name: String
    var image: Data?
    var purchaseDate: Date
    var purchaseMileage: Double?
    var purchasePrice: Decimal?
    var frameNumber: String
    var colorRed: Double
    var colorGreen: Double
    var colorBlue: Double
    var serviceInterval: Double?
    var totalMileage: Double {
        let purchaseMileage = purchaseMileage ?? 0 // Fallback auf 0, falls purchaseMileage nil ist
        let rideMileage = rides.reduce(0) { sum, ride in sum + ride.distance }
        return purchaseMileage + rideMileage
    }
    @Relationship(deleteRule: .cascade) var rides: [Ride] = []
    @Relationship(deleteRule: .cascade) var services: [Service] = []
    
//    init(name: String, purchaseDate: Date, purchaseMileage: Double, purchasePrice: Decimal, frameNumber: String, colorRed: Double, colorGreen: Double, colorBlue: Double, serviceInterval: Double) {
//        self.id = UUID()
//        self.name = name
//        self.purchaseDate = purchaseDate
//        self.purchaseMileage = purchaseMileage
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
        self.purchaseMileage = 0 // Standardwert: 0
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
    @Relationship(deleteRule: .nullify) var category: RideCategory?
    @Relationship var bicycle: Bicycle

    init(timestamp: Date, distance: Double, averageSpeed: Double, caloriesBurned: Double, duration: TimeInterval, category: RideCategory? = nil, bicycle: Bicycle) {
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
    @Attribute(.unique) var name: String
    var orderIndex: Int // Zum Speichern der Sortierreienfolge
    
    init(name: String, orderIndex: Int = 0) {
        self.id = UUID()
        self.name = name
        self.orderIndex = orderIndex
    }
}

@Model
final class ServiceCategory: Identifiable {
    var id: UUID
    @Attribute(.unique) var name: String
    
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}
