//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Mark Vadimov on 10.03.26.
//

import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct count: Int, total amount: Int)
}
