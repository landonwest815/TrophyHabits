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
    
    var habit: Habit

    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 30) {
                                
                VStack(spacing: 20) {
                    
                    // habit card
                    ZStack {
                        
                        VStack(spacing: 15) {
                            Button {
                                // change icon
                            } label: {
                                Image(systemName: habit.icon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 75, height: 75)
                                    .foregroundStyle(.white)
                            }

                            Button {
                                // change habit
                            } label: {
                                Text(habit.habit)
                                    .font(.title2)
                                    .fontDesign(.rounded)
                                    .fontWeight(.semibold)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 112.5, height: 75)
                                    .foregroundStyle(.white)
                            }
                        }
                        
                    }
                    .padding()
                    .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                    .cornerRadius(20)

                    
                    // habit archival/deletion
                    HStack(spacing: 15) {
                        Button {
                            // archive the habit
                        } label: {
                            ZStack {
                                Image(systemName: "archivebox.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(.white)
                            }
                            .frame(width: 30, height: 30)
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
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(.white)
                            }
                            .frame(width: 30, height: 30)
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
