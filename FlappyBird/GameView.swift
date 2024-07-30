//
//  GameView.swift
//  FlappyBird
//
//  Created by abd ul’Karim 📚 on 29.07.2024.
//

import SwiftUI

enum GameState {
    case ready, active, stopped
}

struct GameView: View {
    @State private var gameState: GameState = .ready
    
    @State private var birdPosition = CGPoint(x: 100, y: 300)
    @State private var birdVelocity = CGVector(dx: 0, dy: 0)
    
    @State private var topPipeHeight = Double.random(in: 100...500)
    @State private var pipeOffset = 0.0
    @State private var passedPipe = false
    
    @State private var scores = 0
    @AppStorage(wrappedValue: 0, "highScore") private var highScore: Int
    
    @State private var lastUpdateTime = Date()
    
    private let defaultSettings = GameSettings.defaultSettings
    
    private let timer = Timer.publish(
        every: 0.01,
        on: .main,
        in: .common
    ).autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                ZStack {
                    Image(.flappyBirdBackground)
                        .resizable()
                        .scaleEffect(
                            CGSize(
                                width: geometry.size.width * 0.003,
                                height: geometry.size.height * 0.0017
                            )
                    )
                    BirdView(birdSize: defaultSettings.birdSize)
                        .position(birdPosition)
                    
                    PipesView(
                        topPipeHeight: topPipeHeight,
                        pipeWidth: defaultSettings.pipeWidth,
                        pipeSpacing: defaultSettings.pipeSpacing
                    )
                    .offset(x: geometry.size.width + pipeOffset)
                    
                    if gameState == .ready {
                        Button(action: playButtonAction) {
                            Image(systemName: "play.fill")
                                .scaleEffect(x: 3.5, y: 3.5)
                        }
                        .foregroundColor(.white)
                    }

                    if gameState == .stopped {
                        ResultView(score: scores, highScore: highScore) {
                            resetGame()
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Text(scores.formatted())
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                            .padding()
                    }
                }
                .onTapGesture {
                    if gameState == .active {
                        // Устанавливает вертикальную скорость вверх
                        birdVelocity = CGVector(dx: 0, dy: defaultSettings.jumpVelocity)
                    }
                }
                .onReceive(timer) { currentTime in
                    guard gameState == .active else { return }
                    let deltaTime = currentTime.timeIntervalSince(lastUpdateTime)
                    
                    applyGravity(deltaTime: deltaTime)
                    updateBirdPosition(deltaTime: deltaTime)
                    checkBoundaries(geometry: geometry)
                    updatePipePosition(deltaTime: deltaTime)
                    resetPipePositionIfNeeded(geometry: geometry)
                    
                    if checkCollision(with: geometry) {
                        gameState = .stopped
                    }
                    
                    updateScoresAndHighScore(geometry: geometry)
                    
                    lastUpdateTime = currentTime
                }
            }
            
        }
    }
    
    // Действие по нажатию на кнопку Play
    private func playButtonAction() {
        gameState = .active
        lastUpdateTime = Date()
    }
    
    // Действие по нажатию на кнопку Reset
    private func resetGame() {
        birdPosition = CGPoint(x: 100, y: 300)
        birdVelocity = CGVector(dx: 0, dy: 0)
        pipeOffset = 0
        topPipeHeight = Double.random(
            in: defaultSettings.minPipeHeight...defaultSettings.maxPipeHeight
        )
        scores = 0
        gameState = .ready
    }
    
    // Эффект гравитации
    private func applyGravity(deltaTime: TimeInterval) {
        birdVelocity.dy += Double(defaultSettings.gravity * deltaTime)
    }

    // Обновление позиции птицы, учитывая её текущую скорость.
    private func updateBirdPosition(deltaTime: TimeInterval) {
        birdPosition.y += birdVelocity.dy * Double(deltaTime)
    }

    // Остановка падения птицы на уровне грунта
    // Ограничение высоты полёта
    private func checkBoundaries(geometry: GeometryProxy) {
        // Проверка, не достигла ли птица верхней границы экрана
        if birdPosition.y <= 0 {
            birdPosition.y = 0
        }
        // Проверка, не достигла ли птица грунта
        if birdPosition.y > geometry.size.height - defaultSettings.groundHeight - defaultSettings.birdSize / 2 {
            birdPosition.y = geometry.size.height - defaultSettings.groundHeight - defaultSettings.birdSize / 2
            birdVelocity.dy = 0
        }
    }

    // Обновление положения столбов
    private func updatePipePosition(deltaTime: TimeInterval) {
        pipeOffset -= Double(defaultSettings.pipeSpeed * deltaTime)
    }

    // Установка столбов на начальную позицию по завершению цикла
    private func resetPipePositionIfNeeded(geometry: GeometryProxy) {
        if pipeOffset <= -geometry.size.width - defaultSettings.pipeWidth {
            pipeOffset = 0
            topPipeHeight = Double.random(in: defaultSettings.minPipeHeight...defaultSettings.maxPipeHeight)
        }
    }
    
    private func checkCollision(with geometry: GeometryProxy) -> Bool {

        // Создаем прямоугольник вокруг птицы
        // Позиция птицы `birdPosition` устанавливается в центр прямоугольника
        let birdFrame = CGRect(
            x: birdPosition.x - defaultSettings.birdRadius / 2,
            y: birdPosition.y - defaultSettings.birdRadius / 2,
            width: defaultSettings.birdRadius,
            height: defaultSettings.birdRadius
        )

        // Создаем прямоугольник вокруг верхнего столба
        let topPipeFrame = CGRect(
            x: geometry.size.width + pipeOffset,
            y: 0,
            width: defaultSettings.pipeWidth,
            height: topPipeHeight
        )
        
        // Создаем прямоугольник вокруг нижнего столба
        let bottomPipeFrame = CGRect(
            x: geometry.size.width + pipeOffset,
            y: topPipeHeight + defaultSettings.pipeSpacing,
            width: defaultSettings.pipeWidth,
            height: topPipeHeight
        )

        // Функция возвращает `true`, если прямоугольник птицы
        // пересекается с прямоугольником любого из столбов
        return birdFrame.intersects(topPipeFrame) || birdFrame.intersects(bottomPipeFrame)
    }
    
    // Функция для обновления количества набранных очков и рекорда
    private func updateScoresAndHighScore(geometry: GeometryProxy) {
        if pipeOffset + defaultSettings.pipeWidth + geometry.size.width < birdPosition.x && !passedPipe {
            scores += 1
            // Обновление рекорда
            if scores > highScore {
                highScore = scores
            }
            // Избегаем повторного увеличения счета
            passedPipe = true
        } else if pipeOffset + geometry.size.width > birdPosition.x {
            // Сброс положения труб, после их выхода за пределы экрана
            passedPipe = false
        }
    }
}

#Preview {
    GameView()
}
