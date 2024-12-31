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
        TabView {
            // Daily Progress View
            VStack(spacing: 20) {
                ZStack(alignment: .bottom) {
                    ZStack {
                        Circle()
                            .trim(from: 0.0, to: 0.8)
                            .stroke(
                                Color.gray,
                                style: StrokeStyle(lineWidth: 10, lineCap: .round)
                            )
                            .opacity(0.2)
                            .foregroundColor(.gray)
                            .rotationEffect(.degrees(126.33)) // Rotate to start from bottom left

                        Circle()
                            .trim(from: 0.0, to: min(0.25, CGFloat(progress * 0.8)))
                            .stroke(
                                .brown,
                                style: StrokeStyle(lineWidth: 10, lineCap: .round)
                            )
                            .rotationEffect(.degrees(126.33)) // Rotate to start from bottom left
                            .animation(.easeInOut, value: progress)
                        
                        Circle()
                            .trim(from: 0.25, to: min(0.525, CGFloat(progress * 0.8)))
                            .stroke(
                                .gray,
                                style: StrokeStyle(lineWidth: 10, lineCap: .round)
                            )
                            .rotationEffect(.degrees(126.33)) // Rotate to start from bottom left
                            .animation(.easeInOut, value: progress)
                        
                        Circle()
                            .trim(from: 0.525, to: CGFloat(progress * 0.8))
                            .stroke(
                                .yellow,
                                style: StrokeStyle(lineWidth: 10, lineCap: .round)
                            )
                            .rotationEffect(.degrees(126.33)) // Rotate to start from bottom left
                            .animation(.easeInOut, value: progress)
                        
                        
                        
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

                    HStack {
                        Text("Today")
                            .offset(y: 5)
                    }
                    .font(.headline)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                    .foregroundStyle(.white)

                }
                .frame(width: 200, height: 200)
                
                Spacer()
            }
            .padding(.vertical, 15)
            .sensoryFeedback(.increase, trigger: trueCount)
            .preferredColorScheme(.dark)
            .tag(0)
            
            
            
            

            // Weekly Progress View
            VStack(spacing: 20) {
//                ZStack(alignment: .bottom) {
//                    ZStack {
//                        Circle()
//                            .trim(from: 0.0, to: 0.8)
//                            .stroke(
//                                Color.gray,
//                                style: StrokeStyle(lineWidth: 10, lineCap: .round)
//                            )
//                            .opacity(0.2)
//                            .foregroundColor(.gray)
//                            .rotationEffect(.degrees(126.33)) // Rotate to start from bottom left
//
//                        Circle()
//                            .trim(from: 0.0, to: CGFloat(progress * 0.8))
//                            .stroke(
//                                progress >= 0.33 ? (progress >= 0.55 ? (progress == 1.0 ? .yellow : .gray) : .brown) : .gray.opacity(0.5),
//                                style: StrokeStyle(lineWidth: 10, lineCap: .round)
//                            )
//                            .rotationEffect(.degrees(126.33)) // Rotate to start from bottom left
//                            .animation(.easeInOut, value: progress)
//                        
//                        ZStack {
//                            Circle()
//                                .foregroundStyle(.black)
//                                .frame(width: 25)
//                                .offset(y: 100)
//                            
//                            Circle()
//                                .foregroundStyle(progress > 0.33 ? .brown : .gray.opacity(0.3))
//                                .frame(width: 17.5)
//                                .offset(y: 100)
//                        }
//                        .rotationEffect(.degrees(360 * 0.4 * 0.9))
//                        
//                        ZStack {
//                            Circle()
//                                .foregroundStyle(.black)
//                                .frame(width: 25)
//                                .offset(y: 100)
//                            
//                            Circle()
//                                .foregroundStyle(progress > 0.66 ? .gray : .gray.opacity(0.3))
//                                .frame(width: 17.5)
//                                .offset(y: 100)
//                        }
//                        .rotationEffect(.degrees(360 * 0.7 * 0.9))
//
//                        ZStack {
//                            Circle()
//                                .foregroundStyle(.black)
//                                .frame(width: 25)
//                                .offset(y: 100)
//                            
//                            Circle()
//                                .foregroundStyle(progress >= 1.0 ? .yellow : .gray.opacity(0.3))
//                                .frame(width: 17.5)
//                                .offset(y: 100)
//                        }
//                        .rotationEffect(.degrees(360 * 0.9))
//
//                        
//                        ZStack {
//                            Text("10 pts")
//                                .offset(x: -120, y: -80)
//                                .foregroundStyle(progress >= 0.33 ? .brown : .gray.opacity(0.3))
//
//                            
//                            Text("20 pts")
//                                .offset(x: 115, y: -85)
//                                .foregroundStyle(progress >= 0.66 ? .gray : .gray.opacity(0.3))
//
//                            
//                            Text("30 pts")
//                                .offset(x: 97.5, y: 100)
//                                .foregroundStyle(progress >= 1.0 ? .yellow : .gray.opacity(0.3))
//
//                        }
//                        .font(.headline)
//                        .fontWeight(.semibold)
//                        .fontDesign(.rounded)
//                        .foregroundStyle(.secondary)
//
//                        ZStack {
//                            VStack {
//                                Image(systemName: "trophy.fill")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .frame(height: 80)
//                                    .foregroundStyle(progress < 0.33 ? .gray : (progress < 0.66 ? .brown : (progress < 1.0 ? .gray : .yellow)))
//                                    .symbolEffect(.bounce, options: .speed(2), value: medalUpgrade)
//                            }
//                        }
//                    }
//
//                    HStack {
//                        Text("This Week")
//                            .offset(y: 5)
//                    }
//                    .font(.headline)
//                    .fontWeight(.bold)
//                    .fontDesign(.rounded)
//                    .foregroundStyle(.white)
//
//                }
//                .frame(width: 200, height: 200)
//                
//                Spacer()
            }
            .padding(.vertical, 15)
            .sensoryFeedback(.increase, trigger: trueCount)
            .preferredColorScheme(.dark)
            .tag(1)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
    }
}

#Preview {
    @Previewable @State var medalUpgrade = false
    var progress = 1.0
    ProgressView(progress: progress, medalUpgrade: $medalUpgrade, trueCount: 0)
}
