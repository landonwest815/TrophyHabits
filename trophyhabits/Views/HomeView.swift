//
//  HomeView.swift
//  trophyhabits
//
//  Created by Landon West on 12/17/24.
//

import SwiftUI
import ConfettiSwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Habit.habit) private var habits: [Habit]

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    @State private var selectedDate: Date = Date()
    @State private var previousDate: Date = Date() // Tracks previously selected date

    @State private var medalUpgrade = false
    @State private var previousProgress: Double = 0.0 // Track previous progress

    @State private var showConfetti: Int = 0
    @State private var isCooldownActive: Bool = false
    @State private var activeSheet: ActiveSheet?

    // Computed Properties
    private var trueCount: Int {
        habits.filter { $0.dayCompletion[dataDateString(for: selectedDate)] ?? false }.count
    }

    private var allCompleted: Bool {
        trueCount == habits.count
    }

    private var progress: Double {
        habits.isEmpty ? 0.0 : Double(trueCount) / Double(habits.count)
    }

    enum ActiveSheet: Identifiable {
        case trophyRoom, calendar

        var id: String {
            switch self {
            case .trophyRoom: return "trophyRoom"
            case .calendar: return "calendar"
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Week Calendar
                WeekCalendarView(selectedDate: $selectedDate)

                Spacer()

                // Progress View
                ProgressView(progress: progress, medalUpgrade: $medalUpgrade, trueCount: trueCount)
                    .onChange(of: allCompleted) {
                        if selectedDate == previousDate && allCompleted && !isCooldownActive {
                            triggerConfettiWithCooldown()
                        }
                    }
                    .onChange(of: selectedDate) {
                        previousDate = selectedDate // Update the previous date whenever the selected date changes
                    }
                    .onChange(of: progress) {
                        triggerMedalUpgradeIfNeeded()
                    }

                Spacer()

                HabitGridView(
                    habits: habits,
                    selectedDate: selectedDate,
                    addHabit: addHabit,
                    columns: columns
                )
                .frame(maxWidth: .infinity, maxHeight: 333)
                .padding(20)
                .padding(.bottom, 10)
                .background(.ultraThinMaterial)
                .cornerRadius(32)
            }
            .ignoresSafeArea(edges: .bottom)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {}) {
                        Image(systemName: "gearshape.fill").foregroundStyle(.gray)
                    }
                }

                ToolbarItem(placement: .principal) {
                    Button {
                        activeSheet = .calendar
                    } label: {
                        HStack {
                            Image(systemName: "calendar")
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
                        withAnimation { addHabit() }
                    } label: {
                        Label("Add Habit", systemImage: "plus")
                    }
                    .disabled(habits.count >= 6)
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
            .confettiCannon(counter: $showConfetti, num: 30, colors: [.yellow, .gray, .brown], confettiSize: 15, rainHeight: 200, radius: 350)
        }
    }
    
    private func triggerConfettiWithCooldown() {
        // Trigger the confetti
        showConfetti += 1
        // Activate cooldown
        isCooldownActive = true

        // Set cooldown duration (e.g., 3 seconds)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            isCooldownActive = false
        }
    }
    
    private func triggerMedalUpgradeIfNeeded() {
        let thresholds: [(Double, String)] = [
            (0.33, "bronze"),
            (0.66, "silver"),
            (1.0, "gold")
        ]
        
        for (threshold, _) in thresholds {
            if previousProgress < threshold && progress >= threshold {
                medalUpgrade.toggle()
                break // Trigger only one medal upgrade per progress change
            }
        }

        previousProgress = progress // Update the previous progress
    }

    private func addHabit() {
        let newHabit = Habit(icon: "star", habit: "New Habit", dayCompletion: [:], streak: 0)
        modelContext.insert(newHabit)
        do {
            try modelContext.save()
        } catch {
            print("Error saving habit: \(error)")
        }
    }
}

func dataDateString(for date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: date)
}

struct HabitGridView: View {
    var habits: [Habit]
    var selectedDate: Date
    var addHabit: () -> Void
    var columns: [GridItem]

    var body: some View {
        VStack {
            // Habit Grid
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(habits, id: \.id) { habit in
                    HabitView(habit: habit, selectedDate: selectedDate)
                }
                if habits.count < 6 {
                    AddHabitCard(action: addHabit)
                }
            }
            .animation(.easeInOut, value: habits)
            
            Spacer()
        }
    }
}

struct AddHabitCard: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                VStack(spacing: 15) {
                    Image(systemName: "plus")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.gray)
                }
                .frame(width: 107.5, height: 145)
                .background(Color(red: 0.15, green: 0.15, blue: 0.15))
                .cornerRadius(20)
            }
        }
    }
}

import SwiftUI
import CoreHaptics

struct HabitView: View {
    var habit: Habit
    var selectedDate: Date

    @State private var isDetailSheetPresented = false
    @State private var dragOffset: CGFloat = 0
    @State private var hasReachedMaxDistance: Bool = false

