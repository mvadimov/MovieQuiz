//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Mark Vadimov on 19.03.26.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
    
    func highlightImageBorder(isCorrect: Bool)
    
    func showOrHideLoadingIndicator(isShow: Bool)
    func showNetworkError()
}
