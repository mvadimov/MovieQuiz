//
//  GameResultModel.swift
//  MovieQuiz
//
//  Created by Mark Vadimov on 10.03.26.
//

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetter(than other: GameResult) -> Bool {
        return correct > other.correct
    }
}
