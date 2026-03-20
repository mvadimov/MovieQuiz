//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Mark Vadimov on 19.03.26.
//

import Foundation

final class MovieQuizPresenter: QuestionFactoryDelegate {
    private weak var viewController: MovieQuizViewControllerProtocol?
    private var questionFactory: QuestionFactoryProtocol?
    
    private var currentQuestionIndex: Int = 0
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    private var correctAnswers = 0
    private var statisticService: StatisticServiceProtocol?
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showOrHideLoadingIndicator(isShow: true)
        setupServices()
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.viewController?.show(quiz: convert(model: question))
        }
    }
    
    func didLoadDataFromServer() {
        viewController?.showOrHideLoadingIndicator(isShow: false)
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError()
    }
    
    // MARK: Functions
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        viewController?.highlightImageBorder(isCorrect: isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResult()
        }
    }
    
    private func showNextQuestionOrResult() {
        if self.isLastQuestion() {
            guard let statisticService else {return}
            statisticService.store(correct: correctAnswers, total: self.questionsAmount)
            
            let gamesCount = statisticService.gamesCount
            let bestScore = statisticService.bestGame.correct
            let date = statisticService.bestGame.date.dateTimeString
            let accuracy = "\(String(format: "%.2f", statisticService.totalAccuracy))%"
            
            viewController?.show(quiz: QuizResultsViewModel(title: "Этот раунд окончен!",
                                                            text: "Ваш результат \(correctAnswers)/10\nКоличество сыгранных квизов: \(gamesCount)\nРекорд: \(bestScore)/10 (\(date))\nСредняя точность: \(accuracy)",
                                                            buttonText: "Попробовать еще раз"))
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: model.image,
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func handleAnswer(isYes: Bool) {
        guard let currentQuestion else { return }
        let isCorrect = isYes == currentQuestion.correctAnswer
        correctAnswers += isCorrect ? 1 : 0
        showAnswerResult(isCorrect: isCorrect)
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    private func setupServices() {
        statisticService = StatisticService()
    }
}
