//
//  MainViewController.swift
//  vezdecod-pincode
//
//  Created by Александр on 24.04.2021.
//

import UIKit
import LocalAuthentication

class MainViewController: UIViewController {

    @IBOutlet private weak var addPinButton: UIButton!
    @IBOutlet private weak var changePinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        // Do any additional setup after loading the view.
    }
    
    @objc func didBecomeActive() {
        refreshState()
        auth()
    }
    
    private func auth() {
        
        if PinService.shared.isLocalAuth == true {
            let context = LAContext()
//            var error: NSError?

//            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Identify yourself!"

                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in

                    DispatchQueue.main.async {
                        if success {
                            return
                        } else {
                            self?.pinAuthorize()
                        }
                    }
                }
//            }
        } else {
            pinAuthorize()
        }
    }
    
    private func pinAuthorize() {
        if PinService.shared.isPincodeInstalled {
            let pinVC = InputPinViewController.init(state: .auth)
            pinVC.modalPresentationStyle = .fullScreen
            self.present(pinVC, animated: true, completion: nil)
            pinVC.didAuthAttempt = { code in
                if PinService.shared.check(code: code) == true {
                    self.refreshState()
                    pinVC.dismiss(animated: true, completion: nil)
                } else {
                    pinVC.changeTitle(string: "Неправильный код. Введите еще раз")
                }
            }
        }
    }

    private func setup() {
        navigationItem.title = "Главный экран"
//        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.willResignActiveNotification, object: nil)
        refreshState()
        auth()
    }
    
    func refreshState() {
        self.addPinButton.isHidden = PinService.shared.isPincodeInstalled
        self.changePinButton.isHidden = !PinService.shared.isPincodeInstalled
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Actions
    
    func checLocalAuth() {
        let context = LAContext()
        let type: BiometricType = context.biometricType
        
        if type != .none {
            let actionsheet = UIAlertController.init(title: "Выбрать аутентификацию", message: nil, preferredStyle: .actionSheet)
            let title = context.biometryType == .touchID ? "Touch ID" : "Face ID"
            let action = UIAlertAction.init(title: title, style: .default) { (action) in
                let context = LAContext()
                let reason = "Identify yourself!"

                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in
                    DispatchQueue.main.async {
                        if success {
                            PinService.shared.isLocalAuth = true
                        } else {
                            PinService.shared.isLocalAuth = false
                        }
                    }
                }
            }
            let continueAction = UIAlertAction.init(title: "Пропустить", style: .cancel, handler: nil)
            actionsheet.addAction(action)
            actionsheet.addAction(continueAction)
            self.present(actionsheet, animated: true, completion: nil)
        }
        
    }
    
    func showInputPinController() {
        let pinVC = InputPinViewController(state: .first)
        pinVC.modalPresentationStyle = .fullScreen
        pinVC.didSendPincode = { pincode in
            pinVC.dismiss(animated: true) {
                self.checLocalAuth()
                PinService.shared.setPin(code: pincode)
                self.refreshState()
            }
        }
        self.present(pinVC, animated: true, completion: nil)
    }
    
    @IBAction func onDidAddPinButtonTapped(_ sender: Any) {
        showInputPinController()
    }
    
    @IBAction func onDidChangePinButtonTapped(_ sender: Any) {
        showInputPinController()
    }
    

}