    private let maxDragDistance: CGFloat = -15 // Maximum drag distance (negative for upward drag)

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 10) {
                Image(systemName: habit.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundStyle(habit.dayCompletion[dataDateString(for: selectedDate)] ?? false ? .gray : .white)

                Text(habit.habit)
                    .font(.headline)
                    .fontDesign(.rounded)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .frame(width: 75, height: 50)
                    .foregroundStyle(.white)
                    .strikethrough(habit.dayCompletion[dataDateString(for: selectedDate)] ?? false)
            }
            .frame(width: 107.5, height: 145)
            .background(habit.dayCompletion[dataDateString(for: selectedDate)] ?? false ? .clear : Color(red: 0.2, green: 0.2, blue: 0.2))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(hasReachedMaxDistance ? Color.white : Color.clear, lineWidth: 2.5)
            )
            .offset(y: dragOffset)
            .simultaneousGesture(TapGesture().onEnded {
                withAnimation(.bouncy) {
                    if let currentValue = habit.dayCompletion[dataDateString(for: selectedDate)] {
                        habit.dayCompletion[dataDateString(for: selectedDate)] = !currentValue
                    } else {
                        habit.dayCompletion[dataDateString(for: selectedDate)] = true
                    }

                }
            })
            .gesture(
                DragGesture()
                    .onChanged { value in
                        withAnimation {
                            // Constrain dragOffset to the maxDragDistance
                            if value.translation.height < 0 {
                                dragOffset = max(value.translation.height, maxDragDistance)
                            }
                            // Check if the threshold is reached
                            if dragOffset <= maxDragDistance && !hasReachedMaxDistance {
                                hasReachedMaxDistance = true
                            } else if dragOffset > maxDragDistance {
                                hasReachedMaxDistance = false
                            }
                        }
                    }
                    .onEnded { value in
                        // Check if the drag reached the threshold
                        if dragOffset <= maxDragDistance {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                isDetailSheetPresented = true
                            }
                        }
                        // Reset dragOffset to 0
                        withAnimation {
                            dragOffset = 0
                            hasReachedMaxDistance = false
                        }
                    }
            )
            .sensoryFeedback(.impact, trigger: hasReachedMaxDistance)

            if habit.streak > 0 {
                ZStack {
                    Image(systemName: "flame.fill")
                        .resizable()
                        .frame(width: 25, height: 27.5)
                        .foregroundStyle(.red.opacity(1))

                    Image(systemName: "flame")
                        .resizable()
                        .frame(width: 25, height: 27.5)
                        .foregroundStyle(.red.opacity(1))

                    Text("\(habit.streak)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .offset(x: 0, y: 1)
                }
                .offset(x: 3, y: -3)
            }
        }
        .sheet(isPresented: $isDetailSheetPresented) {
            HabitDetailView(habit: habit)
                .presentationDetents(.init([.fraction(0.6)]))
                .presentationCornerRadius(32)
        }
    }
}


struct WeekCalendarView: View {
    @Binding var selectedDate: Date

    var body: some View {
        VStack(spacing: 15) {
            let calendar = Calendar.current
            let today = Date()
            let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedDate))!
            let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!

            ZStack(alignment: .bottomTrailing) {
                WeekView(startDate: startOfWeek, selectedDate: $selectedDate)
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                if value.translation.width < -50 { // Swipe left
                                    withAnimation {
                                        moveToNextWeek(today: today)
                                    }
                                } else if value.translation.width > 50 { // Swipe right
                                    withAnimation {
                                        moveToPreviousWeek()
                                    }
                                }
                            }
                    )
                
                if !(today > startOfWeek && today <= endOfWeek) {
                    Button(action: {
                        withAnimation {
                            selectedDate = today
                        }
                    }) {
                        HStack(spacing: 5) {
                            Text("Go to Today")
                            Image(systemName: "arrow.right.circle")
                        }
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)
                        .foregroundStyle(.white)
                        .offset(y: 12.5)
                    }
                }
            }
        }
        .padding(.top, 10)
    }

    func moveToNextWeek(today: Date) {
        let calendar = Calendar.current
        let sameWeekDay = calendar.date(byAdding: .day, value: 7, to: selectedDate)!
        let nextWeekStart = calendar.date(byAdding: .day, value: 7, to: calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedDate))!)!
        let nextWeekEnd = calendar.date(byAdding: .day, value: 6, to: nextWeekStart)!

        // Check if today's date is within the next week
        if today <= sameWeekDay {
            selectedDate = today // If today is within the next week, select today
        } else if today > nextWeekEnd || today > sameWeekDay {
            selectedDate = sameWeekDay
        }
        
    }

    func moveToPreviousWeek() {
        let calendar = Calendar.current
        selectedDate = calendar.date(byAdding: .day, value: -7, to: selectedDate)!
    }

    func formattedWeekDate(_ startOfWeek: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        let calendar = Calendar.current
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
        return "\(formatter.string(from: startOfWeek)) - \(formatter.string(from: endOfWeek))"
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
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Habit.self, configurations: config)

    return HomeView()
        .modelContainer(container)
}
