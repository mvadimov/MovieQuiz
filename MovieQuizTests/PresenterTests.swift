//
//  PresenterTests.swift
//  MovieQuiz
//
//  Created by Mark Vadimov on 19.03.26.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertEqual(viewModel.image, emptyData)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func show(quiz step: QuizStepViewModel) {
    }
    
    func show(quiz result: QuizResultsViewModel) {
    
    }
    
    func highlightImageBorder(isCorrect: Bool) {
    
    }
    
    func showOrHideLoadingIndicator(isShow: Bool) {
    
    }
    
    func showNetworkError() {
    
    }
}
