import SwiftUI

struct WelcomeView: View {
    // This connects to the permanent storage on the phone
    @AppStorage("username") private var username = ""
    
    @State private var inputName = ""

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "dumbbell.fill")
                .font(.system(size: 80))
                .foregroundStyle(.blue)
                .padding(.bottom, 20)
            
            Text("Welcome to GymTracker")
                .font(.largeTitle)
                .bold()
            
            Text("What should we call you?")
                .foregroundStyle(.secondary)
            
            TextField("Enter your name", text: $inputName)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
                .multilineTextAlignment(.center)
            
            Button("Start Journey") {
                // Saving to this variable automatically switches the screen in the main app
                username = inputName
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(inputName.isEmpty)
        }
        .padding()
    }
}
