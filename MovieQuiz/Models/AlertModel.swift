//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Mark Vadimov on 10.03.26.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let action: () -> Void
}
