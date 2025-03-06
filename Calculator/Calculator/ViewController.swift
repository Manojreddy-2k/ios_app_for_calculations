//
//  ViewController.swift
//  Calculator
//
//  Created by Manoj on 3/5/25.
//
import UIKit

class ViewController: UIViewController {
    
    var displayLabel = UILabel()
    var buttons: [[String]] = [
        ["sin", "cos", "tan", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["C", "0", "=", ""]
    ]
    
    var currentInput: String = "0"
    var previousNumber: Double = 0
    var currentOperation: String? = nil
    var isTrigonometricMode: Bool = false
    var trigFunction: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .black
        
     
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        displayLabel.text = "0"
        displayLabel.textAlignment = .right
        displayLabel.font = UIFont.systemFont(ofSize: 40)
        displayLabel.textColor = .white
        displayLabel.backgroundColor = .darkGray
        displayLabel.layer.cornerRadius = 10
        displayLabel.clipsToBounds = true
        view.addSubview(displayLabel)
        

        NSLayoutConstraint.activate([
            displayLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            displayLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            displayLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            displayLabel.heightAnchor.constraint(equalToConstant: 80)
        ])
        

        let buttonsStackView = UIStackView()
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.axis = .vertical
        buttonsStackView.alignment = .fill
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.spacing = 10
        view.addSubview(buttonsStackView)
        
        for row in buttons {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.alignment = .fill
            rowStack.distribution = .fillEqually
            rowStack.spacing = 10
            for buttonTitle in row {
                if buttonTitle.isEmpty { continue }
                let button = UIButton(type: .system)
                button.setTitle(buttonTitle, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
                button.layer.cornerRadius = 10
                button.clipsToBounds = true
                
                if ["÷", "×", "-", "+"].contains(buttonTitle) {
                    button.backgroundColor = .orange
                } else if ["sin", "cos", "tan"].contains(buttonTitle) {
                    button.backgroundColor = .blue
                } else {
                    button.backgroundColor = .gray
                }
                button.setTitleColor(.white, for: .normal)
                button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
                rowStack.addArrangedSubview(button)
            }
            buttonsStackView.addArrangedSubview(rowStack)
        }
        
        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: displayLabel.bottomAnchor, constant: 20),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonsStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        guard let buttonText = sender.titleLabel?.text else { return }
        
        switch buttonText {
        case "C":
            // Clear all inputs and reset states
            currentInput = "0"
            previousNumber = 0
            currentOperation = nil
            isTrigonometricMode = false
            trigFunction = nil
            displayLabel.text = "0"
            
        case "÷", "×", "-", "+":
            // Save the current number and operation
            if let num = Double(currentInput) {
                previousNumber = num
                currentInput = "0"
                currentOperation = buttonText
                isTrigonometricMode = false
                trigFunction = nil
            }
            
        case "=":
            if let operation = currentOperation, let num = Double(currentInput) {
                let result: Double
                switch operation {
                case "÷": result = previousNumber / num
                case "×": result = previousNumber * num
                case "-": result = previousNumber - num
                case "+": result = previousNumber + num
                default: return
                }
                currentInput = "\(result)"
                currentOperation = nil
                displayLabel.text = currentInput
                
            } else if isTrigonometricMode, let num = Double(currentInput), let trigOp = trigFunction {

                let radians = num * .pi / 180
                
                if trigOp == "tan" && abs(cos(radians)) < 0.000001 {
                    displayLabel.text = "\(trigOp)(\(num)) = undefined"
                    currentInput = "0"
                } else {
                    let result: Double
                    switch trigOp {
                    case "sin": result = sin(radians)
                    case "cos": result = cos(radians)
                    case "tan": result = tan(radians)
                    default: return
                    }
                    
                    let roundedResult = round(result * 1_000_000) / 1_000_000
                    currentInput = "\(roundedResult)"
                    displayLabel.text = "\(trigOp)(\(num)) = \(currentInput)"
                }
                isTrigonometricMode = false
                trigFunction = nil
            }
            
        case "sin", "cos", "tan":
            isTrigonometricMode = true
            trigFunction = buttonText
            displayLabel.text = "\(buttonText)("
            
        default:
            if isTrigonometricMode {
                if currentInput == "0" {
                    currentInput = buttonText
                } else {
                    currentInput += buttonText
                }
                displayLabel.text = "\(trigFunction!)(\(currentInput))"
            } else {
                if currentInput == "0" {
                    currentInput = buttonText
                } else {
                    currentInput += buttonText
                }
                displayLabel.text = currentInput
            }
        }
    }
}
