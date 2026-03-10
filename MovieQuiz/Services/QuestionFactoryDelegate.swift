//
//  QuestionFactoryProtocol 2.swift
//  MovieQuiz
//
//  Created by Mark Vadimov on 10.03.26.
//


protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
