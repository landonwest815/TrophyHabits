
import SwiftUI

struct CalendarSheet: View {
    @State private var displayedMonth: Date = Date() // Tracks the displayed month

    var body: some View {
        NavigationView {
            VStack {
                // Month Navigation Controls
                HStack {
                    Button(action: {
                        withAnimation {
                            displayedMonth = stepMonth(by: -1)
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundStyle(.gray)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "calendar")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                        
                        Text(monthYearString(for: displayedMonth))
                            .font(.title3)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            displayedMonth = stepMonth(by: 1)
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.title3)
                            .foregroundStyle(.gray)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 10)

                // Monthly View
                MonthlySheetView(shownMonth: displayedMonth)
                    .padding(.top, 10)
                
                if !isCurrentMonth(displayedMonth) {
                    Button {
                        withAnimation {
                            displayedMonth = Date()
                        }
                    } label: {
                        Text("Go to Today")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                            .foregroundStyle(.white)
                    }
                    .padding(.top)
                }
                
                Spacer()
            }
            .padding()
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Helper Functions
    func stepMonth(by value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: value, to: displayedMonth) ?? displayedMonth
    }
    
    func monthYearString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy" // Full month and year
        return formatter.string(from: date)
    }
    
    func isCurrentMonth(_ date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date, equalTo: Date(), toGranularity: .month) &&
               calendar.isDate(date, equalTo: Date(), toGranularity: .year)
    }

}

struct DaySheetView: View {
    var date: Date // Actual date
    @State private var medalColor: Color = .yellow // Default color
    var shownMonth: Date

    var body: some View {
        VStack {
            ZStack {
                
                Text(String(dayNumber()))
                    .font(.footnote)
                    .fontDesign(.rounded)
                    .fontWeight(.semibold)
                    .foregroundStyle(isCurrentDay() ? .black : .white)
            }
            .frame(width: 18, height: 18)
            .padding(8.5)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isCurrentDay() ? Color(red: 1, green: 1, blue: 1) : (isPastDay() ? randomMedalColor().opacity(0.66) : Color.clear))
            )
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

struct WeekSheetView: View {
    var startDate: Date // The first day of the week
    var shownMonth: Date

    var body: some View {
        HStack(spacing: 7.5) {
            ForEach(generateWeekDays(for: startDate), id: \.self) { date in
                DaySheetView(date: date, shownMonth: shownMonth)
            }
            
            Spacer()
            
            Image(systemName: "trophy.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
                .foregroundStyle(randomTrophyColor())
            
            Spacer()
        }
    }

    func generateWeekDays(for date: Date) -> [Date] {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }
}


struct MonthlySheetView: View {
    var shownMonth: Date // The first day of the current month

    var body: some View {
        HStack {
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 7.5) {
                
                HStack(spacing: 7.5) {
                    ForEach(Array("SMTWTFS"), id: \.self) { day in
                        VStack {
                            Text(String(day))
                                .foregroundColor(.white)
                                .font(.subheadline)
                                .fontDesign(.rounded)
                                .fontWeight(.semibold)
                        }
                        .frame(width: 18, height: 18)
                        .padding(.horizontal, 8.5)
                        .padding(.bottom, 5)
                        
                    }
                }
                
                ForEach(generateWeeks(for: shownMonth), id: \.self) { weekStartDate in
                    WeekSheetView(startDate: weekStartDate, shownMonth: shownMonth)
                }
                
                VStack(spacing: 10) {
                    HStack(spacing: 10) {
                                                
                        HStack(spacing: 10) {
                            Image(systemName: "medal.star.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 30)
                                .foregroundStyle(.yellow)
                            
                            Text("x4")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .fontDesign(.rounded)
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: 30)
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(red: 0.2, green: 0.2, blue: 0.2))
                        )
                        
                        HStack(spacing: 10) {
                            Image(systemName: "medal.star.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 30)
                                .foregroundStyle(.gray)
                            
                            Text("x9")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .fontDesign(.rounded)
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: 30)
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(red: 0.2, green: 0.2, blue: 0.2))
                        )
                        
                        HStack(spacing: 10) {
                            Image(systemName: "medal.star.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 30)
                                .foregroundStyle(.brown)
                            
                            Text("x13")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .fontDesign(.rounded)
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: 30)
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(red: 0.2, green: 0.2, blue: 0.2))
                        )
                                                
                    }
                    
                    
//                    HStack(spacing: 10) {
//                        
//                        
//                        HStack(spacing: 10) {
//                            Image(systemName: "trophy.fill")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(height: 25)
//                                .foregroundStyle(.yellow)
//                            
//                            Text("x2")
//                                .font(.headline)
//                                .fontWeight(.semibold)
//                                .fontDesign(.rounded)
//                            
//                        }
//                        .frame(maxWidth: .infinity, maxHeight: 30)
//                        .padding(10)
//                        .background(
//                            RoundedRectangle(cornerRadius: 12)
//                                .fill(Color(red: 0.2, green: 0.2, blue: 0.2))
//                        )
//                        
//                        HStack(spacing: 10) {
//                            Image(systemName: "trophy.fill")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(height: 25)
//                                .foregroundStyle(.gray)
//                            
//                            Text("x1")
//                                .font(.headline)
//                                .fontWeight(.semibold)
//                                .fontDesign(.rounded)
//                            
//                        }
//                        .frame(maxWidth: .infinity, maxHeight: 30)
//                        .padding(10)
//                        .background(
//                            RoundedRectangle(cornerRadius: 12)
//                                .fill(Color(red: 0.2, green: 0.2, blue: 0.2))
//                        )
//                        
//                        HStack(spacing: 10) {
//                            Image(systemName: "trophy.fill")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(height: 25)
//                                .foregroundStyle(.brown)
//                            
//                            Text("x2")
//                                .font(.headline)
//                                .fontWeight(.semibold)
//                                .fontDesign(.rounded)
//                            
//                        }
//                        .frame(maxWidth: .infinity, maxHeight: 30)
//                        .padding(10)
//                        .background(
//                            RoundedRectangle(cornerRadius: 12)
//                                .fill(Color(red: 0.2, green: 0.2, blue: 0.2))
//                        )
//                        
//                        
//                    }
                }
                .padding(.top, 25)
            }
            
            Spacer()
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

#Preview {
    CalendarSheet()
}

