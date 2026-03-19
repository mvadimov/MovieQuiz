import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet private weak var indexLabel: UILabel!
    @IBOutlet private weak var previewImage: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var currentQuestionIndex = 0

    private var alertPresenter = AlertPresenter()
    private var statisticService: StatisticServiceProtocol?
    
    private var correctAnswers = 0
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    weak var delegate: QuestionFactoryDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupServices()
        setupQuestionFactory()
        
        showOrHideLoadingIndicator(isShow: true)
        questionFactory?.loadData()
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }

        currentQuestion = question

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.show(quiz: self.convert(model: question))
        }
    }
    
    func didLoadDataFromServer() {
        showOrHideLoadingIndicator(isShow: false)
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError()
    }
    
    
    // MARK: Private functions
    private func show(quiz step: QuizStepViewModel){
        indexLabel.text = step.questionNumber
        previewImage.image = step.image
        questionLabel.text = step.question
        
        previewImage.layer.borderWidth = 0
        self.noButton.isEnabled = true
        self.yesButton.isEnabled = true
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let model = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText, action: { [weak self] in
            guard let self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
        })
        
        alertPresenter.show(in: self, model: model)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image:  UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        previewImage.layer.masksToBounds = true
        previewImage.layer.borderWidth = 8
        previewImage.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        correctAnswers += isCorrect ? 1 : 0
        noButton.isEnabled = false
        yesButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            self.showNextQuestionOrResult()
        }
    }
    
    private func showNextQuestionOrResult() {
        if currentQuestionIndex == questionsAmount - 1 {
            guard let statisticService else {return}
            statisticService.store(correct: correctAnswers, total: questionsAmount)

            let gamesCount = statisticService.gamesCount
            let bestScore = statisticService.bestGame.correct
            let date = statisticService.bestGame.date.dateTimeString
            let accuracy = "\(String(format: "%.2f", statisticService.totalAccuracy))%"
            
            show(quiz: QuizResultsViewModel(title: "Этот раунд окончен!",
                                            text: "Ваш результат \(correctAnswers)/10\nКоличество сыгранных квизов: \(gamesCount)\nРекорд: \(bestScore)/10 (\(date))\nСредняя точность: \(accuracy)",
                                            buttonText: "Попробовать еще раз"))
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func setupServices() {
        statisticService = StatisticService()
    }

    private func setupQuestionFactory() {
        let questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory.delegate = self
        self.questionFactory = questionFactory
        questionFactory.requestNextQuestion()
    }
    
    private func handleAnswer(isYes: Bool) {
        guard let currentQuestion else { return }
        let isCorrect = isYes == currentQuestion.correctAnswer
        showAnswerResult(isCorrect: isCorrect)
    }
    
    private func showOrHideLoadingIndicator(isShow: Bool) {
        if isShow {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    private func showNetworkError() {
        showOrHideLoadingIndicator(isShow: false)
        
        let model = AlertModel(title: "Что-то пошло не так(", message: "Невозможно загрузить данные", buttonText: "Попробовать еще раз", action: { [weak self] in
            guard let self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
        })
        
        alertPresenter.show(in: self, model: model)
    }
    
    // MARK: Actions
    @IBAction private func noButtonClicked(_ sender: Any) {
        handleAnswer(isYes: false)
    }
    
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        handleAnswer(isYes: true)
    }
}
