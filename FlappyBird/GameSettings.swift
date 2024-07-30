//
//  GameSettings.swift
//  FlappyBird
//
//  Created by abd ul’Karim 📚 on 29.07.2024.
//

/// Структура, содержащая настройки игры Flappy Bird.
struct GameSettings {
    /// Ширина трубы.
    let pipeWidth: Double
    /// Минимальная высота трубы.
    let minPipeHeight: Double
    /// Максимальная высота трубы.
    let maxPipeHeight: Double
    /// Расстояние между трубами.
    let pipeSpacing: Double
    /// Скорость движения труб.
    let pipeSpeed: Double
    /// Сила прыжка птицы.
    let jumpVelocity: Int
    /// Сила гравитации.
    let gravity: Double
    /// Высота грунта.
    let groundHeight: Double
    /// Размер представления птицы.
    let birdSize: Double
    /// Реальный радиус птицы.
    let birdRadius: Double

    /// Возвращает экземпляр `GameSettings` с настройками по умолчанию.
    static var defaultSettings: GameSettings {
        GameSettings(
            pipeWidth: 100,        // Ширина трубы по умолчанию
            minPipeHeight: 100,    // Минимальная высота трубы по умолчанию
            maxPipeHeight: 500,    // Максимальная высота трубы по умолчанию
            pipeSpacing: 150,      // Расстояние между трубами по умолчанию
            pipeSpeed: 300,        // Скорость движения труб по умолчанию
            jumpVelocity: -400,    // Сила прыжка птицы по умолчанию
            gravity: 1100,         // Сила гравитации по умолчанию
            groundHeight: 100,     // Высота грунта по умолчанию
            birdSize: 50,          // Размер представления птицы по умолчанию
            birdRadius: 13         // Радиус птицы по умолчанию
        )
    }
}
