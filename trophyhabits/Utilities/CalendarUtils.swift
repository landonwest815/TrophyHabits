import SwiftUI

struct DayView: View {
    var date: Date
    @Binding var selectedDate: Date // Bind to the selected day in WeekView
    @State var medalColor: Color = .yellow

    var body: some View {
        VStack(spacing: 7.5){
            ZStack(alignment: .topTrailing) {
                VStack {
                    // Day of the week
                    Text(dateToDayLetter())
                        .font(.subheadline)
                    
                    // Date number
                    Text(String(dayNumber()))
                        .font(.headline)
                }
                .fontDesign(.rounded)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(width: 24, height: 35)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isPastDay() ? randomDayColor() : Color(red: 0.2, green: 0.2, blue: 0.2))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelectedDay() ? Color.white : Color.clear, lineWidth: 2.5)
                )
                .onTapGesture {
                    withAnimation {
                        selectedDate = date // Update selected date
                    }
                }
                
                // Medal icon in the top-right corner
                //            if isPastDay() {
                //                Image(systemName: "medal.star.fill")
                //                    .resizable()
                //                    .aspectRatio(contentMode: .fit)
                //                    .frame(width: 15)
                //                    .foregroundStyle(medalColor)
                //            }
            }
            
            Circle()
                .foregroundStyle(isCurrentDay(date: date) ? .white : .clear)
                .frame(width: 5)
        }
        .onAppear {
            medalColor = randomMedalColor()
        }
        .preferredColorScheme(.dark)
    }

    func isPastDay() -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        let thisDay = Calendar.current.startOfDay(for: date)
        return thisDay < today
    }

    func isSelectedDay() -> Bool {
        Calendar.current.isDate(selectedDate, inSameDayAs: date)
    }
    
    func isCurrentDay(date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }

    func dayNumber() -> Int {
        Calendar.current.component(.day, from: date)
    }

    func dateToDayLetter() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return String(formatter.string(from: date).prefix(1))
    }
}

struct WeekView: View {
    var startDate: Date
    @Binding var selectedDate: Date

    var body: some View {
        HStack(spacing: 10) {
            ForEach(generateWeekDays(for: startDate), id: \.self) { date in
                DayView(date: date, selectedDate: $selectedDate)
            }
        }
        .onAppear {
            selectedDate = Date() // Set default to today's date
        }
        .sensoryFeedback(.increase, trigger: selectedDate)
    }

    func generateWeekDays(for date: Date) -> [Date] {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }
}

func currentDateString() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE, MMM d"
    return formatter.string(from: Date())
}

func dateString(for date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE, MMM d"
    return formatter.string(from: date)
}


func randomDayColor() -> Color {
    let colors: [Color] = [.yellow.opacity(0.66), .brown.opacity(0.66), .gray.opacity(0.66), Color(red: 0.2, green: 0.2, blue: 0.2)]
    return colors.randomElement() ?? .yellow
}

#Preview {
    @Previewable @State var selectedDate: Date = Date()
    WeekView(startDate: Date.now, selectedDate: $selectedDate)
}
