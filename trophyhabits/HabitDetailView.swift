//
//  HabitDetailView.swift
//  trophyhabits
//
//  Created by Landon West on 12/18/24.
//
import SwiftUI

struct HabitDetailView: View {
    var habit: String
    var icon: String
    var streak: Int
    var completed: Bool

    var body: some View {
        VStack(spacing: 50) {
            
            HStack {
                
                VStack(spacing: 40) {
                    ZStack {
                        
                        VStack(spacing: 15) {
                            
                            Button {
                                
                            } label: {
                                Image(systemName: icon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 75, height: 75)
                                    .foregroundStyle(.white)
                            }
                            
                            
                            Button {
                                
                            } label: {
                                Text(habit)
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
                    
                    HStack(spacing: 15) {
                        Button {
                            
                        } label: {
                            ZStack {
                                VStack(spacing: 15) {
                                    Image(systemName: "archivebox.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                        .foregroundStyle(.white)
                                }
                            }
                            .frame(width: 30, height: 30)
                            .padding()
                            .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                            .cornerRadius(20)
                        }
                        
                        Button {
                            
                        } label: {
                            ZStack {
                                VStack(spacing: 15) {
                                    Image(systemName: "trash")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                        .foregroundStyle(.white)
                                }
                            }
                            .frame(width: 30, height: 30)
                            .padding()
                            .background(.red)
                            .cornerRadius(20)
                        }
                    }
                    
                }
            
                Spacer()
                
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
                
                Spacer()
            }
            .padding()
            
            Spacer()
        }
        .padding()
        .preferredColorScheme(.dark)
    }
}

#Preview {
    HabitDetailView(habit: "10,000 Steps", icon: "figure.walk", streak: 4, completed: true)
}
