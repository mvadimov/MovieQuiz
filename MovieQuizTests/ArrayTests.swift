//
//  ArrayTests.swift
//  MovieQuiz
//
//  Created by Mark Vadimov on 18.03.26.
//


import XCTest
@testable import MovieQuiz

class ArrayTest: XCTestCase {
    func testGetValueInRange() throws {
        // Given
        let array = [1, 1, 2, 3, 5]
        
        // When
        let value = array[safe: 2]
        
        // Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
    
    func testGetValueOutOfRange() throws {
        // Given
        let array = [1, 1, 2, 3, 5]
        // When
        let value = array[safe: 5]
        
        // Then
        XCTAssertNil(value)
        
    }
}
