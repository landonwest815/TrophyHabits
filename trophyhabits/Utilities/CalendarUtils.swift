import SwiftUI
import SwiftData

struct DayView: View {
    @Query(sort: \Habit.habit) private var habits: [Habit]
    var date: Date
    @Binding var selectedDate: Date // Bind to the selected day in WeekView
    @State var medalColor: Color = .clear

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
                        .fill(
                            isFutureDay() ? Color(red: 0.1, green: 0.1, blue: 0.1) :
                            Color(red: 0.2, green: 0.2, blue: 0.2)
                        )
                )
                .onTapGesture {
                    withAnimation {
                        if !isFutureDay() {
                            withAnimation {
                                selectedDate = date
                                calculateMedalColor()
                            }
                        }
                    }
                }
                
                 // Medal icon in the top-right corner
                if !isFutureDay() {
                    Image(systemName: "medal.star.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 13)
                        .foregroundStyle(medalColor)
                        .shadow(radius: 2.5)
                        .padding(.trailing, 2.5)
                        .padding(.top, 1.5)
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelectedDay() ? Color.white : Color.clear, lineWidth: 2.5)
            )
            
            Circle()
                .foregroundStyle(isCurrentDay(date: date) ? .white : .clear)
                .frame(width: 6.66)
        }
        .onAppear {
            calculateMedalColor()
        }
        .onChange(of: habits.filter { $0.dayCompletion[dataDateString(for: date)] == true }.count) {
            calculateMedalColor()
        }
        .onChange(of: habits.count) {
            calculateMedalColor()
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
    
    func isFutureDay() -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        let thisDay = Calendar.current.startOfDay(for: date)
        return thisDay > today
    }

    func dayNumber() -> Int {
        Calendar.current.component(.day, from: date)
    }

    func dateToDayLetter() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return String(formatter.string(from: date).prefix(1))
    }
    
    func calculateMedalColor() {
        let dateKey = dataDateString(for: date)
        
        let completedHabits = habits.filter { $0.dayCompletion[dateKey] == true }
        let completionPercentage = Double(completedHabits.count) / Double(habits.count)

        withAnimation {
            switch completionPercentage {
            case 1.0:
                medalColor = .yellow
            case 0.66...0.99:
                medalColor = .gray
            case 0.33...0.65:
                medalColor = .brown
            default:
                medalColor = .clear
            }
        }
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

extension Date {
    var endOfDay: Date {
        Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: self)!
    }
}


#Preview {
    @Previewable @State var selectedDate: Date = Date()
    WeekView(startDate: Date.now, selectedDate: $selectedDate)
}
