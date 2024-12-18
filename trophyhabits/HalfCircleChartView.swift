//
//  HalfCircleChartView.swift
//  trophyhabits
//
//  Created by Landon West on 12/17/24.
//


import SwiftUI

struct HalfCircleChartView: View {
    @State private var starCount: Int = 0 // Number of stars (0 to 3)
    
    var body: some View {
        VStack {
            // Half-circle chart
            ZStack {
                // Background Arc (Empty state)
                HalfCircleShape()
                    .stroke(lineWidth: 20)
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .foregroundColor(.gray.opacity(0.2))
                
                // Colored Progress Arc
                HalfCircleShape()
                    .trim(from: 0.0, to: progress(for: starCount))
                    .stroke(gradientColor(for: starCount),
                            style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    //.rotationEffect(.degrees(180))
                    .animation(.easeInOut(duration: 1), value: starCount)
            }
            .frame(width: 200, height: 100)
            .padding()
            
            // Star Count Label
            Text("Stars: \(starCount)")
                .font(.title)
                .padding()
            
            // Buttons to Update Stars
            HStack {
                Button("0 Stars") { starCount = 0 }
                Button("1 Star") { starCount = 1 }
                Button("2 Stars") { starCount = 2 }
                Button("3 Stars") { starCount = 3 }
            }
            .buttonStyle(.bordered)
        }
    }
    
    // Calculates progress (trim value) based on the star count
    func progress(for count: Int) -> CGFloat {
        switch count {
        case 1: return 0.33
        case 2: return 0.66
        case 3: return 1.0
        default: return 0.0
        }
    }
    
    // Returns gradient color based on the star count
    func gradientColor(for count: Int) -> LinearGradient {
        switch count {
        case 1: return LinearGradient(colors: [.brown], startPoint: .leading, endPoint: .trailing)
        case 2: return LinearGradient(colors: [.gray], startPoint: .leading, endPoint: .trailing)
        case 3: return LinearGradient(colors: [.yellow], startPoint: .leading, endPoint: .trailing)
        default: return LinearGradient(colors: [.clear], startPoint: .leading, endPoint: .trailing)
        }
    }
}

// Half-Circle Shape
struct HalfCircleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.maxY),
                    radius: rect.width / 2,
                    startAngle: .degrees(0),
                    endAngle: .degrees(180),
                    clockwise: true)
        return path
    }
}

struct HalfCircleChartView_Previews: PreviewProvider {
    static var previews: some View {
        HalfCircleChartView()
    }
}
