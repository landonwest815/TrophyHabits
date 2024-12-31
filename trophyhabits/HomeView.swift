//
//  HomeView.swift
//  trophyhabits
//
//  Created by Landon West on 12/17/24.
//

import SwiftUI

struct HomeView: View {
    
    @State var completed1: Bool = false
    @State var completed2: Bool = false
    @State var completed3: Bool = false
    @State var completed4: Bool = false
    @State var completed5: Bool = false
    @State var completed6: Bool = false
    
    @State private var medalUpgrade = false
    @State private var medalDowngrade = false
    
    @State private var isTrophyRoomPresented = false
    @State private var isCalendarPresented = false
    
    var trueCount: Int {
        [completed1, completed2, completed3, completed4, completed5, completed6].filter { $0 }.count
    }
    
    var progress: Double {
        Double(trueCount) / 6.0
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                VStack(spacing: 15) {
                    VStack {
                        let calendar = Calendar.current
                        let today = Date()
                        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
                        
                        // Use the new WeekView
                        WeekView(startDate: startOfWeek, shownMonth: Date.now)
                    }
                    
                }
                .padding(.top, 10)
                
                Spacer()
                       
                ProgressView(progress: progress, medalUpgrade: $medalUpgrade, trueCount: trueCount)
                    .padding(.top, 15)
                    .onChange(of: trueCount) { oldValue, newValue in
                        if newValue > oldValue && (newValue == 2 || newValue == 4 || newValue == 6) {
                            print("test")
                            medalUpgrade.toggle()
                        }
                    }

                
                Spacer()
                
                ZStack(alignment: .bottom) {

                    VStack(spacing: 15) {
                            
                        HStack(spacing: 15) {
                            HabitView(icon: "pencil.and.scribble", habit: "Review Notes", completed: $completed1, streak: 2)
                            HabitView(icon: "apple.terminal", habit: "Leetcode Problem", completed: $completed2, streak: 3)
                            HabitView(icon: "carrot.fill", habit: "Snack Less", completed: $completed3, streak: 0)
                        }
                        
                        HStack(spacing: 15) {
                            HabitView(icon: "figure.walk.motion", habit: "10,000 Steps", completed: $completed4, streak: 0)
                            HabitView(icon: "bolt.fill", habit: "Charge Devices", completed: $completed5, streak: 0)
                            HabitView(icon: "bed.double.fill", habit: "8 Hours of Sleep", completed: $completed6, streak: 0)
                        }
                                
//                            HStack(spacing: 5) {
//                                Image(systemName: "info.circle")
//                                Text("Tap and Hold for Habit Details")
//                            }
//                            .font(.footnote)
//                            .fontWeight(.regular)
//                            .fontDesign(.rounded)
//                            .foregroundStyle(.gray)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: 375)
                    .padding(.top, 24)
                    .transition(.move(edge: .bottom))
                    .background(.ultraThinMaterial)
                    .cornerRadius(32)
                    
                }
                .ignoresSafeArea()
                .frame(maxWidth: .infinity, maxHeight: 375, alignment: .bottom)
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Left-aligned Settings button
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        // something
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(.gray)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Button {
                        isCalendarPresented.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "calendar")
                                .font(.subheadline)
                            Text(currentDateString())
                                .font(.title3)
                        }
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)
                        .foregroundStyle(.white)
                    }
                }
                
                // Right-aligned Trophy Room Stats button
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isTrophyRoomPresented.toggle()
                    } label: {
//                        ZStack {
//                            Image(systemName: "trophy.fill")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(height: 15)
//                                .foregroundStyle(.brown)
//                                .rotationEffect(.degrees(15))
//                                .offset(x: 8, y: 2.5)
//                                
//                            Image(systemName: "trophy.fill")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(height: 15)
//                                .foregroundStyle(.gray)
//                                .rotationEffect(.degrees(-15))
//                                .offset(x: -8, y: 2.5)
//                            
//                            Image(systemName: "trophy.fill")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(height: 25)
//                                .foregroundStyle(.yellow)
//                        }
//                        .fontWeight(.semibold)
//                        .fontDesign(.rounded)
                        Image(systemName: "trophy.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 25)
                            .foregroundStyle(.yellow)
                    }
                }
            }

        }
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        .sheet(isPresented: $isTrophyRoomPresented) {
            TrophyAndMedalStatsView(
                goldTrophies: 5,
                silverTrophies: 3,
                bronzeTrophies: 7,
                goldMedals: 12,
                silverMedals: 8,
                bronzeMedals: 15
            )
            .presentationDetents([.fraction(0.7)])
            .presentationCornerRadius(32)
        }
        .sheet(isPresented: $isCalendarPresented) {
            CalendarSheet()
            .presentationDetents([.fraction(0.85)])
            .presentationCornerRadius(32)
        }

    }
    
    func currentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d" // Format: Full weekday, short month, and day
        return formatter.string(from: Date()) // Current date
    }
}


