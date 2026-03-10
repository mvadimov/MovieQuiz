//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Mark Vadimov on 10.03.26.
//

import UIKit

final class AlertPresenter {
    func show(in vc: UIViewController, model: AlertModel) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert) // preferredStyle может быть .alert или .actionSheet(окно, всплывающее снизу)
        
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.action()
        }
        
        alert.addAction(action)
        
        vc.present(alert, animated: true)
    }
}
