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
        VStack(spacing: 20) {
            
            HStack {
                Button {
                    
                } label: {
                    ZStack {
                        VStack(spacing: 15) {
                            Image(systemName: "\(icon)")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(width: 25, height: 25)
                    .padding()
                    .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                    .cornerRadius(20)
                }
                
                Spacer()
                
                ZStack {
                    VStack(spacing: 15) {
                        Text("\(habit)")
                            .font(.title2)
                            .fontDesign(.rounded)
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 25)
                .padding()
                .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                .cornerRadius(20)
                
                Spacer()
                
                Button {
                    
                } label: {
                    ZStack {
                        VStack(spacing: 15) {
                            Image(systemName: "trash")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(width: 25, height: 25)
                    .padding()
                    .background(.red)
                    .cornerRadius(20)
                }
            }
            
            HStack {
                
                
                
            }
            
            Spacer()
        }
        .padding()
        .preferredColorScheme(.dark)
    }
}

#Preview {
    HabitDetailView(habit: "SwiftUI", icon: "pencil", streak: 4, completed: true)
}
