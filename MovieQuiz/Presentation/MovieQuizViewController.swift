import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    @IBOutlet private weak var indexLabel: UILabel!
    @IBOutlet private weak var previewImage: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: MovieQuizPresenter!
    private var alertPresenter = AlertPresenter()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        activityIndicator.hidesWhenStopped = true
        addAccessibilityIdentifiers()
    }
    
    func show(quiz step: QuizStepViewModel){
        indexLabel.text = step.questionNumber
        previewImage.image = UIImage(data: step.imageData) ?? UIImage()
        questionLabel.text = step.question
        
        previewImage.layer.borderWidth = 0
        self.noButton.isEnabled = true
        self.yesButton.isEnabled = true
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let model = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText, action: { [weak self] in
            guard let self else { return }
            self.presenter.restartGame()
        })
        alertPresenter.show(in: self, model: model)
    }
    
    func highlightImageBorder(isCorrect: Bool) {
        previewImage.layer.masksToBounds = true
        previewImage.layer.borderWidth = 8
        previewImage.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        noButton.isEnabled = false
        yesButton.isEnabled = false
    }
    
    func showOrHideLoadingIndicator(isShow: Bool) {
        if isShow {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func showNetworkError() {
        showOrHideLoadingIndicator(isShow: false)
        
        let model = AlertModel(title: "Что-то пошло не так(", message: "Невозможно загрузить данные", buttonText: "Попробовать еще раз", action: { [weak self] in
            guard let self else { return }
            self.presenter.restartGame()
        })
        
        alertPresenter.show(in: self, model: model)
    }
    
    private func addAccessibilityIdentifiers() {
        previewImage.accessibilityIdentifier = AccessibilityIdentifiers.poster
        indexLabel.accessibilityIdentifier = AccessibilityIdentifiers.index
        yesButton.accessibilityIdentifier = AccessibilityIdentifiers.yesButton
        noButton.accessibilityIdentifier = AccessibilityIdentifiers.noButton
    }
    
    // MARK: Actions
    @IBAction func noButtonClicked(_ sender: Any) {
        presenter.handleAnswer(isYes: false)
    }
    
    
    @IBAction func yesButtonClicked(_ sender: Any) {
        presenter.handleAnswer(isYes: true)
        
    }
}
