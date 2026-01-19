//
//  AddWorkoutView.swift
//  Journey
//
//  Created by Suryansh Ankur on 2026-01-19.
//

import SwiftUI
import SwiftData

struct AddWorkoutView: View {
    @Environment(\.dismiss) var dismiss
    var exercise: Exercise // We pass the exercise we are editing
    
    @State private var date = Date()
    @State private var setsInput: [SetInput] = [SetInput()] // Start with 1 empty set

    var body: some View {
        NavigationStack {
            Form {
                Section("Date") {
                    DatePicker("Workout Date", selection: $date, displayedComponents: .date)
                }
                
                Section("Sets") {
                    ForEach($setsInput) { $set in
                        HStack {
                            Text("Set \(setsInput.firstIndex(where: { $0.id == set.id })! + 1)")
                                .foregroundStyle(.secondary)
                                .frame(width: 50, alignment: .leading)
                            
                            TextField("Lbs", value: $set.weight, format: .number)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.roundedBorder)
                            
                            TextField("Reps", value: $set.reps, format: .number)
                                .keyboardType(.numberPad)
                                .textFieldStyle(.roundedBorder)
                        }
                    }
                    .onDelete { indexSet in
                        setsInput.remove(atOffsets: indexSet)
                    }
                    
                    Button("Add Another Set") {
                        withAnimation {
                            setsInput.append(SetInput())
                        }
                    }
                }
            }
            .navigationTitle("Log \(exercise.name)")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveWorkout()
                    }
                }
            }
        }
    }
    
    private func saveWorkout() {
        // 1. Create the Log Container
        let newLog = WorkoutLog(date: date)
        
        // 2. Convert our UI "inputs" into real Database objects
        for (index, input) in setsInput.enumerated() {
            // Only save if they actually typed numbers
            if let w = input.weight, let r = input.reps {
                let setEntry = SetEntry(weight: w, reps: r, setNumber: index + 1)
                newLog.sets.append(setEntry)
            }
        }
        
        // 3. Link the log to the exercise
        // Because of SwiftData relationships, just appending it saves it automatically!
        exercise.logs.append(newLog)
        
        //try? modelContext.save()
        
        dismiss()
    }
}

// A simple temporary struct to hold data while typing, before we save to database
struct SetInput: Identifiable {
    let id = UUID()
    var weight: Double?
    var reps: Int?
}
