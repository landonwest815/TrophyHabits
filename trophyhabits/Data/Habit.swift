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
}
