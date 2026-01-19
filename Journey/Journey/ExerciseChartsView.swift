import SwiftUI
import Charts

struct ExerciseChartsView: View {
    var logs: [WorkoutLog]
    
    // We toggle between these 3 modes
    @State private var selectedMetric = "Weight"
    let metrics = ["Weight", "Total Reps", "Total Sets"]

    var body: some View {
        VStack(alignment: .leading) {
            
            // 1. The Selector
            Picker("Metric", selection: $selectedMetric) {
                ForEach(metrics, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)
            .padding(.bottom)

            // 2. The Chart
            Chart {
                ForEach(logs.sorted(by: { $0.date < $1.date })) { log in
                    
                    if selectedMetric == "Weight" {
                        // Chart 1: Max Weight (Line)
                        if let maxWeight = log.sets.map({ $0.weight }).max() {
                            LineMark(
                                x: .value("Date", log.date, unit: .day),
                                y: .value("Max Weight", maxWeight)
                            )
                            .symbol(by: .value("Date", log.date))
                            .interpolationMethod(.catmullRom)
                        }
                        
                    } else if selectedMetric == "Total Reps" {
                        // Chart 2: Total Volume/Reps (Line)
                        let totalReps = log.sets.reduce(0) { $0 + $1.reps }
                        
                        LineMark(
                            x: .value("Date", log.date, unit: .day),
                            y: .value("Total Reps", totalReps)
                        )
                        .foregroundStyle(.green) // Green line for reps
                        .symbol(by: .value("Date", log.date))
                        .interpolationMethod(.catmullRom)
                        
                    } else {
                        // Chart 3: Total Sets (Line)
                        LineMark(
                            x: .value("Date", log.date, unit: .day),
                            y: .value("Total Sets", log.sets.count)
                        )
                        .foregroundStyle(.purple) // Purple line for sets
                        .symbol(by: .value("Date", log.date))
                        .interpolationMethod(.catmullRom)
                    }
                }
            }
            .frame(height: 250)
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
