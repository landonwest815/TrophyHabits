//
//  SymbolPickerSheet.swift
//  trophyhabits
//
//  Created by Landon West on 1/4/25.
//

//
//  SymbolPickerSheet.swift
//  Graid
//
//  Created by Landon West on 6/3/24.
//

import SwiftUI
import SwiftData

struct IconPickerSheet: View {
    
    
    var habit: Habit
    
    var body: some View {
        NavigationStack {
            HabitSymbols(habit: habit)
        }
        .preferredColorScheme(.dark)
    }
    
    struct HabitSymbols: View {
        
        @Environment(\.dismiss) var dismiss

        var habit: Habit
        @State private var selectedSymbol: String
        @Environment(\.presentationMode) var presentationMode // To dismiss the view

        init(habit: Habit) {
            self.habit = habit
            self._selectedSymbol = State(initialValue: habit.icon)
        }
        
        private let habitCategories: [(name: String, symbols: [String])] = [
            ("General", ["circle", "checkmark", "star.fill", "list.bullet", "sparkles", "note.text", "pencil", "clock", "calendar", "folder", "trash.fill", "arrow.clockwise", "magnifyingglass", "chart.bar", "square.stack", "bubble.left", "briefcase", "tag"]),
            ("Health", ["heart.fill", "waveform.path.ecg", "pills", "drop.fill", "flame.fill", "leaf.fill", "bandage", "thermometer"]),
            ("Fitness", ["figure.walk", "figure.run", "bolt.fill", "speedometer", "flame.fill"]),
            ("Sleep", ["bed.double.fill", "moon.fill", "zzz", "clock.fill", "hourglass"]),
            ("Productivity", ["checkmark.circle.fill", "calendar.circle.fill", "pencil.circle.fill", "clock.badge.checkmark", "folder.fill", "briefcase.fill"]),
            ("Mindfulness", ["sparkles", "leaf.fill", "sunrise.fill", "sunset.fill", "waveform", "figure.mind.and.body"]),
            ("Learning", ["book.fill", "graduationcap.fill", "lightbulb.fill", "magnifyingglass", "pencil"]),
            ("Hygiene", ["drop.fill", "shower.fill", "hands.sparkles.fill"]),
            ("Financial", ["dollarsign.circle.fill", "chart.bar.fill", "creditcard.fill"]),
            ("Social", ["person.2.fill", "bubble.left.and.bubble.right.fill", "hand.thumbsup.fill", "heart.fill"]),
            ("Creative", ["paintbrush.fill", "scissors", "camera.fill", "film", "music.note"]),
            ("Home", ["house.fill", "wrench.fill", "gearshape.fill", "trash.fill", "checklist"]),
            ("Sustainability", ["leaf.fill", "arrow.3.trianglepath", "bolt.fill", "drop.fill"]),
            ("Travel", ["airplane", "car.fill", "bicycle.circle.fill", "map.fill", "suitcase.fill"])
        ]


        
        var body: some View {
            ScrollView {
                VStack(spacing: 35) {
                    ForEach(habitCategories, id: \.name) { subject in
                        VStack(alignment: .leading, spacing: 20) {
                            Text(subject.name)
                                .padding(.leading, 25)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                            
                            LazyVGrid(columns: gridColumns(), spacing: 20) {
                                ForEach(subject.symbols, id: \.self) { symbol in
                                    Button(action: {
                                        withAnimation {
                                            selectedSymbol = symbol
                                            habit.icon = symbol
                                            dismiss()
                                        }
                                    }) {
                                        Image(systemName: symbol)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .padding()
                                            .frame(width: 50, height: 50)
                                            .background(selectedSymbol == symbol ? .white.opacity(0.9) : Color(red: 0.2, green: 0.2, blue: 0.2))
                                            .foregroundColor(selectedSymbol == symbol ? .black : .white)
                                            .cornerRadius(18)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
//            .navigationBarTitle("Course Icons", displayMode: .inline)
//            .navigationBarItems(trailing: Button(action: {
//                presentationMode.wrappedValue.dismiss()
//            }) {
//                Image(systemName: "xmark")
//                    .resizable()
//                    .frame(width: 12, height: 12)
//                    .foregroundColor(.gray)
//                    .padding(8)
//                    .background(Color(UIColor.systemGray6))
//                    .clipShape(Circle())
//            })
        }
        
        private func gridColumns() -> [GridItem] {
            [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Habit.self, configurations: config)
    let habit = Habit(icon: "pencil", habit: "Write Notes")
    
    IconPickerSheet(habit: habit)
        .modelContainer(container)
}
