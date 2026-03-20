//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Mark Vadimov on 18.03.26.
//

import XCTest

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
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "1/10")
        
        app.buttons["Yes"].tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testNoButton() throws {
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "1/10")
        
        app.buttons["No"].tap()
        
        sleep(3)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testShowResultAlert() throws {
        let indexLabel = app.staticTexts["Index"]
        
        for index in 0..<10 {
            sleep(1)
            XCTAssertEqual(indexLabel.label, "\(index + 1)/10")
            app.buttons["Yes"].tap()
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
