//
//  InputPinViewController.swift
//  vezdecod-pincode
//
//  Created by Александр on 24.04.2021.
//

import UIKit

final class InputPinViewController: UIViewController {

    var didSendPincode: ((String) -> Void)?
    var didAuthAttempt: ((String) -> Void)?
    
    enum InputState {
        case first
        case retry
        case auth
    }
    
    var state: InputState {
        didSet {
            if state == .first {
                self.firstInput()
            } else if state == .retry {
                self.retryInput()
            } else if state == .auth {
                self.authInput()
            }
        }
    }
    @IBOutlet weak var dotsStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    private var firstPin: String?
    private var retryPin: String?
    private var numbers: [String] = []
    
    init(state: InputState) {
        self.state = state
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        // Do any additional setup after loading the view.
    }

    private func setup() {
        if state == .first {
            self.firstInput()
        } else if state == .retry {
            self.retryInput()
        } else if state == .auth {
            self.authInput()
        }
        
        for index in 0...5 {
            let dotView = UIView()
            dotView.translatesAutoresizingMaskIntoConstraints = false
            dotView.widthAnchor.constraint(equalToConstant: 16).isActive = true
            dotView.layer.cornerRadius = 8
            dotView.layer.masksToBounds = true
            dotView.tag = index
            dotView.layer.borderWidth = 1
            dotView.layer.borderColor = UIColor.black.cgColor
            dotsStackView.addArrangedSubview(dotView)
        }
    }
    
    func changeTitle(string: String) {
        self.titleLabel.text = string
        clearDots()
    }
    
    @IBAction private func onDidNumberTapped(_ sender: UIButton) {
        numbers.append(String(sender.tag))
        updatePins()
        if numbers.count >= 6 {
            if state == .first {
                self.firstPin = numbers.joined()
                self.state = .retry
            } else if state == .retry {
                self.retryPin = numbers.joined()
                if let pincode = checkPins() {
                    self.didSendPincode?(pincode)
                } else {
                    
                }
            } else if state == .auth {
                let pin = numbers.joined()
                self.didAuthAttempt?(pin)
            }
        }
    }
    
    @IBAction func onDidBackTapped(_ sender: Any) {
        if numbers.count > 0 {
            numbers.removeLast(1)
            updatePins()
        }
    }
    
    
    private func authInput() {
        clearDots()
        self.titleLabel.text = "Введите PIN код"
    }
    
    private func firstInput() {
        clearDots()
        self.titleLabel.text = "Введите новый PIN код"
    }
    
    private func retryInput() {
        clearDots()
        self.titleLabel.text = "Введите PIN еще раз"
    }
    
    private func clearDots() {
        numbers = []
        dotsStackView.arrangedSubviews.forEach { (dView) in
            dView.layer.borderColor = UIColor.black.cgColor
            dView.backgroundColor = .clear
        }
    }
    
    private func updatePins() {
        for (_, view) in self.dotsStackView.arrangedSubviews.enumerated() {
            if view.tag < numbers.count {
                view.backgroundColor = .black
            } else {
                view.backgroundColor = .clear
            }
        }
    }
    
    private func checkPins() -> String? {
        if let first = self.firstPin, let second = self.retryPin {
            if first == second {
                if PinService.canCorrectPincode(code: first) {
                    return first
                }
            }
        }
        
        return nil
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
