//
//  PresenterTests.swift
//  MovieQuiz
//
//  Created by Mark Vadimov on 19.03.26.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizPresenterTests: XCTestCase {
    var sut: MovieQuizPresenter!
    var viewControllerMock: MovieQuizViewControllerMock!
    
    override func setUp(){
        super.setUp()
        // Given
        viewControllerMock = MovieQuizViewControllerMock()
        sut = MovieQuizPresenter(viewController: viewControllerMock)
    }
    
    func testPresenterConvertModel() throws {
        let emptyData = Data()
        // When
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        // Then
        XCTAssertEqual(viewModel.imageData, emptyData)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
    
    func testPresenterFuncWithCurrentQuestionIndex() throws {
        XCTAssertFalse(sut.isLastQuestion())
        
        for index in 0..<9 {
            // When
            sut.switchToNextQuestion()
            
            // Then
            if index == 8 {
                XCTAssertTrue(sut.isLastQuestion())
                sut.restartGame()
                XCTAssertFalse(sut.isLastQuestion())
            } else {
                XCTAssertFalse(sut.isLastQuestion())
            }
        }
    }
}

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func show(quiz step: QuizStepViewModel) {}
    func show(quiz result: QuizResultsViewModel) {}
    func highlightImageBorder(isCorrect: Bool) {}
    func showOrHideLoadingIndicator(isShow: Bool) {}
    func showNetworkError() {}
}
