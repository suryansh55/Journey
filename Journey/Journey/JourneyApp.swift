import SwiftUI
import SwiftData

@main
struct JourneyApp: App {
    @AppStorage("username") private var username = ""

    // 1. Create the container explicitly so we know it exists permanently
    let container: ModelContainer

    init() {
        do {
            // This forces the database to be stored in a file called "GymData.sqlite"
            let schema = Schema([
                Exercise.self,
                WorkoutLog.self,
                SetEntry.self,
            ])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            // The logic remains the same
            if username.isEmpty {
                WelcomeView()
            } else {
                ContentView()
            }
        }
        // 2. Attach the explicit container we created above
        .modelContainer(container)
    }
}
