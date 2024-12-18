
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
                MonthlyView(shownMonth: displayedMonth)
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
                            .foregroundStyle(.gray)
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

#Preview {
    CalendarSheet()
}

