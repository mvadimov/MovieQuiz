//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Mark Vadimov on 10.03.26.
//

import UIKit

final class QuestionFactory: QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoading
    weak var delegate: QuestionFactoryDelegate?
    private var movies: [MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader.loadMovies(handler: { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                
                switch result {
                case .success(let movies):
                    self.movies = movies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        })
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.didFailToLoadData(with: error)
                }
                return
            }
            
            let questionData = generateRatingQuestion(movieRating: Float(movie.rating) ?? 0)
            let text = questionData.text
            let correctAnswer = questionData.correctAnswer
            
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
    
    func generateRatingQuestion(movieRating: Float) -> (text: String, correctAnswer: Bool) {
        let roundedRating = round(movieRating * 10) / 10
        var questionRating: Float
        
        if roundedRating > 9.5 {
            questionRating = Float(Int.random(in: 8...10))
        } else if roundedRating < 0.5 {
            questionRating = Float(Int.random(in: 1...3))
        } else {
            questionRating = roundedRating + Float.random(in: -0.2...0.2)
        }
        let roundedQuestionRating = round(questionRating * 10) / 10
        
        let text = "Рейтинг этого фильма больше чем \(roundedQuestionRating)?"
        let correctAnswer = roundedRating > roundedQuestionRating
        
        return (text, correctAnswer)
    }
}
