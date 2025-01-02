//
//  HomeView.swift
//  trophyhabits
//
//  Created by Landon West on 12/17/24.
//

import SwiftUI
import ConfettiSwiftUI

struct HomeView: View {
    
    @State private var selectedDate: Date = Date() // Default to today
    
    @State private var habits = Array(repeating: false, count: 6)
    @State private var medalUpgrade = false
    
    @State private var showConfetti: Int = 0
    @State private var isCooldownActive: Bool = false // Cooldown state

    var trueCount: Int {
        habits.filter { $0 }.count
    }
    
    var allCompleted: Bool {
        trueCount == habits.count
    }

    var progress: Double {
        Double(trueCount) / Double(habits.count)
    }

    // Sheets
    @State private var activeSheet: ActiveSheet?
    
    enum ActiveSheet: Identifiable {
        case trophyRoom, calendar
        
        var id: String {
            switch self {
            case .trophyRoom:
                return "trophyRoom"
            case .calendar:
                return "calendar"
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                // This week calendar
                VStack(spacing: 15) {
                    VStack {
                        let calendar = Calendar.current
                        let today = Date()
                        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
                        WeekView(startDate: startOfWeek, selectedDate: $selectedDate)
                    }
                }
                .padding(.top, 10)

                Spacer()

                // Progress circle
                ProgressView(progress: progress, medalUpgrade: $medalUpgrade, trueCount: trueCount)
                    .onChange(of: trueCount) { oldValue, newValue in
                        if newValue > oldValue && (newValue == 2 || newValue == 4 || newValue == 6) {
                            medalUpgrade.toggle()
                        }
                    }

                Spacer()

                // Habit tiles
                VStack(spacing: 15) {
                    habitRow(habits: [
                        ("pencil.and.scribble", "Review Notes", 2),
                        ("apple.terminal", "Leetcode Problem", 3),
                        ("carrot.fill", "Snack Less", 0)
                    ], startIndex: 0)

                    habitRow(habits: [
                        ("figure.walk.motion", "10,000 Steps", 0),
                        ("bolt.fill", "Charge Devices", 0),
                        ("bed.double.fill", "8 Hours of Sleep", 0)
                    ], startIndex: 3)

                    HStack(spacing: 5) {
                        Image(systemName: "info.circle")
                        Text("Tap and Hold for Habit Details")
                    }
                    .font(.footnote)
                    .fontWeight(.regular)
                    .fontDesign(.rounded)
                    .foregroundStyle(.gray)
                }
                .padding(.top, 10)
                .frame(maxWidth: .infinity, maxHeight: 375)
                .padding(.bottom)
                .background(.ultraThinMaterial)
                .cornerRadius(32)
            }
            .ignoresSafeArea(edges: .bottom)
            
            // Topbar sheet prompters
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        // Placeholder for settings action
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(.gray)
                    }
                }

                ToolbarItem(placement: .principal) {
                    Button {
                        activeSheet = .calendar
                    } label: {
                        HStack {
                            Image(systemName: "calendar")
                                .font(.subheadline)
                            Text(dateString(for: selectedDate))
                                .font(.title3)
                        }
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)
                        .foregroundStyle(.white)
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        activeSheet = .trophyRoom
                    } label: {
                        Image(systemName: "trophy.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 25)
                            .foregroundStyle(.yellow)
                    }
                }
            }
            .onChange(of: allCompleted) {
                if $0 && !isCooldownActive {
                    triggerConfettiWithCooldown()
                }
            }
        }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .trophyRoom:
                TrophyAndMedalStatsView()
                    .presentationDetents([.fraction(0.7)])
                    .presentationCornerRadius(32)
            case .calendar:
                CalendarSheet()
                    .presentationDetents([.fraction(0.84)])
                    .presentationCornerRadius(32)
            }
        }
        .preferredColorScheme(.dark)
        .confettiCannon(
            counter: $showConfetti,
            num: 25, colors: [Color.yellow, Color.yellow.opacity(0.5), Color.yellow.opacity(0.75), Color.yellow.opacity(0.25)], // Number of particles
            confettiSize: 10, // Size of particles
            radius: 300, // Spread radius
            repetitions: 1, // Single explosion
            repetitionInterval: 0.1 // Minimal interval (not relevant for 1 repetition)
        )
    }
    
    func triggerConfettiWithCooldown() {
        // Trigger the confetti
        showConfetti += 1
        // Activate the cooldown
        isCooldownActive = true

        // Set cooldown duration (e.g., 3 seconds)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            isCooldownActive = false
        }
    }

    func habitRow(habits: [(String, String, Int)], startIndex: Int) -> some View {
        HStack(spacing: 15) {
            ForEach(0..<habits.count, id: \.self) { index in
                HabitView(
                    icon: habits[index].0,
                    habit: habits[index].1,
                    completed: $habits[startIndex + index],
                    streak: habits[index].2
                )
            }
        }
    }
    
    func countColor(for count: Int) -> Color {
        switch count {
        case ..<2: return .clear
        case ..<4: return .brown
        case ..<6: return .gray
        case 6: return .yellow
        default: return .clear // Optional: handle unexpected values
        }
    }
}



struct HabitView: View {
    var icon: String
    var habit: String
    @Binding var completed: Bool
    var streak: Int

    @State private var isDetailSheetPresented = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button {
                // Action handled by gestures
            } label: {
                ZStack {
                    VStack(spacing: 15) {
                        Image(systemName: icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .foregroundStyle(completed ? .gray : .white)

                        Text(habit)
                            .font(.headline)
                            .fontDesign(.rounded)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                            .frame(width: 75, height: 50)
                            .foregroundStyle(.white)
                            .strikethrough(completed)
                    }
                }
                .padding()
                .background(completed ? .clear : Color(red: 0.2, green: 0.2, blue: 0.2))
                .cornerRadius(20)
            }
            .simultaneousGesture(LongPressGesture().onEnded { _ in
                isDetailSheetPresented.toggle()
            })
            .simultaneousGesture(TapGesture().onEnded {
                withAnimation(.bouncy) {
                    completed.toggle()
                }
            })

            if streak > 0 {
                ZStack {
                    Image(systemName: "flame.fill")
                        .resizable()
                        .frame(width: 25, height: 27.5)
                        .foregroundStyle(.red.opacity(1))

                    Image(systemName: "flame")
                        .resizable()
                        .frame(width: 25, height: 27.5)
                        .foregroundStyle(.red.opacity(1))

                    Text("\(streak)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .offset(x: 0, y: 1)
                }
                .offset(x: 3, y: -3)
            }
        }
        .sheet(isPresented: $isDetailSheetPresented) {
            HabitDetailView(habit: habit, icon: icon, streak: streak, completed: completed)
                .presentationDetents(.init([.fraction(0.6)]))
                .presentationCornerRadius(32)
        }
    }
}



func randomMedalColor() -> Color {
    let colors: [Color] = [.yellow, .brown, .gray, .clear]
    return colors.randomElement() ?? .yellow
}

func randomTrophyColor() -> Color {
    let colors: [Color] = [.yellow, .brown, .gray, .gray.opacity(0.15)]
    return colors.randomElement() ?? .yellow
}



#Preview {
    HomeView()
}
