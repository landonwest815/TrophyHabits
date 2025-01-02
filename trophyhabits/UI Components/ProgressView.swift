//
//  ProgressView.swift
//  trophyhabits
//
//  Created by Landon West on 12/23/24.
//


import SwiftUI

struct ProgressView: View {
    var progress: Double
    @Binding var medalUpgrade: Bool
    var trueCount: Int

    var body: some View {
                
        // Daily Progress View
        VStack(spacing: 20) {
            
            ZStack(alignment: .bottom) {
                ZStack {
                    
                    // gray underlying circle
                    Circle()
                        .trim(from: 0.0, to: 0.8)
                        .stroke(
                            Color.gray,
                            style: StrokeStyle(lineWidth: 10, lineCap: .round)
                        )
                        .opacity(0.2)
                        .foregroundColor(.gray)
                        .rotationEffect(.degrees(126.33)) // Rotate to start from bottom left
                    
                    // bronze progress
                    Circle()
                        .trim(from: 0.0, to: min(0.25, CGFloat(progress * 0.8)))
                        .stroke(
                            .brown,
                            style: StrokeStyle(lineWidth: 10, lineCap: .round)
                        )
                        .rotationEffect(.degrees(126.33)) // Rotate to start from bottom left
                        .animation(.easeInOut, value: progress)
                    
                    // silver progress
                    Circle()
                        .trim(from: 0.25, to: min(0.525, CGFloat(progress * 0.8)))
                        .stroke(
                            .gray,
                            style: StrokeStyle(lineWidth: 10, lineCap: .round)
                        )
                        .rotationEffect(.degrees(126.33)) // Rotate to start from bottom left
                        .animation(.easeInOut, value: progress)
                    
                    // gold progress
                    Circle()
                        .trim(from: 0.525, to: CGFloat(progress * 0.8))
                        .stroke(
                            .yellow,
                            style: StrokeStyle(lineWidth: 10, lineCap: .round)
                        )
                        .rotationEffect(.degrees(126.33)) // Rotate to start from bottom left
                        .animation(.easeInOut, value: progress)
                    
                    // bronze checkpoint
                    ZStack {
                        Circle()
                            .foregroundStyle(.black)
                            .frame(width: 25)
                            .offset(y: 100)
                        
                        Circle()
                            .foregroundStyle(progress > 0.33 ? .brown : .gray.opacity(0.3))
                            .frame(width: 17.5)
                            .offset(y: 100)
                    }
                    .rotationEffect(.degrees(360 * 0.4 * 0.9))
                    
                    // silver checkpoint
                    ZStack {
                        Circle()
                            .foregroundStyle(.black)
                            .frame(width: 25)
                            .offset(y: 100)
                        
                        Circle()
                            .foregroundStyle(progress > 0.66 ? .gray : .gray.opacity(0.3))
                            .frame(width: 17.5)
                            .offset(y: 100)
                    }
                    .rotationEffect(.degrees(360 * 0.7 * 0.9))
                    
                    // gold checkpoint
                    ZStack {
                        Circle()
                            .foregroundStyle(.black)
                            .frame(width: 25)
                            .offset(y: 100)
                        
                        Circle()
                            .foregroundStyle(progress >= 1.0 ? .yellow : .gray.opacity(0.3))
                            .frame(width: 17.5)
                            .offset(y: 100)
                    }
                    .rotationEffect(.degrees(360 * 0.9))
                    
                    // labels
                    ZStack {
                        Text("Bronze")
                            .offset(x: -120, y: -80)
                            .foregroundStyle(progress >= 0.33 ? .brown : .gray.opacity(0.3))
                        
                        Text("Silver")
                            .offset(x: 110, y: -85)
                            .foregroundStyle(progress >= 0.66 ? .gray : .gray.opacity(0.3))
                        
                        Text("Gold")
                            .offset(x: 90, y: 97.5)
                            .foregroundStyle(progress >= 1.0 ? .yellow : .gray.opacity(0.3))
                    }
                    .font(.headline)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                    .foregroundStyle(.secondary)
                    
                    // medal in center
                    VStack {
                        if progress >= 1.0 {
                            Image(systemName: "medal.star.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 100)
                                .foregroundStyle(Color.yellow)
                                .symbolEffect(.bounce, options: .speed(2), value: medalUpgrade)
                            
                        } else if progress >= 0.66 {
                            Image(systemName: "medal.star.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 100)
                                .foregroundStyle(Color.gray)
                                .symbolEffect(.bounce, options: .speed(2), value: medalUpgrade)
                            
                        } else if progress >= 0.33 {
                            Image(systemName: "medal.star.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 100)
                                .foregroundStyle(Color.brown)
                                .symbolEffect(.bounce, options: .speed(2), value: medalUpgrade)
                        } else {
                            Image(systemName: "medal.star.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 100)
                                .foregroundStyle(Color.gray)
                                .opacity(0.2)
                        }
                    }
                }
                
                // tab view label
//                HStack {
//                    Text("Today")
//                        .offset(y: 5)
//                }
//                .font(.headline)
//                .fontWeight(.bold)
//                .fontDesign(.rounded)
//                .foregroundStyle(.white)
                
            }
            .frame(width: 200, height: 200)
            
        }
        .sensoryFeedback(.increase, trigger: trueCount)
        .preferredColorScheme(.dark)
        .tag(0)
        
    }
}


#Preview {
    @Previewable @State var medalUpgrade = false
    var progress = 0.666
    ProgressView(progress: progress, medalUpgrade: $medalUpgrade, trueCount: 0)
}
