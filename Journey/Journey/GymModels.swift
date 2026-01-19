//
//  GymModels.swift
//  Journey
//
//  Created by Suryansh Ankur on 2026-01-19.
//
import Foundation
import SwiftData

@Model
class Exercise {
    var id: UUID
    var name: String
    // Relationship: One exercise has many logs over time
    @Relationship(deleteRule: .cascade) var logs: [WorkoutLog] = []

    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}

@Model
class WorkoutLog {
    var id: UUID
    var date: Date
    var exercise: Exercise?
    // Relationship: One log has many sets
    @Relationship(deleteRule: .cascade) var sets: [SetEntry] = []

    init(date: Date = Date()) {
        self.id = UUID()
        self.date = date
    }
}

@Model
class SetEntry {
    var id: UUID
    var weight: Double
    var reps: Int
    var setNumber: Int
    
    init(weight: Double, reps: Int, setNumber: Int) {
        self.id = UUID()
        self.weight = weight
        self.reps = reps
        self.setNumber = setNumber
    }
}
