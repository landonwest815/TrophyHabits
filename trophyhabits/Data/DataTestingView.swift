//
//  ContentView.swift
//  trophyhabits
//
//  Created by Landon West on 1/1/25.
//


import SwiftUI
import SwiftData

struct DataTestingView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Habit.habit) private var habits: [Habit]

    var body: some View {
        NavigationView {
            List {
                ForEach(habits) { habit in
                    Text(habit.habit)
                }
                .onDelete(perform: deleteHabits)
            }
            .navigationTitle("Habits")
            .toolbar {
                Button {
                    addHabit(length: habits.count)
                } label: {
                    Label("Add Habit", systemImage: "plus")
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private func addHabit(length: Int) {
        let newHabit = Habit(icon: "star", habit: "Habit \(length)")
        modelContext.insert(newHabit)
    }

    private func deleteHabits(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(habits[index])
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Habit.self, configurations: config)

    return DataTestingView()
        .modelContainer(container)
}
