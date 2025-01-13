//
//  Habit.swift
//  trophyhabits
//
//  Created by Landon West on 1/1/25.
//


import SwiftData
import SwiftUI

@Model
class Habit {
    @Attribute(.unique) var id: UUID = UUID() // Unique identifier
    var icon: String
    var habit: String
    var dayCompletion: [String: Bool]
    var streak: Int

    init(icon: String, habit: String, dayCompletion: [String: Bool] = [:], streak: Int = 0) {
        self.icon = icon
        self.habit = habit
        self.dayCompletion = dayCompletion
        self.streak = streak
    }
    
    // Function to calculate streak
    func computeStreak(for date: Date) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        var currentDate = Calendar.current.date(byAdding: .day, value: -1, to: date)!
        var streakCount = 0
        
        while true {
            let dateString = formatter.string(from: currentDate)
            if let completed = dayCompletion[dateString], completed {
                streakCount += 1
                // Move to the previous day
                currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
            } else {
                break
            }
        }
        
        return streakCount
    }
    
    func computeContinuedStreak(for date: Date) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        var currentDate = date
        var streakCount = 0
        
        while true {
            let dateString = formatter.string(from: currentDate)
            if let completed = dayCompletion[dateString], completed {
                streakCount += 1
                // Move to the previous day
                currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
            } else {
                break
            }
        }
        
        return streakCount
    }
}
