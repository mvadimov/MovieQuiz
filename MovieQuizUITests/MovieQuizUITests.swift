//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Mark Vadimov on 18.03.26.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
    func testYesButton() throws {
        sleep(3)
        let firstPoster = app.images[AccessibilityIdentifiers.poster]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts[AccessibilityIdentifiers.index]
        XCTAssertEqual(indexLabel.label, "1/10")
        
        app.buttons[AccessibilityIdentifiers.yesButton].tap()
        sleep(3)
        
        let secondPoster = app.images[AccessibilityIdentifiers.poster]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testNoButton() throws {
        sleep(3)
        let firstPoster = app.images[AccessibilityIdentifiers.poster]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts[AccessibilityIdentifiers.index]
        XCTAssertEqual(indexLabel.label, "1/10")
        
        app.buttons[AccessibilityIdentifiers.noButton].tap()
        
        sleep(3)
        let secondPoster = app.images[AccessibilityIdentifiers.poster]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testShowResultAlert() throws {
        let indexLabel = app.staticTexts[AccessibilityIdentifiers.index]
        
        for index in 0..<10 {
            sleep(1)
            XCTAssertEqual(indexLabel.label, "\(index + 1)/10")
            app.buttons[AccessibilityIdentifiers.yesButton].tap()
        }
        
        sleep(3)
        let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.waitForExistence(timeout: 2))
        
        XCTAssertTrue(alert.staticTexts["Этот раунд окончен!"].exists)
        XCTAssertEqual(alert.buttons.firstMatch.label, "Попробовать еще раз")
        
        alert.buttons.firstMatch.tap()
        
        XCTAssertFalse(alert.waitForExistence(timeout: 2))
        XCTAssertEqual(indexLabel.label, "1/10")
    }
}

