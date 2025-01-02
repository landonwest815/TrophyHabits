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
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15),
    ]

    @State private var selectedDate: Date = Date()
    @State private var medalUpgrade = false
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
                    .onChange(of: trueCount) { oldValue, newValue in
                        if newValue > oldValue && newValue % 2 == 0 {
                            medalUpgrade.toggle()
                            showConfetti += 1
                        }
                    }

                Spacer()

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
                .padding(25)
                .padding(.bottom, 10)
                .frame(maxWidth: .infinity, maxHeight: 375)
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
                        }
                        .font(.title3)
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
            .confettiCannon(counter: $showConfetti, num: 25, colors: [.yellow, .gray], confettiSize: 10, radius: 300)
        }
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
                .frame(width: 105, height: 145)
                .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                .cornerRadius(20)
            }
        }
    }
}

struct HabitView: View {
    var habit: Habit
    var selectedDate: Date

    @State private var isDetailSheetPresented = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button {
                // Action handled by gestures
            } label: {
                ZStack {
                    VStack(spacing: 15) {
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
                }
                .frame(width: 105, height: 145)
                .background(habit.dayCompletion[dataDateString(for: selectedDate)] ?? false ? .clear : Color(red: 0.2, green: 0.2, blue: 0.2))
                .cornerRadius(20)
            }
            .simultaneousGesture(LongPressGesture().onEnded { _ in
                isDetailSheetPresented.toggle()
            })
            .simultaneousGesture(TapGesture().onEnded {
                withAnimation(.bouncy) {
                    habit.dayCompletion[dataDateString(for: selectedDate)]?.toggle()
                }
            })

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
            let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
            WeekView(startDate: startOfWeek, selectedDate: $selectedDate)
        }
        .padding(.top, 10)
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