struct DayView: View {
    var date: Date // Actual date
    @State private var medalColor: Color = .yellow // Default color
    var shownMonth: Date

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                Text(dateToDayLetter())
                    .font(.subheadline)
                    .fontDesign(.rounded)
                    .fontWeight(.semibold)
                    .foregroundStyle(isCurrentDay() ? .black : (isShownMonth() ? .white : .gray))
                
                Text(String(dayNumber()))
                    .font(.headline)
                    .fontDesign(.rounded)
                    .fontWeight(.semibold)
                    .foregroundStyle(isCurrentDay() ? .black : (isShownMonth() ? .white : .gray))
            }
            .frame(width: 24, height: 35)
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isCurrentDay() ? Color(red: 1, green: 1, blue: 1) : (isShownMonth() ? Color(red: 0.2, green: 0.2, blue: 0.2) : Color.clear))
            )
            
            // Medal icon in the top-right corner
            if isShownMonth() && isPastDay() {
                Image(systemName: "medal.star.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 15)
                    .foregroundStyle(medalColor)
                    .padding(0)
            }
        }
        .onAppear {
            medalColor = randomMedalColor()
        }
    }
    
    // Helper Functions
    func isPastDay() -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        let thisDay = Calendar.current.startOfDay(for: date)
        return thisDay < today
    }

    func isCurrentDay() -> Bool {
        Calendar.current.isDateInToday(date)
    }
    
    func isShownMonth() -> Bool {
        let calendar = Calendar.current
        let today = Date()
        return calendar.isDate(date, equalTo: shownMonth, toGranularity: .month)
    }
    
    func dayNumber() -> Int {
        Calendar.current.component(.day, from: date)
    }
    
    func dateToDayLetter() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E" // Short day format (e.g., "M", "T")
        return String(formatter.string(from: date).prefix(1))
    }
    
    func randomMedalColor() -> Color {
        let colors: [Color] = [.yellow, .brown, .gray, .clear]
        return colors.randomElement() ?? .yellow
    }
}

func randomTrophyColor() -> Color {
    let colors: [Color] = [.yellow, .brown, .gray, .gray.opacity(0.15)]
    return colors.randomElement() ?? .yellow
}



struct WeekView: View {
    var startDate: Date // The first day of the week
    var shownMonth: Date

    var body: some View {
        HStack(spacing: 10) {
            ForEach(generateWeekDays(for: startDate), id: \.self) { date in
                DayView(date: date, shownMonth: shownMonth)
            }
        }
    }

    func generateWeekDays(for date: Date) -> [Date] {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }
}


struct MonthlyView: View {
    var shownMonth: Date // The first day of the current month

    var body: some View {
        VStack(spacing: 10) {
            ForEach(generateWeeks(for: shownMonth), id: \.self) { weekStartDate in
                WeekView(startDate: weekStartDate, shownMonth: shownMonth)
            }
        }
    }

    func generateWeeks(for month: Date) -> [Date] {
        let calendar = Calendar.current
        guard let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: month)),
              let monthRange = calendar.range(of: .weekOfMonth, in: .month, for: month) else {
            return []
        }

        return monthRange.compactMap {
            calendar.date(byAdding: .weekOfMonth, value: $0 - 1, to: firstDayOfMonth)
        }
    }
}

// Helper Day Model
struct Day: Hashable {
    let day: Int
    let dayLetter: String
    let isCurrentMonth: Bool
}

struct HabitView: View {
    
    var icon: String
    var habit: String
    @Binding var completed: Bool
    var streak: Int // Pass the streak count as a parameter
    
    @State private var isDetailSheetPresented = false // State to track sheet presentation
    
    var body: some View {
        ZStack(alignment: .topTrailing) { // Align content to top-right
            
            // Main Habit Button
            Button {
               
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
                print("Secret Long Press Action!")
                isDetailSheetPresented = true // Present the detail sheet
                
            })
            .simultaneousGesture(TapGesture().onEnded {
                print("Boring regular tap")
                withAnimation(.bouncy) {
                    completed.toggle()
                }
            })
            .sensoryFeedback(.increase, trigger: isDetailSheetPresented)
            
            // Flame Icon with Streak Number
            if streak > 0 { // Only show the flame if there's a streak
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


#Preview {
    HomeView()
}
