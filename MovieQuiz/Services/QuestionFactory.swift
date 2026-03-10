//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Mark Vadimov on 10.03.26.
//

import UIKit

final class QuestionFactory: QuestionFactoryProtocol {
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: UIImage(imageLiteralResourceName: "The Godfather"),
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: UIImage(imageLiteralResourceName: "The Dark Knight"),
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: UIImage(imageLiteralResourceName: "Kill Bill"),
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: UIImage(imageLiteralResourceName: "The Avengers"),
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: UIImage(imageLiteralResourceName: "Deadpool"),
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: UIImage(imageLiteralResourceName: "The Green Knight"),
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: UIImage(imageLiteralResourceName: "Old"),
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: UIImage(imageLiteralResourceName: "The Ice Age Adventures of Buck Wild"),
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: UIImage(imageLiteralResourceName: "Tesla"),
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: UIImage(imageLiteralResourceName: "Vivarium"),
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)
    ]
    
    weak var delegate: QuestionFactoryDelegate?
    
    func requestNextQuestion() {
        guard let index = (0..<questions.count).randomElement() else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }

        let question = questions[safe: index]
        delegate?.didReceiveNextQuestion(question: question)
    }
}
