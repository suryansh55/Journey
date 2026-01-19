import SwiftUI
import SwiftData

struct AddExerciseView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // 1. Fetch all existing exercises to check for duplicates
    @Query private var existingExercises: [Exercise]
    
    @State private var name = ""
    @State private var showAlert = false // Controls the error popup

    var body: some View {
        NavigationStack {
            Form {
                TextField("Exercise Name (e.g. Bench Press)", text: $name)
                
                // Helper text to show user if they are typing a duplicate
                if isDuplicate {
                    Text("This exercise already exists.")
                        .foregroundStyle(.red)
                        .font(.caption)
                }
            }
            .navigationTitle("New Exercise")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        addExercise()
                    }
                    // Disable save if name is empty OR it's a duplicate
                    .disabled(name.isEmpty || isDuplicate)
                }
            }
        }
    }
    
    // Computed property to check duplication in real-time
    private var isDuplicate: Bool {
        existingExercises.contains { exercise in
            exercise.name.localizedCaseInsensitiveCompare(name.trimmingCharacters(in: .whitespaces)) == .orderedSame
        }
    }
    
    private func addExercise() {
        let cleanName = name.trimmingCharacters(in: .whitespaces)
        let newExercise = Exercise(name: cleanName)
        modelContext.insert(newExercise)
        try? modelContext.save()
        dismiss()
    }
}
