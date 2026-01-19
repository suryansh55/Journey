# GymTracker 🏋️‍♂️

A modern, native iOS application for tracking workout progress, built entirely with **SwiftUI** and **SwiftData**. 

This project demonstrates a local-first architecture that prioritizes performance and data persistence without external dependencies. It features dynamic data visualization to track strength progression over time.

![App Screenshot](https://via.placeholder.com/800x400?text=Insert+App+Screenshot+Here)

## 🚀 Features

* **Persistent Data Storage:** Uses **SwiftData** (SQLite) to save exercises, logs, and set details permanently on-device.
* **Dynamic Visualization:** Interactive graphs built with **Swift Charts** that visualize trends in Weight, Total Reps, and Total Volume.
* **Smart Input:** Prevents duplicate exercise entries and validates user input for data integrity.
* **Personalized Experience:** Onboarding flow that remembers the user's name using `@AppStorage`.
* **Sorting & Filtering:** Algorithms to sort exercises by alphabetical order or usage frequency ("Most Popular").
* **Clean UI:** A native iOS design language using NavigationStacks, Sheets, and Form controls.

## 🛠 Tech Stack

* **Language:** Swift 5.9+
* **UI Framework:** SwiftUI
* **Database:** SwiftData (Schema, ModelContext, Relationships)
* **Charting:** Swift Charts
* **Architecture:** MVVM principles with declarative UI



## 🔧 How to Run

Since this project uses Apple's native frameworks, there are **no external dependencies** (no CocoaPods or SPM packages required).

1.  Clone the repository:
    ```bash
    git clone [https://github.com/suryansh55/Journey.git](https://github.com/suryansh55/Journey.git)
    ```
2.  Open `Journey.xcodeproj` in **Xcode 15** (or later).
3.  Ensure the target is set to **iOS 17.0+**.
4.  Press `Cmd + R` to run on the Simulator or a physical device.

## 💡 Code Highlights

### SwiftData Modeling
The app uses a strict relational schema to link Exercises to Workout Logs and Sets:

```swift
@Model
class Exercise {
    var name: String
    @Relationship(deleteRule: .cascade) var logs: [WorkoutLog] = []
    // ...
}