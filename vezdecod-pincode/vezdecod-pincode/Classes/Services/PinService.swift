//
//  PinService.swift
//  vezdecod-pincode
//
//  Created by Александр on 24.04.2021.
//

import UIKit

class PinService: NSObject {

    static let numbersCodeCount: Int = 6
    static let salt: String = "happyvezdecode"
    static let pincodeDefaultsKey = "PincodeContainer"
    static let localAuthDefaultsKey = "localAuthDefaultsKey"
    
    static let shared = PinService()
    
    var isLocalAuth: Bool {
        set { UserDefaults.standard.setValue(newValue, forKey: PinService.localAuthDefaultsKey)
              UserDefaults.standard.synchronize()
        }
        get { UserDefaults.standard.bool(forKey: PinService.localAuthDefaultsKey)}
    }
    var isPincodeInstalled: Bool {
        if let _ = UserDefaults.standard.string(forKey: PinService.pincodeDefaultsKey) {
            return true
        }
        
        return false
    }
    
    class func canCorrectPincode(code: String) -> Bool {
        
        guard code.count == PinService.numbersCodeCount else {
            return false
        }
        
        if code.count == PinService.numbersCodeCount {
            for char in code {
                let cString = String(char)
                if Int(cString) == nil {
                    return false
                }
            }
        }
    
        return true
    }
    
    func setPin(code: String) {
        let hash = "\(code)\(PinService.salt)".md5
        UserDefaults.standard.setValue(hash, forKey: PinService.pincodeDefaultsKey)
        UserDefaults.standard.synchronize()
    }
    
    func check(code: String) -> Bool {
        guard let curentPincode = UserDefaults.standard.string(forKey: PinService.pincodeDefaultsKey) else {
            return false
        }
        
        let hash = "\(code)\(PinService.salt)".md5
        return curentPincode == hash
    }
    
}
