import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    // Fetch all exercises (default sort doesn't matter much as we will re-sort)
    @Query private var exercises: [Exercise]
    
    @State private var showingAddExercise = false
    @AppStorage("username") private var username = ""
    
    // 1. State for Sort Option
    enum SortOption {
        case name
        case frequency
    }
    @State private var sortOption: SortOption = .name

    // 2. Computed property that returns the sorted list
    var sortedExercises: [Exercise] {
        switch sortOption {
        case .name:
            return exercises.sorted { $0.name < $1.name }
        case .frequency:
            // Sort by how many logs exist (descending), then by name as a tie-breaker
            return exercises.sorted {
                if $0.logs.count == $1.logs.count {
                    return $0.name < $1.name
                }
                return $0.logs.count > $1.logs.count
            }
        }
    }

    var body: some View {
        NavigationStack {
            List {
                // Use our computed 'sortedExercises' instead of the raw query
                ForEach(sortedExercises) { exercise in
                    NavigationLink(destination: ExerciseDetailView(exercise: exercise)) {
                        HStack {
                            Text(exercise.name)
                                .font(.headline)
                            Spacer()
                            // Optional: Show the count if sorting by frequency so user knows why it's at the top
                            if sortOption == .frequency {
                                Text("\(exercise.logs.count) logs")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            //.navigationTitle("My Exercises")
            .navigationTitle("Hi, \(username)!")
            .toolbar {
                // 3. The Sort Menu (Top Leading)
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Picker("Sort By", selection: $sortOption) {
                            Text("Name (A-Z)").tag(SortOption.name)
                            Text("Most Used").tag(SortOption.frequency)
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down.circle")
                    }
                }
                
                // The + Button (Top Trailing)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddExercise = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddExercise) {
                AddExerciseView()
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            // Important: Delete the correct item from the SORTED list
            for index in offsets {
                let exerciseToDelete = sortedExercises[index]
                modelContext.delete(exerciseToDelete)
            }
        }
    }
}
