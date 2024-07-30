//
//  ResultView.swift
//  FlappyBird
//
//  Created by abd ul’Karim 📚 on 29.07.2024.
//

import SwiftUI

struct ResultView: View {
    let score: Int
    let highScore: Int
    let resetAction: () -> Void
    
    var body: some View {
        VStack {
            Text("Game Over")
                .font(.largeTitle)
                .foregroundStyle(.black)
                .padding()
            Text("Score: \(score)")
                .font(.title)
                .foregroundStyle(.black)
            Text("Best: \(highScore)")
                .foregroundStyle(.red)
                .padding()
            Button("RESET", action: resetAction)
                .padding()
                .background(.blue)
                .foregroundColor(.white)
                .clipShape(.rect(cornerRadius: 10))
                .padding(/*@START_MENU_TOKEN@*/EdgeInsets()/*@END_MENU_TOKEN@*/)
            
        }
        .background(.white.opacity(0.8))
        .clipShape(.rect(cornerRadius: 20))
    }
}

#Preview {
    ResultView(score: 5, highScore: 3, resetAction: {})
}
