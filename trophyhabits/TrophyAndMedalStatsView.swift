//
//  TrophyAndMedalStatsView.swift
//  trophyhabits
//
//  Created by Landon West on 12/18/24.
//
import SwiftUI

struct TrophyAndMedalStatsView: View {
    var goldTrophies: Int
    var silverTrophies: Int
    var bronzeTrophies: Int
    var goldMedals: Int
    var silverMedals: Int
    var bronzeMedals: Int

    var body: some View {
        VStack(spacing: 25) {
            
            VStack {
                HStack {
                    
                    Text("Weekly Trophies")
                        .font(.title3)
                        .fontDesign(.rounded)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                }
                
                // Trophies Row
                HStack(spacing: 12.5) {
                    TrophyView(icon: "trophy.fill", color: .yellow, count: goldTrophies)
                    TrophyView(icon: "trophy.fill", color: .gray, count: silverTrophies)
                    TrophyView(icon: "trophy.fill", color: .brown, count: bronzeTrophies)
                }
            }
            
            VStack {
                HStack {
                    
                    Text("Daily Medals")
                        .font(.title3)
                        .fontDesign(.rounded)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                }
                
                // Medals Row
                HStack(spacing: 12.5) {
                    TrophyView(icon: "medal.star.fill", color: .yellow, count: goldMedals)
                    TrophyView(icon: "medal.star.fill", color: .gray, count: silverMedals)
                    TrophyView(icon: "medal.star.fill", color: .brown, count: bronzeMedals)
                }
            }
            
            Spacer()
            
            HStack(spacing: 15) {
                
                Spacer()
                
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "trophy.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 20)
                            .foregroundStyle(.yellow)
                        
                        Text("30 Weekly Points")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                            .foregroundStyle(.gray)
                        
                    }
                    
                    HStack {
                        Image(systemName: "trophy.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 20)
                            .foregroundStyle(.gray)
                        
                        Text("20 Weekly Points")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                            .foregroundStyle(.gray)
                        
                    }
                    
                    HStack {
                        Image(systemName: "trophy.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 20)
                            .foregroundStyle(.brown)
                        
                        Text("10 Weekly Points")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                            .foregroundStyle(.gray)
                        
                    }
                }
                
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "medal.star.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 20)
                            .foregroundStyle(.yellow)
                        
                        Text("100% of Habits")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                            .foregroundStyle(.gray)
                        
                    }
                    
                    HStack {
                        Image(systemName: "medal.star.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 20)
                            .foregroundStyle(.gray)
                        
                        Text("60% of Habits")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                            .foregroundStyle(.gray)
                        
                    }
                    
                    HStack {
                        Image(systemName: "medal.star.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 20)
                            .foregroundStyle(.brown)
                        
                        Text("30% of Habits")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                            .foregroundStyle(.gray)
                        
                    }
                }
                
                Spacer()
            }
                
        }
        .padding()
        .padding(.horizontal)
        .preferredColorScheme(.dark)
    }
}

struct TrophyView: View {
    var icon: String
    var color: Color
    var count: Int

    var body: some View {
        VStack {
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundStyle(color)
            
            HStack(spacing: 1) {
                Text("\(count)")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                
                Text("x")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                    .foregroundStyle(.gray)
            }
            
        }
        .frame(width: 75)
        .padding()
        .background(Color(red: 0.2, green: 0.2, blue: 0.2))
        .cornerRadius(20)
    }
}

#Preview {
    TrophyAndMedalStatsView(
        goldTrophies: 5,
        silverTrophies: 8,
        bronzeTrophies: 12,
        goldMedals: 15,
        silverMedals: 20,
        bronzeMedals: 25
    )
}
