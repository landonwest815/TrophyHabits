//
//  HabitDetailView.swift
//  trophyhabits
//
//  Created by Landon West on 12/18/24.
//

import SwiftUI
import SwiftData

struct HabitDetailView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var isEditingName = false
    @State private var tempHabitName = ""
    
    var habit: Habit

    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 30) {
                                
                VStack(spacing: 20) {
                    
                    // habit card
                    ZStack {
                        
                        VStack(spacing: 15) {
                            Menu {
                                // Provide a list of available icons for the user to choose from
                                ForEach(["star.fill", "heart.fill", "flame.fill", "leaf.fill", "bolt.fill"], id: \.self) { iconName in
                                    Button {
                                        // Change the icon to the selected one
                                        habit.icon = iconName
                                    } label: {
                                        HStack {
                                            Image(systemName: iconName)
                                            Text(iconName.capitalized) // Optional: Add a label for each icon
                                        }
                                    }
                                }
                            } label: {
                                Image(systemName: habit.icon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 75, height: 75)
                                    .foregroundStyle(.white)
                            }

                               
                            TextField("Enter habit name", text: $tempHabitName, axis: .vertical)
                                .lineLimit(2, reservesSpace: true)
                                .font(.title2)
                                .fontDesign(.rounded)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .frame(width: 112.5, height: 75)
                                .foregroundStyle(.white)
                                .onAppear {
                                    tempHabitName = habit.habit // Pre-fill with the current name
                                }
                                .submitLabel(.done)
                                .onChange(of: tempHabitName) { newValue in
                                    guard let newValueLastChar = newValue.last else { return }
                                    if newValueLastChar == "\n" {
                                        
                                        tempHabitName.removeLast()
                                        print("submission!")
                                        habit.habit = tempHabitName
                                        
                                        do {
                                            try modelContext.save()
                                        } catch {
                                            print("Error saving habit: \(error)")
                                        }
                                        
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                    }
                                }
                            
                        }
                        
                    }
                    .frame(width: 160, height: 215)
                    .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                    .cornerRadius(32)

                    
                    // habit archival/deletion
                    HStack(spacing: 15) {
                        Button {
                            // archive the habit
                        } label: {
                            ZStack {
                                Image(systemName: "archivebox.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                                    .foregroundStyle(.white)
                            }
                            .frame(width: 25, height: 25)
                            .padding()
                            .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                            .cornerRadius(20)
                        }

                        Button {
                            withAnimation {
                                // Dismiss the sheet first
                                dismiss()
                                
                                // Perform deletion and save after a delay
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    modelContext.delete(habit) // Delete the habit
                                    
                                    do {
                                        try modelContext.save() // Save after deletion
                                    } catch {
                                        print("Failed to save after deleting habit: \(error)")
                                    }
                                }
                            }
                        } label: {
                            ZStack {
                                Image(systemName: "trash")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                                    .foregroundStyle(.white)
                            }
                            .frame(width: 25, height: 25)
                            .padding()
                            .background(.red)
                            .cornerRadius(20)
                        }
                    }
                    
                }
                
                // stats
                VStack(alignment: .leading, spacing: 15) {
                    VStack(alignment: .leading) {
                        Text("Completed")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                            .foregroundStyle(.secondary)
                        Text("30 times")
                            .font(.title2)
                            .fontDesign(.rounded)
                            .fontWeight(.semibold)
                    }

                    VStack(alignment: .leading) {
                        Text("Completion %")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                            .foregroundStyle(.secondary)
                        Text("57 %")
                            .font(.title2)
                            .fontDesign(.rounded)
                            .fontWeight(.semibold)
                    }

                    VStack(alignment: .leading) {
                        Text("Current Streak")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                            .foregroundStyle(.secondary)
                        Text("2 days")
                            .font(.title2)
                            .fontDesign(.rounded)
                            .fontWeight(.semibold)
                    }

                    VStack(alignment: .leading) {
                        Text("Longest Streak")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                            .foregroundStyle(.secondary)
                        Text("6 days")
                            .font(.title2)
                            .fontDesign(.rounded)
                            .fontWeight(.semibold)
                    }

                    VStack(alignment: .leading) {
                        Text("Created")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                            .foregroundStyle(.secondary)
                        Text("08/15/03")
                            .font(.title2)
                            .fontDesign(.rounded)
                            .fontWeight(.semibold)
                    }
                }

            }
            .padding()

            Spacer()
        }
        .padding()
        .preferredColorScheme(.dark)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Habit.self, configurations: config)
    let habit = Habit(icon: "pencil", habit: "Write Notes")
    
    HabitDetailView(habit: habit)
        .modelContainer(container)
}
