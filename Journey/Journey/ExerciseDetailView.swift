import SwiftUI
import SwiftData

struct ExerciseDetailView: View {
    @Bindable var exercise: Exercise
    @State private var showingLogSheet = false
    
    var body: some View {
        List {
            // Section 1: The Charts (Only show if we have data)
            if !exercise.logs.isEmpty {
                Section {
                    ExerciseChartsView(logs: exercise.logs)
                        .listRowInsets(EdgeInsets()) // Removes default padding for a cleaner look
                }
            }
            
            // Section 2: History of logs
            Section("History") {
                if exercise.logs.isEmpty {
                    Text("No logs yet. Go lift something!")
                        .foregroundStyle(.secondary)
                } else {
                    // Sort logs by date (newest first)
                    ForEach(exercise.logs.sorted(by: { $0.date > $1.date })) { log in
                        VStack(alignment: .leading) {
                            Text(log.date.formatted(date: .abbreviated, time: .omitted))
                                .font(.headline)
                            
                            ForEach(log.sets.sorted(by: { $0.setNumber < $1.setNumber })) { set in
                                HStack {
                                    Text("Set \(set.setNumber):")
                                        .foregroundStyle(.secondary)
                                    Text("\(set.weight.formatted()) lbs x \(set.reps) reps")
                                        .bold()
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete(perform: deleteLog)
                }
            }
        }
        .navigationTitle(exercise.name)
        .toolbar {
            Button("Log Workout") {
                showingLogSheet = true
            }
        }
        .sheet(isPresented: $showingLogSheet) {
            AddWorkoutView(exercise: exercise)
        }
    }
    
    private func deleteLog(at offsets: IndexSet) {
        let sortedLogs = exercise.logs.sorted(by: { $0.date > $1.date })
        for index in offsets {
            let logToDelete = sortedLogs[index]
            if let originalIndex = exercise.logs.firstIndex(of: logToDelete) {
                exercise.logs.remove(at: originalIndex)
            }
        }
    }
}
