//
//  PipesView.swift
//  FlappyBird
//
//  Created by abd ul’Karim 📚 on 29.07.2024.
//

import SwiftUI

struct PipesView: View {
    let topPipeHeight: Double
    let pipeWidth: Double
    let pipeSpacing: Double
    
    var body: some View {
        // top pipe
        GeometryReader { geometry in
            VStack {
                Image(.flappeBirdPipe)
                    .resizable()
                    .rotationEffect(.degrees(180))
                    .frame(width: pipeWidth, height: topPipeHeight)
                
                Spacer(minLength: pipeSpacing)
                
                // lower pipe
                Image(.flappeBirdPipe)
                    .resizable()
                    .frame(
                        width: pipeWidth,
                        height: geometry.size.height - topPipeHeight - pipeSpacing
                    )
            }
        }
    }
}

#Preview {
    PipesView(topPipeHeight: 300, pipeWidth: 100, pipeSpacing: 100)
}
